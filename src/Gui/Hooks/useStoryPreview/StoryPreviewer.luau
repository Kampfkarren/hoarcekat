--!nonstrict
local ERROR_DELAY = 1

local StoryPreviewer = {}
StoryPreviewer.__index = StoryPreviewer

function StoryPreviewer.new(rootRef, setCurrentPreview)
	local self = setmetatable({}, StoryPreviewer)

	self.errorId = 0

	local display = Instance.new("ScreenGui")
	display.Name = "HoarcekatDisplay"
	display.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.display = display

	self.rootRef = rootRef
	self.setCurrentPreview = setCurrentPreview

	return self
end

function StoryPreviewer:setDisplayParent(newParent: Instance)
	self.display.Parent = newParent
end

function StoryPreviewer:setError(err)
	local id = self.errorId + 1
	self.errorId = id
	task.delay(ERROR_DELAY, function()
		if self.errorId ~= id then
			-- Error was canceled or replaced.
			return
		end
		warn(err)
	end)
end

function StoryPreviewer:cancelError()
	self.errorId += 1
end

function StoryPreviewer:setExpand(expand: boolean)
	self.expand = expand
end

function StoryPreviewer:setSelectedStory(selectedStory)
	self.selectedStory = selectedStory
end

function StoryPreviewer:updateDisplay()
	if not self.currentPreview then
		return
	end
	local target = self.currentPreview.target
	if not target then
		return
	end
	if self.expand then
		target.Parent = self.display
	else
		target.Parent = self.rootRef.current
	end
end

function StoryPreviewer:refreshPreview()
	local selectedStory = self.selectedStory
	if not selectedStory then
		self:clearPreview()
		return
	end
	local err, nextState = self:prepareState(selectedStory)
	if err then
		self:setError(err)
		return
	end
	self:clearPreview()
	self.currentPreview = nextState
	self.setCurrentPreview(self.currentPreview)
	self:updateDisplay()
end

function StoryPreviewer:clearPreview()
	self:cancelError()
	local state = self.currentPreview
	if state == nil then
		return
	end
	state:destroy()
	self.currentPreview = nil
	self.setCurrentPreview(self.currentPreview)
end

function StoryPreviewer:prepareState(selectedStory)
	local state = {
		cleanup = nil,
		monkeyRequireCache = {},
		monkeyGlobalTable = {},
		otherScriptChangedConnection = nil,
		target = nil,
	}

	function state:destroy()
		if self.otherScriptChangedConnection then
			self.otherScriptChangedConnection:Disconnect()
		end

		if self.cleanup then
			local ok, result = pcall(self.cleanup)
			if not ok then
				warn("Error cleaning up story: " .. result)
			end

			self.cleanup = nil
		end

		if self.target then
			self.target:Destroy()
		end
	end

	local function monkeyRequire(otherScript)
		if state.monkeyRequireCache[otherScript] then
			return state.monkeyRequireCache[otherScript]
		end

		if state.otherScriptChangedConnection then
			state.otherScriptChangedConnection:Disconnect()
		end

		state.otherScriptChangedConnection = otherScript.Changed:connect(function()
			self:refreshPreview()
		end)

		-- loadstring is used to avoid cache while preserving `script` (which requiring a clone wouldn't do)
		local result, parseError = loadstring(otherScript.Source, otherScript:GetFullName())
		if result == nil then
			error(("Could not parse %s: %s"):format(otherScript:GetFullName(), parseError))
			return
		end

		local fenv = setmetatable({
			require = monkeyRequire,
			script = otherScript,
			_G = state.monkeyGlobalTable,
		}, {
			__index = getfenv(),
		})

		setfenv(result, fenv)

		local output = result()
		state.monkeyRequireCache[otherScript] = output

		return output
	end

	local requireOk, result = xpcall(monkeyRequire, debug.traceback, selectedStory)
	if not requireOk then
		state:destroy()
		return "Error requiring story: " .. result, nil
	end

	state.target = Instance.new("Frame")
	state.target.Name = "Preview"
	state.target.BackgroundTransparency = 1
	state.target.Size = UDim2.fromScale(1, 1)

	local execOk, cleanup = xpcall(function()
		return result(state.target)
	end, debug.traceback)

	if not execOk then
		state:destroy()
		return "Error executing story: " .. cleanup, nil
	end

	state.cleanup = cleanup
	return nil, state
end

function StoryPreviewer:Destroy()
	-- time to clear up
end

return StoryPreviewer

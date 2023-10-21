local CoreGui = game:GetService("CoreGui")
local LogService = game:GetService("LogService")
local Selection = game:GetService("Selection")

local HIDDEN_OBJECT_SETTING_NAME = "Show Hidden Objects in Explorer"

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Assets = require(Hoarcekat.Plugin.Assets)
local EventConnection = require(script.Parent.EventConnection)
local FloatingButton = require(script.Parent.FloatingButton)
local Maid = require(Hoarcekat.Plugin.Maid)
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactRodux = require(Hoarcekat.Vendor.RoactRodux)

local e = Roact.createElement

local Preview = Roact.PureComponent:extend("Preview")

function Preview:init()
	self.rootRef = Roact.createRef()

	self:setState({
		expand = false,
		clearOutput = false,
	})

	self.currentPreview = nil
	self.errorID = 0

	local display = Instance.new("ScreenGui")
	display.Name = "HoarcekatDisplay"
	display.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.display = display

	self.openSelection = function()
		if self.currentPreview and self.currentPreview.target then
			Selection:Set({ self.currentPreview.target })

			local studioSettings = settings()

			-- This could not work as intended in the future if Roblox decides to change this setting name...
			if studioSettings.Studio[HIDDEN_OBJECT_SETTING_NAME] == false then
				warn(
					`Cannot show instance in explorer ({self.currentPreview.target:GetFullName()}) as "{HIDDEN_OBJECT_SETTING_NAME}" setting in Studio is not enabled.`
				)
			end
		end
	end

	self.expandSelection = function()
		self:setState(function(current)
			return {
				expand = not current.expand,
			}
		end)
	end

	self.toggleClearOutput = function()
		self:setState(function(current)
			return {
				clearOutput = not current.clearOutput,
			}
		end)
	end
end

function Preview:didMount()
	self:refreshPreview()
end

function Preview:didUpdate()
	self:refreshPreview()
end

function Preview:willUnmount()
	self:clearPreview()
end

local ERROR_DELAY = 1
function Preview:setError(err)
	local id = self.errorID + 1
	self.errorID = id
	task.delay(ERROR_DELAY, function()
		if self.errorID ~= id then
			-- Error was canceled or replaced.
			return
		end
		warn(err)
	end)
end

function Preview:cancelError()
	self.errorID += 1
end

function Preview:updateDisplay()
	if not self.currentPreview then
		return
	end
	local target = self.currentPreview.target
	if not target then
		return
	end

	if self.state.expand then
		target.Parent = self.display
	else
		target.Parent = self.rootRef:getValue()
	end
end

function Preview:refreshPreview(checkPreferenceToClear: boolean)
	if checkPreferenceToClear and self.state.clearOutput then
		LogService:ClearOutput()
	end

	local selectedStory = self.props.selectedStory
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
	self.display.Parent = if self.state.expand then CoreGui else nil
	self:updateDisplay()
end

function Preview:clearPreview()
	self:cancelError()
	local state = self.currentPreview
	if state == nil then
		return
	end
	state:destroy()
	self.currentPreview = nil
end

function Preview:prepareState(selectedStory)
	local state = {
		cleanup = nil,
		monkeyRequireCache = {},
		monkeyGlobalTable = {},
		monkeyRequireMaid = Maid.new(),
		target = nil,
	}

	function state:destroy()
		self.monkeyRequireMaid:DoCleaning()

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

		state.monkeyRequireMaid:GiveTask(otherScript.Changed:connect(function()
			self:refreshPreview(true)
		end))

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

function Preview:render()
	local selectedStory = self.props.selectedStory

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[Roact.Ref] = self.rootRef,
	}, {
		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
		}),

		SelectButton = selectedStory and e("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.99, 0.99),
			Size = UDim2.fromOffset(40, 40),
			ZIndex = 2,
		}, {
			Button = e(FloatingButton, {
				Activated = self.openSelection,
				Image = Assets.preview,
				ImageSize = UDim.new(0, 24),
				TooltipText = "Select story instance in Studio explorer",
				Size = UDim.new(0, 40),
			}),
		}),

		ExpandButton = selectedStory and e("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.99, -45, 0.99),
			Size = UDim2.fromOffset(40, 40),
			ZIndex = 2,
		}, {
			Button = e(FloatingButton, {
				Activated = self.expandSelection,
				TooltipText = `Render story in {if self.state.expand then "Hoarcekat" else "Studio viewport"}`,
				Image = "rbxasset://textures/ui/VR/toggle2D.png",
				ImageSize = UDim.new(0, 24),
				Size = UDim.new(0, 40),
			}),
		}),

		ClearOutputButton = selectedStory and e("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.99, -90, 0.99),
			Size = UDim2.fromOffset(40, 40),
			ZIndex = 2,
		}, {
			Button = e(FloatingButton, {
				Activated = self.toggleClearOutput,
				TooltipText = `Clear output when story is updated {if self.state.clearOutput
					then "(Enabled)"
					else "(Disabled)"}`,
				Image = Assets.clear_output,
				ImageSize = UDim.new(0, 24),
				Size = UDim.new(0, 40),
			}),
		}),

		TrackRemoved = selectedStory and e(EventConnection, {
			callback = function()
				if not selectedStory:IsDescendantOf(game) then
					self.props.endPreview()
				end
			end,
			event = selectedStory.AncestryChanged,
		}),
	})
end

return RoactRodux.connect(function(state)
	return {
		selectedStory = state.StoryPicker,
	}
end, function(dispatch)
	return {
		endPreview = function()
			dispatch({
				type = "SetSelectedStory",
			})
		end,
	}
end)(Preview)

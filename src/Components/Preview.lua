local CoreGui = game:GetService("CoreGui")
local Selection = game:GetService("Selection")

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
	self.previewRef = Roact.createRef()

	self.monkeyRequireCache = {}
	self.monkeyRequireMaid = Maid.new()

	self.monkeyGlobalTable = {}

	local display = Instance.new("ScreenGui")
	display.Name = "HoarcekatDisplay"
	display.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.display = display

	self.expand = false

	self.monkeyRequire = function(otherScript)
		if self.monkeyRequireCache[otherScript] then
			return self.monkeyRequireCache[otherScript]
		end

		-- loadstring is used to avoid cache while preserving `script` (which requiring a clone wouldn't do)
		local result, parseError = loadstring(otherScript.Source, otherScript:GetFullName())
		if result == nil then
			error(("Could not parse %s: %s"):format(otherScript:GetFullName(), parseError))
			return
		end

		local fenv = setmetatable({
			require = self.monkeyRequire,
			script = otherScript,
			_G = self.monkeyGlobalTable,
		}, {
			__index = getfenv(),
		})

		setfenv(result, fenv)

		local output = result()
		self.monkeyRequireCache[otherScript] = output

		self.monkeyRequireMaid:GiveTask(otherScript.Changed:connect(function()
			self:refreshPreview()
		end))

		return output
	end

	self.openSelection = function()
		local preview = self.previewRef:getValue()
		if preview then
			Selection:Set({ preview })
		end
	end

	self.expandSelection = function()
		self.expand = not self.expand
		self.display.Parent = self.expand and CoreGui or nil

		self:refreshPreview()
	end
end

function Preview:didMount()
	self:refreshPreview()
end

function Preview:didUpdate()
	self:refreshPreview()
end

function Preview:willUnmount()
	self.monkeyRequireMaid:DoCleaning()
end

function Preview:refreshPreview()
	if self.cleanup then
		local ok, result = pcall(self.cleanup)
		if not ok then
			warn("Error cleaning up story: " .. result)
		end

		self.cleanup = nil
	end

	local preview = self.previewRef:getValue()
	if preview ~= nil then
		preview:ClearAllChildren()
	end

	local selectedStory = self.props.selectedStory
	if selectedStory then
		self.monkeyRequireCache = {}
		self.monkeyGlobalTable = {}
		self.monkeyRequireMaid:DoCleaning()

		local requireOk, result = xpcall(self.monkeyRequire, debug.traceback, selectedStory)
		if not requireOk then
			warn("Error requiring story: " .. result)
			return
		end

		local execOk, cleanup = xpcall(function()
			return result(self.expand and self.display or self.previewRef:getValue())
		end, debug.traceback)

		if not execOk then
			warn("Error executing story: " .. cleanup)
			return
		end

		self.cleanup = cleanup
	end
end

function Preview:render()
	local selectedStory = self.props.selectedStory

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
		}),

		Preview = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[Roact.Ref] = self.previewRef,
		}),

		SelectButton = e("Frame", {
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
				Size = UDim.new(0, 40),
			}),
		}),

		ExpandButton = e("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.99, -45, 0.99),
			Size = UDim2.fromOffset(40, 40),
			ZIndex = 2,
		}, {
			Button = e(FloatingButton, {
				Activated = self.expandSelection,
				Image = "rbxasset://textures/ui/VR/toggle2D.png",
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

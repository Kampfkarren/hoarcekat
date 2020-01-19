local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local EventConnection = require(script.Parent.EventConnection)
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactRodux = require(Hoarcekat.Vendor.RoactRodux)

local e = Roact.createElement

local Preview = Roact.PureComponent:extend("Preview")

function Preview:init()
	self.previewRef = Roact.createRef()
end

function Preview:didMount()
	self:refreshPreview()
end

function Preview:didUpdate()
	self:refreshPreview()
end

function Preview:refreshPreview()
	if self.cleanup then
		self.cleanup()
	end

	local selectedStory = self.props.selectedStory
	if selectedStory then
		-- loadstring is used to avoid cache while preserving `script` (which requiring a clone wouldn't do)
		local story = assert(loadstring(selectedStory.Source))

		local fenv = setmetatable({
			script = selectedStory
		}, {
			__index = getfenv(),
		})

		setfenv(story, fenv)

		self.cleanup = story()(self.previewRef:getValue())
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

		TrackChanged = selectedStory and e(EventConnection, {
			callback = function()
				self:refreshPreview()
			end,
			event = selectedStory:GetPropertyChangedSignal("Source"),
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

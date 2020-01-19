local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

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
		self.cleanup = require(selectedStory:Clone())(self.previewRef:getValue())
	end
end

function Preview:render()
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
	})
end

return RoactRodux.connect(function(state)
	return {
		selectedStory = state.StoryPicker,
	}
end)(Preview)

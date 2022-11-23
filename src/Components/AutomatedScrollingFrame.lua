local Hoarcekat = script:FindFirstAncestor("Storyboards")

local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement

local AutomatedScrollingFrame = Roact.Component:extend("AutomatedScrollingFrame")

function AutomatedScrollingFrame:init()
	self.canvasSize, self.updateCanvasSize = Roact.createBinding(UDim2.new())

	self.resize = function(rbx)
		self.updateCanvasSize(rbx.AbsoluteContentSize)
	end
end

function AutomatedScrollingFrame:render()
	local layoutProps = {}
	layoutProps[Roact.Change.AbsoluteContentSize] = self.resize

	for propName, propValue in pairs(self.props.LayoutProps or {}) do
		layoutProps[propName] = propValue
	end

	local nativeProps = {}
	nativeProps.CanvasSize = self.canvasSize:map(function(size)
		return UDim2.fromOffset(size.X, size.Y)
	end)

	for propName, propValue in pairs(self.props.Native or {}) do
		nativeProps[propName] = propValue
	end

	return e("ScrollingFrame", nativeProps, {
		Layout = e(self.props.LayoutClass, layoutProps),
		Children = Roact.createFragment(self.props[Roact.Children]),
	})
end

return AutomatedScrollingFrame

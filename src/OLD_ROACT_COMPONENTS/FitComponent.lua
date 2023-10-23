local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Roact = require(Hoarcekat.Packages.Roact)

local e = Roact.createElement

local FitComponent = Roact.Component:extend("FitComponent")

function FitComponent:init()
	self.size, self.updateSize = Roact.createBinding(0)

	self.sizeChanged = function(rbx)
		self.updateSize(rbx.AbsoluteContentSize.Y)
	end
end

function FitComponent:render()
	local props = self.props

	local containerProps = {}
	for name, value in pairs(props.ContainerProps or {}) do
		containerProps[name] = value
	end

	local children = {}
	for name, value in pairs(assert(props[Roact.Children], "No children given to FitComponent")) do
		children[name] = value
	end

	assert(children.Layout == nil, "No children named Layout should exist!")

	local layoutProps = {}
	for name, value in pairs(props.LayoutProps or {}) do
		layoutProps[name] = value
	end
	layoutProps[Roact.Change.AbsoluteContentSize] = self.sizeChanged
	children.Layout = e(props.LayoutClass, layoutProps)

	containerProps.Size = self.size:map(function(y)
		return UDim2.new(1, 0, 0, y)
	end)

	containerProps[Roact.Children] = children

	return e(props.ContainerClass, containerProps)
end

return FitComponent

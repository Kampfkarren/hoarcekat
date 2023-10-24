local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local e = React.createElement

function FitComponent(props)
	local size, updateSize = React.useBinding(0)

	local containerProps = {}
	for name, value in pairs(props.containerProps or {}) do
		containerProps[name] = value
	end

	local children = {}
	for name, value in pairs(assert(props.children, "No children given to FitComponent")) do
		children[name] = value
	end

	assert(children.Layout == nil, "No children named Layout should exist!")

	local layoutProps = {}
	for name, value in pairs(props.layoutProps or {}) do
		layoutProps[name] = value
	end
	layoutProps[React.Change.AbsoluteContentSize] = function(rbx)
		updateSize(rbx.AbsoluteContentSize.Y)
	end
	children.Layout = e(props.layoutClass, layoutProps)

	containerProps.Size = size:map(function(y)
		return UDim2.new(1, 0, 0, y)
	end)

	return e(props.containerClass, containerProps, children)
end

return FitComponent

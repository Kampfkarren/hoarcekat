--!nonstrict
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local e = React.createElement

function FitComponent(props)
	local size, updateSize = React.useBinding(0)

	assert(props.children, "No children given to FitComponent")
	assert(props.children.Layout == nil, "No children named Layout should exist!")

	local containerProps = table.clone(props.containerProps)
	local children = table.clone(props.children)
	local layoutProps = table.clone(props.layoutProps)

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

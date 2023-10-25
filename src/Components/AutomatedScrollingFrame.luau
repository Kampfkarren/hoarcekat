local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local e = React.createElement

function AutomatedScrollingFrame(props)
	local canvasSize, updateCanvasSize = React.useBinding(Vector2.new())

	local resize = React.useCallback(function(rbx)
		updateCanvasSize(rbx.AbsoluteContentSize)
	end, { updateCanvasSize })

	local layoutProps = {}
	layoutProps[React.Change.AbsoluteContentSize] = resize

	for propName, propValue in pairs(props.layoutProps or {}) do
		layoutProps[propName] = propValue
	end

	local nativeProps = {}
	nativeProps.CanvasSize = canvasSize:map(function(size: Vector2)
		return UDim2.fromOffset(size.X, size.Y)
	end)

	for propName, propValue in pairs(props.native or {}) do
		nativeProps[propName] = propValue
	end

	return e("ScrollingFrame", nativeProps, {
		Layout = e(props.layoutClass, layoutProps),
		Children = React.createElement(React.Fragment, nil, props.children),
	})
end

return AutomatedScrollingFrame

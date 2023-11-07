local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local function useButtonBehaviour()
	local pressed, setPressed = React.useState(false)
	local hovering, setHovering = React.useState(false)

	local onMouseEnter = React.useCallback(function()
		setHovering(true)
	end, {})

	local onMouseLeave = React.useCallback(function()
		setHovering(false)
	end, {})

	local onMouseButton1Down = React.useCallback(function()
		setPressed(true)
	end, {})

	local onMouseButton1Up = React.useCallback(function()
		setPressed(false)
	end, {})

	return React.useMemo(function()
		return {
			pressed = pressed,
			hovering = hovering,
			onMouseEnter = onMouseEnter,
			onMouseLeave = onMouseLeave,
			onMouseButton1Down = onMouseButton1Down,
			onMouseButton1Up = onMouseButton1Up,
		}
	end, {
		pressed,
		hovering,
		onMouseEnter,
		onMouseLeave,
		onMouseButton1Down,
		onMouseButton1Up,
	} :: { unknown })
end

return useButtonBehaviour

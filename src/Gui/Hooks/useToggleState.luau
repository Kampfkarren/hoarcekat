local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local function useToggleState(default: boolean?): {
	on: boolean,
	enable: () -> (),
	disable: () -> (),
	toggle: () -> (),
}
	local toggled, setToggled = React.useState(default or false)

	local enable = React.useCallback(function()
		setToggled(true)
	end, {})

	local disable = React.useCallback(function()
		setToggled(false)
	end, {})

	local toggle = React.useCallback(function()
		setToggled(function(currentToggled)
			return not currentToggled
		end)
	end, {})

	return React.useMemo(function()
		return {
			on = toggled,
			enable = enable,
			disable = disable,
			toggle = toggle,
		}
	end, { toggled, enable, disable, toggle } :: { any })
end

return useToggleState

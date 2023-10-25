-- Inspired by: https://github.com/streamich/react-use/blob/master/src/useUpdateEffect.ts

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local useFirstMountState = require(Hoarcekat.Plugin.Gui.Hooks.useFirstMountState)

local function useUpdateEffect(effect, dependencies)
	local isFirstMount = useFirstMountState()

	React.useEffect(function()
		if not isFirstMount then
			return effect()
		end
	end, dependencies)
end

return useUpdateEffect

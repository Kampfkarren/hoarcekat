local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local function useFirstMountState(): boolean?
	local isFirst = React.useRef(true)

	if isFirst.current then
		isFirst.current = false
		return true
	end

	return isFirst.current
end

return useFirstMountState

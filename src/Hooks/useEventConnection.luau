local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local function useEventConnection<T...>(event: RBXScriptSignal<T...>, callback: (T...) -> (), dependencies: { any })
	local cachedCallback = React.useMemo(function()
		return callback
	end, dependencies)

	React.useEffect(function()
		local connection = (event :: any):Connect(cachedCallback)

		return function()
			connection:Disconnect()
		end
	end, { event, cachedCallback } :: { unknown })
end

return useEventConnection

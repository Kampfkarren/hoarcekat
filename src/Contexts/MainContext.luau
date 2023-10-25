local ServerStorage = game:GetService("ServerStorage")
local Hoarcekat = script.Parent:FindFirstAncestor("Hoarcekat")
local useEventConnection = require(ServerStorage.Hoarcekat.Plugin.Hooks.useEventConnection)
local React = require(Hoarcekat.Packages.React)

local Context = React.createContext(nil)

function Provider(props)
	local selectedStory, setSelectedStory = React.useState(nil)

	local ancestryChanged = if selectedStory then selectedStory.AncestryChanged else nil
	useEventConnection(ancestryChanged, function()
		setSelectedStory(nil)
	end, { setSelectedStory })

	return React.createElement(Context.Provider, {
		value = {
			selectedStory = selectedStory,
			setSelectedStory = setSelectedStory,
		},
	}, props.children)
end

return {
	Provider = Provider,
	Context = Context,
}

local ServerStorage = game:GetService("ServerStorage")
local Hoarcekat = script.Parent:FindFirstAncestor("Hoarcekat")

local ReactRoblox = require(ServerStorage.Hoarcekat.Packages.ReactRoblox)
local React = require(Hoarcekat.Packages.React)

local Context = React.createContext({
	selectedStory = nil,
	setSelectedStory = function() end,
} :: {
	selectedStory: Instance?,
	setSelectedStory: (any) -> (),
})

local Types = require(Hoarcekat.Plugin.Types)

local function Provider(props: {
	root: ReactRoblox.RootType,
	savedState: Types.SaveState,
	plugin: Types.PluginFacade,
	children: React.ReactNode,
})
	local savedState = props.savedState
	local initialValue = if savedState and savedState.selectedStory then savedState.selectedStory else nil
	local selectedStory: Instance | nil, setSelectedStory = React.useState(initialValue)

	React.useEffect(function()
		props.plugin:beforeUnload(function()
			props.root:unmount()
			return {
				selectedStory = selectedStory,
			}
		end)
	end, { selectedStory, props.plugin, props.root } :: { unknown })

	React.useEffect(function()
		local connection

		if selectedStory then
			connection = selectedStory.AncestryChanged:Connect(function()
				setSelectedStory(nil)
				connection:Disconnect()
			end)
		end

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { selectedStory })

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

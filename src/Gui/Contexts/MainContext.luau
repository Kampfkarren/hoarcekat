local CoreGui = game:GetService("CoreGui")
local Hoarcekat = script.Parent:FindFirstAncestor("Hoarcekat")

local ReactRoblox = require(Hoarcekat.Packages.ReactRoblox)
local React = require(Hoarcekat.Packages.React)

local Types = require(Hoarcekat.Plugin.Types)

export type ContextType = {
	selectedStory: Instance?,
	setSelectedStory: (any) -> (),
}

local default: ContextType = {
	selectedStory = nil,
	setSelectedStory = function() end,
}

local Context = React.createContext(default)

local function Provider(props: {
	root: ReactRoblox.RootType,
	savedState: Types.SaveState,
	plugin: Types.PluginFacade,
	children: React.ReactNode,
})
	local savedState = props.savedState
	local initialValue = savedState and savedState.selectedStory
	local selectedStory: Instance?, setSelectedStory = React.useState(initialValue)

	React.useEffect(function()
		props.plugin:beforeUnload(function()
			props.root:unmount()

			if CoreGui:FindFirstChild("HoarcekatDisplay") then
				CoreGui.HoarcekatDisplay:Destroy()
			end

			return {
				selectedStory = selectedStory,
			}
		end)

		return function()
			props.plugin:setBeforeUnloadToNil()
		end
	end, { selectedStory, props } :: { unknown })

	React.useEffect(function()
		if selectedStory == nil then
			return
		end

		local connection = selectedStory.AncestryChanged:Once(function()
			setSelectedStory(nil)
		end)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { selectedStory })

	local value: ContextType = {
		selectedStory = selectedStory,
		setSelectedStory = setSelectedStory,
	}

	return React.createElement(Context.Provider, {
		value = value,
	}, props.children)
end

return {
	Context = Context,
	Provider = Provider,
}

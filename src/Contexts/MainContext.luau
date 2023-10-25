local Hoarcekat = script.Parent:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local Context = React.createContext(nil)

function Provider(props)
	local selectedStory, setSelectedStory = React.useState(nil)

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
	end, {})

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

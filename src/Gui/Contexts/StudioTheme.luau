local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local function deriveHoarcekatTheme(studioTheme: StudioTheme)
	return {
		holder = {
			background = studioTheme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		},

		sideBar = {
			background = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScrollBarBackground),
			storiesLabelTextColor = studioTheme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
		},

		iconListItem = {
			buttonColor = studioTheme:GetColor(
				Enum.StudioStyleGuideColor.CurrentMarker,
				Enum.StudioStyleGuideModifier.Selected
			),
			iconColor = studioTheme:GetColor(Enum.StudioStyleGuideColor.BrightText),
			textColor = studioTheme:GetColor(Enum.StudioStyleGuideColor.BrightText),
		},

		verticalSplitter = {
			grabber = studioTheme:GetColor(Enum.StudioStyleGuideColor.DialogButtonBorder),
			border = studioTheme:GetColor(Enum.StudioStyleGuideColor.ScriptRuler),
		},

		floatingButton = {
			default = studioTheme:GetColor(Enum.StudioStyleGuideColor.MainButton),
			hovered = studioTheme:GetColor(Enum.StudioStyleGuideColor.MainButton, Enum.StudioStyleGuideModifier.Hover),
			pressed = studioTheme:GetColor(
				Enum.StudioStyleGuideColor.MainButton,
				Enum.StudioStyleGuideModifier.Pressed
			),
		},
	}
end

local studioSettings = settings().Studio
local Context = React.createContext(deriveHoarcekatTheme(studioSettings.Theme))

local function ThemeProvider(props: { children: React.ReactNode })
	local theme, setTheme = React.useState(deriveHoarcekatTheme(studioSettings.Theme))

	React.useEffect(function()
		local connection

		if theme then
			connection = studioSettings.ThemeChanged:Connect(function()
				setTheme(deriveHoarcekatTheme(studioSettings.Theme))
			end)
		end

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { theme })

	return React.createElement(Context.Provider, {
		value = theme,
	}, props.children)
end

return {
	Context = Context,
	Provider = ThemeProvider,
}

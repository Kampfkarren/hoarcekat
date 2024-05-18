local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

export type ContextType = {
	textColor: Color3,

	holder: {
		background: Color3,
	},

	sideBar: {
		background: Color3,
		storiesLabelTextColor: Color3,
	},

	iconListItem: {
		buttonColor: Color3,
		iconColor: Color3,
		textColor: Color3,
	},

	verticalSplitter: {
		grabber: Color3,
		border: Color3,
	},

	floatingButton: {
		default: Color3,
		hovered: Color3,
		pressed: Color3,
	},
}

local function deriveHoarcekatTheme(studioTheme: StudioTheme): ContextType
	return {
		textColor = studioTheme:GetColor(Enum.StudioStyleGuideColor.BrightText),

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
			hovered = studioTheme:GetColor(
				Enum.StudioStyleGuideColor.MainButton,
				Enum.StudioStyleGuideModifier.Pressed
			),
			pressed = studioTheme:GetColor(Enum.StudioStyleGuideColor.MainButton, Enum.StudioStyleGuideModifier.Hover),
		},
	}
end

local studioSettings = settings().Studio
local default: ContextType = deriveHoarcekatTheme(studioSettings.Theme)
local Context = React.createContext(default)

local function ThemeProvider(props: { children: React.ReactNode })
	local theme, setTheme = React.useState(function()
		return deriveHoarcekatTheme(studioSettings.Theme)
	end)

	React.useEffect(function()
		local connection = studioSettings.ThemeChanged:Connect(function()
			setTheme(deriveHoarcekatTheme(studioSettings.Theme))
		end)

		return function()
			connection:Disconnect()
		end
	end, { deriveHoarcekatTheme })

	return React.createElement(Context.Provider, {
		value = theme,
	}, props.children)
end

return {
	Context = Context,
	Provider = ThemeProvider,
}

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local StudioTheme = require(Hoarcekat.Plugin.Gui.Contexts.StudioTheme)
local useToggleState = require(Hoarcekat.Plugin.Gui.Hooks.useToggleState)

local e = React.createElement

local BAR_HEIGHT = 24
local ICON_SIZE = 16

local function IconListItem(props: {
	selected: boolean?,
	layoutOrder: number?,
	activated: () -> (),
	text: string,
	icon: string,
})
	local theme = React.useContext(StudioTheme.Context)
	local hovering = useToggleState(false)
	local transparency = if props.selected then 0.5 elseif hovering.on then 0.85 else 1

	return e("TextButton", {
		AutomaticSize = Enum.AutomaticSize.X,
		AutoButtonColor = false,
		BackgroundColor3 = theme.iconListItem.buttonColor,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
		LayoutOrder = props.layoutOrder,
		Text = "",
		ClipsDescendants = true,

		[React.Event.MouseEnter] = hovering.enable,
		[React.Event.MouseLeave] = hovering.disable,
		[React.Event.Activated] = props.activated,
	}, {
		Layout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
		}),

		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),

		IconFrame = e("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(BAR_HEIGHT, BAR_HEIGHT),
		}, {
			IconImage = e("ImageLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = props.icon,
				ImageColor3 = theme.iconListItem.iconColor,
			}),
		}),

		Title = e("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.fromOffset(0, BAR_HEIGHT),
			Text = props.text,
			TextColor3 = theme.iconListItem.textColor,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
	})
end

return IconListItem

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local BAR_HEIGHT = 24
local ICON_SIZE = 16

local e = React.createElement
local StudioTheme = require(Hoarcekat.Plugin.Contexts.StudioTheme)

local function IconListItem(props)
	local theme = React.useContext(StudioTheme.Context)

	return e("TextButton", {
		BackgroundColor3 = theme.iconListItem.buttonColor,
		BackgroundTransparency = if props.selected then 0.5 else 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
		LayoutOrder = props.layoutOrder,
		Text = "",
		ClipsDescendants = true,

		[React.Event.Activated] = props.activated,
	}, {
		Layout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
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
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, -BAR_HEIGHT, 0, BAR_HEIGHT),
			Text = props.text,
			TextColor3 = theme.iconListItem.textColor,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
	})
end

return IconListItem

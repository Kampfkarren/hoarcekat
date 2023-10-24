local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Assets = require(Hoarcekat.Plugin.Assets)
local React = require(Hoarcekat.Packages.React)

local e = React.createElement
local useButtonBehaviour = require(Hoarcekat.Plugin.Hooks.useButtonBehaviour)

local FloatingButton = React.Component:extend("FloatingButton")

function FloatingButton(props)
	local button = useButtonBehaviour()

	return e("ImageButton", {
		BackgroundTransparency = 1,
		Image = Assets.button_fill,
		ImageColor3 = settings().Studio.Theme:GetColor(
			"MainButton",
			button.pressed and "Pressed" or (button.hovered and "Hover" or "Default")
		),
		Size = UDim2.new(props.size, props.size),

		[React.Event.MouseEnter] = button.onMouseEnter,
		[React.Event.MouseLeave] = button.onMouseEnter,
		[React.Event.MouseButton1Down] = button.onMouseButton1Down,
		[React.Event.MouseButton1Up] = button.onMouseButton1Up,
		[React.Event.Activated] = props.activated,
	}, {
		Image = e("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = props.image,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(props.imageSize, props.imageSize),
		}),
	})
end

return FloatingButton

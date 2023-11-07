local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local StudioTheme = require(Hoarcekat.Plugin.Gui.Contexts.StudioTheme)
local useButtonBehaviour = require(Hoarcekat.Plugin.Gui.Hooks.useButtonBehaviour)

local e = React.createElement

local function FloatingButton(props: {
	size: UDim,
	activated: () -> (),
	image: string,
	imageSize: UDim,
})
	local theme = React.useContext(StudioTheme.Context)
	local button = useButtonBehaviour()

	return e("ImageButton", {
		BackgroundTransparency = 1,
		Image = Assets.button_fill,
		ImageColor3 = theme.floatingButton[if button.pressed
			then "pressed"
			elseif button.hovering then "hovered"
			else "default"],
		Size = UDim2.new(props.size, props.size),

		[React.Event.MouseEnter] = button.onMouseEnter,
		[React.Event.MouseLeave] = button.onMouseLeave,
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

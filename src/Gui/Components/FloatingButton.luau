local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local StudioTheme = require(Hoarcekat.Plugin.Gui.Contexts.StudioTheme)
local useToggleState = require(Hoarcekat.Plugin.Gui.Hooks.useToggleState)

local e = React.createElement

local function FloatingButton(props: {
	size: UDim,
	activated: () -> (),
	image: string,
	imageSize: UDim,
})
	local theme = React.useContext(StudioTheme.Context)
	local hovering = useToggleState(false)
	local pressed = useToggleState(false)

	return e("ImageButton", {
		BackgroundTransparency = 1,
		Image = Assets.button_fill,
		ImageColor3 = theme.floatingButton[if pressed.on then "pressed" elseif hovering.on then "hovered" else "default"],
		Size = UDim2.new(props.size, props.size),

		[React.Event.MouseEnter] = hovering.enable,
		[React.Event.MouseLeave] = hovering.disable,
		[React.Event.MouseButton1Down] = pressed.enable,
		[React.Event.MouseButton1Up] = pressed.disable,
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

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Assets = require(Hoarcekat.Plugin.Assets)
local Roact = require(Hoarcekat.Vendor.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local e = Roact.createElement

local FloatingButton = Roact.Component:extend("FloatingButton")

function FloatingButton:init()
	self.hovered, self.setHovered = Roact.createBinding(false)
	self.pressed, self.setPressed = Roact.createBinding(false)

	self.hover = function()
		self.setHovered(true)
	end

	self.unhover = function()
		self.setHovered(false)
	end

	self.press = function()
		self.setPressed(true)
	end

	self.unpress = function()
		self.setPressed(false)
	end
end

function FloatingButton:render()
	local props = self.props

	return e(StudioThemeAccessor, {}, {
		function(theme)
			return e("ImageButton", {
				BackgroundTransparency = 1,
				Image = Assets.button_fill,
				ImageColor3 = Roact.joinBindings({
					hovered = self.hovered,
					pressed = self.pressed,
				}):map(function(state)
					return theme:GetColor(
						"MainButton",
						state.pressed
							and "Pressed"
							or (state.hovered
								and "Hover"
								or "Default"
							)
					)
				end),
				Size = UDim2.new(props.Size, props.Size),

				[Roact.Event.MouseEnter] = self.hover,
				[Roact.Event.MouseLeave] = self.unhover,
				[Roact.Event.MouseButton1Down] = self.press,
				[Roact.Event.MouseButton1Up] = self.unpress,
				[Roact.Event.Activated] = props.Activated,
			}, {
				Image = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = props.Image,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(props.ImageSize, props.ImageSize),
				}),
			})
		end,
	})
end

return FloatingButton

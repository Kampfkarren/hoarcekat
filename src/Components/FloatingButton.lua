local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Assets = require(Hoarcekat.Plugin.Assets)
local Roact = require(Hoarcekat.Vendor.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local e = Roact.createElement
local FloatingButton = Roact.Component:extend("FloatingButton")

function FloatingButton:init()
	self:setState({
		hovered = false,
		pressed = false,
	})

	self.onMouseEnter = function()
		self:setState({
			hovered = true,
		})
	end

	self.onMouseLeave = function()
		self:setState({
			hovered = false,
		})
	end

	self.onMouseButton1Down = function()
		self:setState({
			pressed = true,
		})
	end

	self.onMouseButton1Up = function()
		self:setState({
			pressed = false,
		})
	end
end

function FloatingButton:render()
	local props = self.props

	return e(StudioThemeAccessor, {}, {
		function(theme)
			local pressed = self.state.pressed
			local hovered = self.state.hovered

			local buttonColor = if props.Disabled
				then settings().Studio["Background Color"]
				else theme:GetColor(
					"MainButton",
					if props.Disabled
						then "Disabled"
						elseif pressed then "Pressed"
						elseif hovered then "Hover"
						else "Default"
				)

			return e("ImageButton", {
				BackgroundTransparency = if hovered then 0 else 0.5,
				BackgroundColor3 = buttonColor,
				Size = UDim2.new(props.Size, props.Size),

				[Roact.Event.MouseEnter] = self.onMouseEnter,
				[Roact.Event.MouseLeave] = self.onMouseLeave,
				[Roact.Event.MouseButton1Down] = self.onMouseButton1Down,
				[Roact.Event.MouseButton1Up] = self.onMouseButton1Up,
				[Roact.Event.Activated] = props.Activated,
			}, {
				UICorner = e("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				Image = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ImageTransparency = if hovered then 0 else 0.5,
					Image = props.Image,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(props.ImageSize, props.ImageSize),
				}),

				Tooltip = hovered and e("TextLabel", {
					Text = props.TooltipText,
					TextColor3 = theme:GetColor("BrightText", "Default"),
					BackgroundTransparency = 0,
					Position = UDim2.fromScale(1, -0.5),
					AnchorPoint = Vector2.new(1, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = theme:GetColor("ScrollBarBackground", "Default"),
				}, {
					UIPadding = e("UIPadding", {
						PaddingLeft = UDim.new(0, 12),
						PaddingRight = UDim.new(0, 12),
						PaddingTop = UDim.new(0, 5),
						PaddingBottom = UDim.new(0, 5),
					}),

					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0, 4),
					}),

					UIStroke = e("UIStroke", {
						Thickness = 2,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = theme:GetColor("DialogButtonBorder"),
					}),
				}),
			})
		end,
	})
end

return FloatingButton

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement

local ResizeableFrame = Roact.Component:extend("ResizeableFrame")

function ResizeableFrame:init()
	self._size, self._updateSize = Roact.createBinding(300)

	self._dragging = false
end

function ResizeableFrame:render()
	return Roact.createFragment({
		HitBox = e("TextButton", {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.2, 0),
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.InputChanged] = function(_, input)
				if not self._dragging then
					return
				end

				if input.UserInputType == Enum.UserInputType.MouseMovement then
					self._updateSize(input.Position.X)
					self.props.resized(input.Position.X)
				end
			end,
			[Roact.Event.InputEnded] = function(_, input)
				if input.UserInputType ~= Enum.UserInputType.MouseMovement then
					return
				end

				self._dragging = false
			end,

			[Roact.Event.MouseButton1Up] = function(_, input)
				self._dragging = false
			end,
		}),
		Holder = e("Frame", {
			Size = self._size:map(function(value)
				return UDim2.new(0, value, 1, 0)
			end),
			BackgroundTransparency = 1,
		}, {
			HitBox = e("TextButton", {
				Size = UDim2.new(0, 10, 1, 0),
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = "",
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 0.5,
				[Roact.Event.InputBegan] = function(_, input)
					if input.UserInputState == Enum.UserInputState.Begin then
						self._dragging = true
					end
				end,
			
				[Roact.Event.MouseButton1Up] = function(_, input)
					self._dragging = false
				end,
			}),
		}),
	})
end

return ResizeableFrame

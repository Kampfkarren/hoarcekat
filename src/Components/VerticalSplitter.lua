local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Roact = require(Hoarcekat.Vendor.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local e = Roact.createElement

local HANDLE_WIDTH = 4
local DEFAULT_ALPHA = 0.2

--[[
ideally this component would not have a hard-coded default alpha or self-contained alpha state
instead, it would accept initial/current alpha as a prop, which would enable a persistent layout
however, we don't need that here and it isn't worth the added complexity
]]

local VerticalSplitter = Roact.Component:extend("VerticalSplitter")

VerticalSplitter.defaultProps = {
	Size = UDim2.fromScale(1, 1),
	Position = UDim2.fromScale(0, 0),
	AnchorPoint = Vector2.new(0, 0),
}

function VerticalSplitter:init()
	self.containerRef = Roact.createRef()
	self:setState({
		hovering = false,
		dragging = false,
		alpha = DEFAULT_ALPHA,
	})
	self.onInputBegan = function(_rbx, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({ hovering = true })
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:setState({ dragging = true })
		end
	end
	self.onInputEnded = function(_rbx, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({ hovering = false })
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:setState({ dragging = false })
		end
	end
	self.onInputChanged = function(_rbx, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if self.state.dragging == true then
				local container = self.containerRef:getValue()
				local offset = input.Position.x - container.AbsolutePosition.x
				local width = container.AbsoluteSize.x
				self:setState({ alpha = math.clamp(offset / width, 0, 1) })
			end
		end
	end
end

function VerticalSplitter:render()
	return e(StudioThemeAccessor, {}, {
		function(theme)
			return e("Frame", {
				Size = self.props.Size,
				Position = self.props.Position,
				AnchorPoint = self.props.AnchorPoint,
				ZIndex = self.props.ZIndex,
				LayoutOrder = self.props.LayoutOrder,
				BackgroundTransparency = 1,
				[Roact.Ref] = self.containerRef,
				[Roact.Event.InputChanged] = self.onInputChanged,
			}, {
				Left = e("Frame", {
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.new(self.state.alpha, -HANDLE_WIDTH / 2, 1, 0),
					BackgroundTransparency = 1,
					ZIndex = 0,
				}, { self.props[Roact.Children].Left }),
				Right = e("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.new(1 - self.state.alpha, -HANDLE_WIDTH / 2, 1, 0),
					BackgroundTransparency = 1,
					ZIndex = 0,
				}, { self.props[Roact.Children].Right }),
				Grabber = e("TextButton", {
					AutoButtonColor = false,
					Text = "",
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.fromScale(self.state.alpha, 0),
					Size = UDim2.new(0, HANDLE_WIDTH, 1, 0),
					BackgroundColor3 = theme:GetColor("DialogButtonBorder"),
					BorderSizePixel = 0,
					ZIndex = 1,
					[Roact.Event.InputBegan] = self.onInputBegan,
					[Roact.Event.InputEnded] = self.onInputEnded,
				}, {
					BorderLeft = e("Frame", {
						Position = UDim2.fromOffset(-1, 0),
						Size = UDim2.new(0, 1, 1, 0),
						BackgroundColor3 = theme:GetColor("ScriptRuler"),
						BorderSizePixel = 0,
						Visible = self.state.hovering or self.state.dragging,
					}),
					BorderRight = e("Frame", {
						Position = UDim2.fromScale(1, 0),
						Size = UDim2.new(0, 1, 1, 0),
						BackgroundColor3 = theme:GetColor("ScriptRuler"),
						BorderSizePixel = 0,
						Visible = self.state.hovering or self.state.dragging,
					}),
				}),
			})
		end,
	})
end

return VerticalSplitter

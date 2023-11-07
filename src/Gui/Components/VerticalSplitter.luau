local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local DEFAULT_ALPHA = 0.25
local HANDLE_WIDTH = 4

local StudioTheme = require(Hoarcekat.Plugin.Gui.Contexts.StudioTheme)

local e = React.createElement

local function VerticalSplitter(props: {
	mouse: PluginMouse,
	size: UDim2,
	left: React.ReactNode,
	right: React.ReactNode,
})
	local theme = React.useContext(StudioTheme.Context)

	local containerRef = React.useRef(nil)
	local hovering, setHovering = React.useState(false)
	local dragging, setDragging = React.useState(false)
	local alpha, setAlpha = React.useState(DEFAULT_ALPHA)

	local onInputBegan = React.useCallback(function(_, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHovering(true)
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			setDragging(true)
		end
	end, {})

	local onInputEnded = React.useCallback(function(_, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			setHovering(false)
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			setDragging(false)
		end
	end, {})

	local onInputChanged = React.useCallback(function(_, input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		if not dragging then
			return
		end

		local container = containerRef.current

		if container then
			local width = container.AbsoluteSize.x
			local x: number = input.Position.X
			local offset = x - container.AbsolutePosition.X
			offset = math.clamp(offset, HANDLE_WIDTH, width - HANDLE_WIDTH)
			setAlpha(offset / width)
		end
	end, { dragging })

	React.useEffect(function()
		local pluginMouse = props.mouse

		if hovering or dragging then
			pluginMouse.Icon = "rbxasset://SystemCursors/SplitEW"
		else
			pluginMouse.Icon = "" -- empty string resets mouse icon
		end

		return function()
			pluginMouse.Icon = ""
		end
	end, { hovering, dragging, props.mouse } :: { unknown })

	return e("Frame", {
		Size = props.size,
		ZIndex = 1,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		ref = containerRef,
		[React.Event.InputChanged] = onInputChanged,
	}, {
		Left = e("Frame", {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.new(alpha, -HANDLE_WIDTH / 2, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 0,
		}, props.left),

		Right = e("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(1 - alpha, -HANDLE_WIDTH / 2, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 0,
		}, props.right),

		Grabber = e("TextButton", {
			AutoButtonColor = false,
			Text = "",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(alpha, 0),
			Size = UDim2.new(0, HANDLE_WIDTH, 1, 0),
			BackgroundColor3 = theme.verticalSplitter.grabber,
			BorderSizePixel = 0,
			ZIndex = 1,
			[React.Event.InputBegan] = onInputBegan,
			[React.Event.InputEnded] = onInputEnded,
		}, {
			LeftBorder = e("Frame", {
				Position = UDim2.fromOffset(-1, 0),
				Size = UDim2.new(0, 1, 1, 0),
				BackgroundColor3 = theme.verticalSplitter.border,
				BorderSizePixel = 0,
				Visible = hovering or dragging,
			}),
			RightBorder = e("Frame", {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.new(0, 1, 1, 0),
				BackgroundColor3 = theme.verticalSplitter.border,
				BorderSizePixel = 0,
				Visible = hovering or dragging,
			}),
		}),
	})
end

return VerticalSplitter

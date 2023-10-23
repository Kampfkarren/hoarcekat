local TextService = game:GetService("TextService")
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local function TextLabel(props)
	local update = React.useCallback(function(rbx)
		if not rbx then
			return
		end

		if props.textWrapped then
			local width: number = rbx.AbsoluteSize.X
			local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(width - 2, 100000))
			rbx.Size = UDim2.new(1, 0, 0, tb.Y)
		else
			local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(100000, 100000))
			rbx.Size = UDim2.new(props.width or UDim.new(0, tb.X), UDim.new(0, tb.Y))
		end
	end, { props.textWrapped, props.width })

	local autoSize = not props.size

	return React.createElement("TextLabel", {
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Size = props.size or props.textWrapped and UDim2.new(1, 0, 0, 0) or nil,
		BackgroundTransparency = 1.0,

		Font = props.font or Enum.Font.SourceSans,
		TextSize = props.textSize or 20,
		TextColor3 = props.textColor3 or Color3.fromRGB(0, 0, 0),
		Text = props.text or "<Text Not Set>",
		TextWrapped = props.textWrapped,
		TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left,
		TextYAlignment = props.textYAlignment,

		ref = if autoSize then update else nil,
		[React.Change.TextBounds] = if autoSize then update else nil,
		[React.Change.AbsoluteSize] = if autoSize then update else nil,
		[React.Change.Parent] = if autoSize then update else nil,
	})
end

return TextLabel

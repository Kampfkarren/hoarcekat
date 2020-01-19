local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Roact = require(Hoarcekat.Vendor.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local e = Roact.createElement

local BAR_HEIGHT = 24
local ICON_SIZE = 16

local function IconListItem(props)
	return e(StudioThemeAccessor, {}, {
		function(theme)
			return e("TextButton", {
				BackgroundColor3 = theme:GetColor("CurrentMarker", "Selected"),
				BackgroundTransparency = props.Selected and 0.5 or 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
				LayoutOrder = props.LayoutOrder,
				Text = "",

				[Roact.Event.Activated] = props.Activated,
			}, {
				Layout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
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
						Image = props.Icon,
						ImageColor3 = theme:GetColor("BrightText", "Default"),
					}),
				}),

				Title = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(1, -BAR_HEIGHT, 0, BAR_HEIGHT),
					Text = props.Text,
					TextColor3 = theme:GetColor("BrightText", "Default"),
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			})
		end,
	})
end

return IconListItem

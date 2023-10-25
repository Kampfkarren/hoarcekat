local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local OFFSET = 8

local Assets = require(Hoarcekat.Plugin.Assets)

local e = React.createElement
local FitComponent = require(Hoarcekat.Plugin.Components.FitComponent)
local IconListItem = require(Hoarcekat.Plugin.Components.IconListItem)

function Collapsible(props)
	local open, setOpen = React.useState(false)

	local content = open and props.children

	return e(FitComponent, {
		containerClass = "Frame",
		containerProps = {
			BackgroundTransparency = 1,
		},
		layoutClass = "UIListLayout",
		layoutProps = {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	}, {
		Topbar = e(IconListItem, {
			activated = function()
				setOpen(function(current)
					return not current
				end)
			end,
			icon = open and Assets.collapse_down or Assets.collapse_right,
			text = props.title,
		}),

		Content = content and e(FitComponent, {
			containerClass = "Frame",
			containerProps = {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(OFFSET, 0),
			},
			layoutClass = "UIListLayout",
			layoutProps = {
				Padding = UDim.new(0, 5),
			},
		}, {
			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, OFFSET),
			}),

			Content = e(React.Fragment, nil, content),
		}),
	})
end

return Collapsible

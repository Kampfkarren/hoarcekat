local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local FitComponent = require(Hoarcekat.Components.FitComponent)
local IconListItem = require(Hoarcekat.Components.IconListItem)

local OFFSET = 8

local e = React.createElement

function Collapsible(props)
	local open, setOpen = React.useState(false)

	local content = open and props.children

	return e(FitComponent, {
		ContainerClass = "Frame",
		ContainerProps = {
			BackgroundTransparency = 1,
		},
		LayoutClass = "UIListLayout",
		LayoutProps = {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	}, {
		Topbar = e(IconListItem, {
			Activated = function()
				setOpen(function(current)
					return not current
				end)
			end,
			Icon = open and Assets.collapse_down or Assets.collapse_right,
			Text = props.title,
		}),

		Content = content and e(FitComponent, {
			ContainerClass = "Frame",
			ContainerProps = {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(OFFSET, 0),
			},
			LayoutClass = "UIListLayout",
		}, {
			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, OFFSET),
			}),

			Content = e(React.Fragment, nil, content),
		}),
	})
end

return Collapsible

local ServerStorage = game:GetService("ServerStorage")
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local IconListItem = require(Hoarcekat.Plugin.Gui.Components.IconListItem)
local useToggleState = require(ServerStorage.Hoarcekat.Plugin.Gui.Hooks.useToggleState)
local e = React.createElement

local OFFSET = 8

local function Collapsible(props: {
	title: string,
	children: React.ReactNode,
})
	local collapsible = useToggleState(true)
	local open = collapsible.on

	return e("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Topbar = e(IconListItem, {
			activated = function()
				collapsible.toggle()
			end,
			icon = open and Assets.collapse_down or Assets.collapse_right,
			text = props.title,
			layoutOrder = 1,
		}),

		Content = e("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(OFFSET, 0),
			LayoutOrder = 2,
			Visible = open,
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0, 5),
			}),

			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, OFFSET),
			}),
		}, props.children),
	})
end

return Collapsible

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Assets = require(Hoarcekat.Plugin.Assets)
local FitComponent = require(script.Parent.FitComponent)
local IconListItem = require(script.Parent.IconListItem)
local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement

local Collapsible = Roact.Component:extend("Collapsible")

local OFFSET = 8

function Collapsible:init()
	self:setState({
		open = false,
		isSearching = self.props.IsSearching,
	})

	self.toggle = function()
		self:setState({
			open = not self.state.open,
		})
	end
end

function Collapsible:didUpdate(_, prevState)
	if prevState.isSearching ~= self.props.IsSearching then
		self:setState({
			isSearching = self.props.IsSearching,
		})
	end
end

function Collapsible:render()
	local isOpen = self.state.open or self.state.isSearching
	local content = isOpen and self.props[Roact.Children]

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
			Activated = self.toggle,
			Icon = isOpen and
				Assets.collapse_down or
				Assets.collapse_right,
			Text = self.props.Title,
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

			Content = Roact.createFragment(content),
		}),
	})
end

return Collapsible

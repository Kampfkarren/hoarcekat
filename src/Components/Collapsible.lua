local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local IconListItem = require(script.Parent.IconListItem)
local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement

local Collapsible = Roact.Component:extend("Collapsible")

local BAR_HEIGHT = 24
local OFFSET = 8

function Collapsible:init()
	self:setState({
		open = true,
	})

	self.toggle = function()
		self:setState({
			open = not self.state.open,
		})
	end
end

function Collapsible:render()
	local content = self.state.open and self.props[Roact.Children]

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
	}, {
		Layout = e("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Topbar = e(IconListItem, {
			Activated = self.toggle,
			Icon = self.state.open and
				"rbxasset://textures/collapsibleArrowDown.png" or
				"rbxasset://textures/collapsibleArrowRight.png",
			Text = self.props.Title,
		}),

		Content = content and e("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(OFFSET, 0),
			Size = UDim2.new(1, OFFSET, 1, 0),
		}, {
			Padding = e("UIPadding", {
				PaddingLeft = UDim.new(0, OFFSET),
			}),

			Content = Roact.createFragment(content),
		}),
	})
end

return Collapsible

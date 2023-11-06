--!nonstrict
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)
local ReactRoblox = require(Hoarcekat.Packages.ReactRoblox)

local Assets = require(Hoarcekat.Plugin.Assets)

local Collapsible = require(Hoarcekat.Plugin.Gui.Components.Collapsible)
local IconListItem = require(Hoarcekat.Plugin.Gui.Components.IconListItem)

local e = React.createElement

local function CollapsibleChildrenFragment(props)
	local elements = {}

	for i = 1, 5 do
		elements[i] = e(IconListItem, {
			activated = function()
				props.setSelectedIndex(i)
			end,
			layoutOrder = i,
			selected = props.selectedIndex == i,
			icon = Assets.hamburger,
		})
	end

	return e(React.Fragment, nil, elements)
end

local function TestCollapsibleStory()
	local selectedIndex, setSelectedIndex = React.useState(nil)

	return e("Frame", {
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(0.75, 0.75),
		BackgroundTransparency = 0.5,
		BackgroundColor3 = Color3.fromRGB(24, 24, 24),
		BorderSizePixel = 0,
	}, {
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.Name,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),

		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),

		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
		}),

		CollapsibleA = e(Collapsible, {
			title = "ReplicatedStorage",
		}, {
			CollapsibleB = e(Collapsible, {
				title = "Client",
			}, {
				CollapsibleC = e(Collapsible, {
					title = "Gui",
				}, {
					CollapsibleC = e(Collapsible, {
						title = "Stories",
					}, {
						ListItems = e(CollapsibleChildrenFragment, {
							selectedIndex = selectedIndex,
							setSelectedIndex = setSelectedIndex,
						}),
					}),
				}),
			}),
		}),
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(e(TestCollapsibleStory), target))

	return function()
		root:unmount()
	end
end

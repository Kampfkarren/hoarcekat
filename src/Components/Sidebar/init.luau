local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local AutomatedScrollingFrame = require(script.Parent.AutomatedScrollingFrame)
local React = require(Hoarcekat.Packages.React)
local SidebarList = require(script.SidebarList)

local e = React.createElement
local StudioTheme = require(Hoarcekat.Plugin.Contexts.StudioTheme)

local useStoryCollection = require(Hoarcekat.Plugin.Hooks.useStoryCollection)

function Sidebar()
	local theme = React.useContext(StudioTheme.Context)

	local storyTree = useStoryCollection()

	local storyListChildren = {
		UIPadding = e("UIPadding", {
			PaddingRight = UDim.new(0, 8),
		}),
	}

	for parent, children in pairs(storyTree) do
		storyListChildren[parent] = e(SidebarList, {
			title = parent,
			children = children,
		})
	end

	return e("Frame", {
		BackgroundColor3 = theme.sideBar.background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
		}),

		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 3),
			PaddingTop = UDim.new(0, 2),
		}),

		StoriesLabel = e("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 20),
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Font = Enum.Font.SourceSansBold,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Text = `STORIES`,
			TextSize = 21,
			TextColor3 = theme.sideBar.storiesLabelTextColor,
		}, {
			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			}),
		}),

		StoryLists = e(AutomatedScrollingFrame, {
			layoutClass = "UIListLayout",
			native = {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, -20),
			},
		}, storyListChildren),
	})
end

return Sidebar

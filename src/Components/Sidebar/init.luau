local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local AutomatedScrollingFrame = require(script.Parent.AutomatedScrollingFrame)
local React = require(Hoarcekat.Packages.React)
local TextLabel = require(script.Parent.TextLabel)
local SidebarList = require(script.SidebarList)

local e = React.createElement
local StudioTheme = require(Hoarcekat.Plugin.Contexts.StudioTheme)

local useStoryCollection = require(Hoarcekat.Plugin.Hooks.useStoryCollection)

function Sidebar(props)
	local theme = React.useContext(StudioTheme.Context)

	local storyTree = useStoryCollection()

	local storyLists = {}
	for parent, children in pairs(storyTree) do
		storyLists[parent] = e(SidebarList, {
			title = parent,
			selectStory = props.selectStory,
			selectedStory = props.selectedStory,
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
		}),

		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 2),
		}),

		StoriesLabel = e("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 20),
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Font = Enum.Font.SourceSansBold,
			LayoutOrder = 1,
			Text = "STORIES",
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
		}, storyLists),
	})
end

return Sidebar

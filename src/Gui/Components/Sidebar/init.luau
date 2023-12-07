local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local SidebarList = require(script.SidebarList)
local StudioTheme = require(Hoarcekat.Plugin.Gui.Contexts.StudioTheme)
local useStoryCollection = require(Hoarcekat.Plugin.Gui.Hooks.useStoryCollection)

local e = React.createElement
local SCROLL_BAR_THICKNESS = 8

local function Sidebar()
	local theme = React.useContext(StudioTheme.Context)

	local storyTree = useStoryCollection()

	local storyListChildren = {
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.Name,
		}),
	}

	-- pairs is nowadays redundant but pairs in this case will avoid a strict type error
	for parent, children in pairs(storyTree) do
		storyListChildren[parent] = e(SidebarList, {
			title = tostring(parent),
			instanceChildren = children,
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
			PaddingLeft = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 5),
		}),

		StoriesLabel = e("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Font = Enum.Font.SourceSansBold,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Text = `STORIES`,
			TextSize = 20,
			TextColor3 = theme.sideBar.storiesLabelTextColor,
		}, {
			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			}),
		}),

		StoryLists = e("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			CanvasSize = UDim2.fromScale(0, 0),
			LayoutOrder = 2,
			BorderSizePixel = 0,
			ScrollBarThickness = SCROLL_BAR_THICKNESS,
			Size = UDim2.new(1, 0, 1, -30),
		}, storyListChildren),
	})
end

return Sidebar

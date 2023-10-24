local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local e = React.createElement
local Collapsible = require(Hoarcekat.Plugin.Components.Collapsible)
local IconListItem = require(Hoarcekat.Plugin.Components.IconListItem)

local function SidebarList(props)
	local contents = {}

	for childName, child in pairs(props.children) do
		if typeof(child) == "Instance" then
			contents["Instance" .. child.Name] = e(IconListItem, {
				activated = function()
					props.selectStory(child)
				end,
				icon = Assets.hamburger,
				selected = props.selectedStory == child,
				text = child.Name:sub(1, #child.Name - #".story"),
			})
		else
			contents["Folder" .. childName] = e(SidebarList, {
				selectStory = props.selectStory,
				selectedStory = props.selectedStory,
				title = childName,
			}, child)
		end
	end

	return e(Collapsible, {
		title = props.title,
	}, contents)
end

return SidebarList

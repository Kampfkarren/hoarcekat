--!nonstrict
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local e = React.createElement
local Collapsible = require(Hoarcekat.Plugin.Components.Collapsible)
local IconListItem = require(Hoarcekat.Plugin.Components.IconListItem)
local MainContext = require(Hoarcekat.Plugin.Contexts.MainContext)

local function SidebarList(props)
	local mainContext = React.useContext(MainContext.Context)
	local selectedStory, setSelectedStory = mainContext.selectedStory, mainContext.setSelectedStory
	local contents = {}

	for childName, child in pairs(props.children) do
		if typeof(child) == "Instance" then
			contents["Instance" .. child.Name] = e(IconListItem, {
				activated = function()
					if selectedStory == child then
						setSelectedStory(nil)
					else
						setSelectedStory(child)
					end
				end,
				icon = Assets.hamburger,
				selected = selectedStory == child,
				text = child.Name:sub(1, #child.Name - #".story"),
			})
		else
			contents["Folder" .. childName] = e(SidebarList, {
				title = childName,
			}, child)
		end
	end

	return e(Collapsible, {
		title = props.title,
	}, contents)
end

return SidebarList

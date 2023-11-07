--!nonstrict
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local Collapsible = require(Hoarcekat.Plugin.Gui.Components.Collapsible)
local IconListItem = require(Hoarcekat.Plugin.Gui.Components.IconListItem)
local MainContext = require(Hoarcekat.Plugin.Gui.Contexts.MainContext)

local e = React.createElement

local function SidebarList(props: { title: string, instanceChildren: { Instance } })
	local mainContext = React.useContext(MainContext.Context)
	local selectedStory, setSelectedStory = mainContext.selectedStory, mainContext.setSelectedStory
	local contents = {}

	for childName, child in props.instanceChildren do
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
				instanceChildren = child,
			})
		end
	end

	return e(Collapsible, {
		title = props.title,
	}, contents)
end

return SidebarList

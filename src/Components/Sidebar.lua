local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Collapsible = require(script.Parent.Collapsible)
local IconListItem = require(script.Parent.IconListItem)
local Maid = require(Hoarcekat.Plugin.Maid)
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactRodux = require(Hoarcekat.Vendor.RoactRodux)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local TextLabel = require(script.Parent.TextLabel)

local e = Roact.createElement

local Sidebar = Roact.PureComponent:extend("Sidebar")

local NONE = newproxy(true)
local USER_SERVICES = {
	"Workspace",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPlayer",
}

local function isStoryScript(instance)
	return instance:IsA("ModuleScript") and instance.Name:match("%.story$")
end

local function SidebarList(props)
	local contents = {}

	for childName, child in pairs(props.Children) do
		if typeof(child) == "Instance" then
			contents["Instance" .. child.Name] = e(IconListItem, {
				Activated = function()
					props.SelectStory(child)
				end,
				Icon = "rbxasset://textures/Icon_Stream_Off.png",
				Selected = props.SelectedStory == child,
				Text = child.Name:sub(1, #child.Name - #".story"),
			})
		else
			contents["Folder" .. childName] = e(SidebarList, {
				Children = child,
				SelectStory = props.SelectStory,
				SelectedStory = props.SelectedStory,
				Title = childName,
			})
		end
	end

	return e(Collapsible, {
		Title = props.Title,
	}, contents)
end

function Sidebar:init()
	self.maid = Maid.new()

	for _, serviceName in ipairs(USER_SERVICES) do
		local service = game:GetService(serviceName)

		self:lookForStories(service)

		self.maid:GiveTask(service.DescendantAdded:connect(function(child)
			self:lookForStories(child)
			self:checkStory(child)
		end))
	end
end

function Sidebar:patchStoryScripts(patch)
	if self.cleaning then return end

	local storyScripts = {}

	for storyScript in pairs(self.state.storyScripts or {}) do
		storyScripts[storyScript] = true
	end

	local modified = false

	for key, value in pairs(patch) do
		if value == NONE then
			value = nil
		end

		if storyScripts[key] ~= value then
			modified = true
			storyScripts[key] = value
		end
	end

	if modified then
		self:setState({
			storyScripts = storyScripts,
		})
	end
end

function Sidebar:lookForStories(instance)
	for _, child in ipairs(instance:GetDescendants()) do
		self:checkStory(child)
	end
end

function Sidebar:checkStory(instance)
	if isStoryScript(instance) then
		self:addStoryScript(instance)
	else
		self:removeStoryScript(instance)
	end
end

function Sidebar:addStoryScript(storyScript)
	local instanceMaid = Maid.new()

	instanceMaid:GiveTask(function()
		self:removeStoryScript(storyScript)
		self.maid[instanceMaid] = nil
	end)

	instanceMaid:GiveTask(storyScript.Changed:connect(function()
		if not isStoryScript(storyScript) then
			-- We were a story script, now we're not, remove us
			instanceMaid:DoCleaning()
		end
	end))

	instanceMaid:GiveTask(storyScript.AncestryChanged:connect(function()
		if not storyScript:IsDescendantOf(game) then
			-- We were removed from the data model
			instanceMaid:DoCleaning()
		end
	end))

	self:patchStoryScripts({
		[storyScript] = true,
	})

	self.maid[instanceMaid] = instanceMaid
end

function Sidebar:removeStoryScript(storyScript)
	self:patchStoryScripts({
		[storyScript] = NONE,
	})

	if storyScript:IsDescendantOf(game) then
		local changedConnection
		changedConnection = storyScript.Changed:connect(function()
			if isStoryScript(storyScript) then
				-- We didn't use to be a story script, now we are, add us
				self:addStoryScript(storyScript)
				changedConnection:Disconnect()
			end
		end)
	end
end

function Sidebar:willUnmount()
	self.cleaning = true
	self.maid:DoCleaning()
end

function Sidebar:render()
	return e(StudioThemeAccessor, {}, {
		function(theme)
			local storyTree = {}
			for storyScript in pairs(self.state.storyScripts) do
				local hierarchy = {}
				local parent = storyScript

				repeat
					table.insert(hierarchy, 1, parent)
					parent = parent.Parent
				until parent == game or parent == nil

				local current = storyTree
				for _, node in ipairs(hierarchy) do
					if node == storyScript then
						table.insert(current, storyScript)
						break
					end

					local name = node.Name

					if not current[name] then
						current[name] = {}
					end

					current = current[name]
				end
			end

			local storyLists = {}
			for parent, children in pairs(storyTree) do
				storyLists[parent] = e(SidebarList, {
					Children = children,
					SelectStory = self.props.selectStory,
					SelectedStory = self.props.selectedStory,
					Title = parent,
				})
			end

			return e("Frame", {
				BackgroundColor3 = theme:GetColor("ScrollBarBackground", "Default"),
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

				StoriesLabel = e(TextLabel, {
					Font = Enum.Font.SourceSansBold,
					LayoutOrder = 1,
					Text = "STORIES",
					TextColor3 = theme:GetColor("DimmedText", "Default"),
				}),

				StoryLists = e("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.fromScale(1, 1),
				}, storyLists),
			})
		end,
	})
end

return RoactRodux.connect(function(state)
	return {
		selectedStory = state.StoryPicker,
	}
end, function(dispatch)
	return {
		selectStory = function(story)
			dispatch({
				type = "SetSelectedStory",
				story = story,
			})
		end,
	}
end)(Sidebar)

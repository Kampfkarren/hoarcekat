local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Assets = require(Hoarcekat.Plugin.Assets)
local AutomatedScrollingFrame = require(script.Parent.AutomatedScrollingFrame)
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
				Icon = Assets.hamburger,
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
		IsSearching = props.IsSearching,
	}, contents)
end

local function getNumChildren(t)
	local count = 0

	for _, _ in pairs(t) do
		count += 1
	end
	return count
end

local function getKeyOfFirstChild(t): string | nil
	if typeof(t) == "Instance" then
		return nil
	end

	for key, _ in pairs(t) do
		return key
	end
end

function Sidebar:init()
	self.maid = Maid.new()

	for _, serviceName in ipairs(USER_SERVICES) do
		local service = game:GetService(serviceName)

		self:lookForStories(service)

		self.maid:GiveTask(service.DescendantAdded:Connect(function(child)
			self:lookForStories(child)
			self:checkStory(child)
		end))
	end

	self:setState({
		search = "",
	})
end

function Sidebar:patchStoryScripts(patch)
	if self.cleaning then
		return
	end

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

	instanceMaid:GiveTask(storyScript.Changed:Connect(function()
		if not isStoryScript(storyScript) then
			-- We were a story script, now we're not, remove us
			instanceMaid:DoCleaning()
		end
	end))

	instanceMaid:GiveTask(storyScript.AncestryChanged:Connect(function()
		if not storyScript:IsDescendantOf(game) then
			-- We were removed from the data model
			instanceMaid:DoCleaning()
		else
			self:setState({}) -- force update if parent changes
		end
	end))

	instanceMaid:GiveTask(storyScript:GetPropertyChangedSignal("Name"):Connect(function()
		if isStoryScript(storyScript) then
			self:setState({}) -- force update if name changes
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
		changedConnection = storyScript.Changed:Connect(function()
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
	local searchStr = self.state.search:lower()
	local isSearching = searchStr ~= ""

	return e(StudioThemeAccessor, {}, {
		function(theme)
			local storyTree = {}

			for storyScript in pairs(self.state.storyScripts or {}) do
				local hierarchy = {}
				local parent = storyScript

				local scriptName = storyScript.Name

				if isSearching and not scriptName:lower():find(searchStr, 1, true) then
					print("show", scriptName)
					continue
				end

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

			--[[
				if a parent folder has no children, combine with the parent
				{
					tree = {
						["ReplicatedStorage"] = {
							["System1"} = {
								["Folder3"} = {
									[1] = script : Instance
								}
							},
							["System2"} = {
								[1] = script : Instance
							}
						}
					}
					Becomes
					tree = {
						["ReplicatedStorage"] = {
							["System1/Folder3"} = {
								script : Instance
							},
							["System2"} = {
								[1] = script : Instance
							}
						}
					}
				}
			]]

			local function condense(t)
				local newT = {}
				for key, value in pairs(t) do
					if typeof(value) == "Instance" then
						newT[key] = value
						continue
					end

					local function areAllValuesStories()
						for _, child in pairs(value) do
							if typeof(child) ~= "Instance" or not child:IsA("ModuleScript") then
								return false
							end
						end

						return true
					end

					if areAllValuesStories() then
						newT[key] = value
						continue
					end

					local numChildren = getNumChildren(value)
					local newKey = key

					local r = 0
					repeat
						if numChildren == 1 then
							local childName = getKeyOfFirstChild(value)

							if not childName then
								break
							end

							local addKey: string = getKeyOfFirstChild(value)

							if type(addKey) == "number" then
								break
							end

							newKey ..= "/" .. addKey
							value = value[addKey]
							numChildren = getNumChildren(value)
						else
							value = condense(value)
							break
						end
						r += 1
					until r == 10

					if r == 10 then
						warn("Recursion limit reached")
					end

					newT[newKey] = value
				end

				return newT
			end

			storyTree = condense(storyTree)

			local storyLists = {}
			for parent, children in pairs(storyTree) do
				storyLists[parent] = e(SidebarList, {
					Children = children,
					SelectStory = self.props.selectStory,
					SelectedStory = self.props.selectedStory,
					Title = parent,
					IsSearching = isSearching,
				})
			end

			return e("Frame", {
				BackgroundColor3 = theme:GetColor("ScrollBarBackground", "Default"),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				UIPadding = e("UIPadding", {
					PaddingLeft = UDim.new(0, 5),
					PaddingTop = UDim.new(0, 2),
				}),

				Top = e("Frame", {
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
				}, {
					StoriesLabel = e(TextLabel, {
						Font = Enum.Font.SourceSansBold,
						LayoutOrder = 1,
						Text = "STORIES",
						TextColor3 = theme:GetColor("DimmedText", "Default"),
					}),

					SearchBox = e("TextBox", {
						Size = UDim2.new(0, 100, 1, -4),
						Position = UDim2.new(1, -20, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						PlaceholderText = "Search...",
						Text = "",
						TextXAlignment = Enum.TextXAlignment.Left,
						TextScaled = true,
						BackgroundColor3 = theme:GetColor("InputFieldBackground", "Default"),
						PlaceholderColor3 = theme:GetColor("DimmedText", "Default"),
						TextColor3 = theme:GetColor("MainText", "Default"),
						[Roact.Change.Text] = function(rbx)
							self:setState({
								search = rbx.Text,
							})
						end,
					}, {
						Corner = e("UICorner", {
							CornerRadius = UDim.new(0, 5),
						}),
						Stroke = e("UIStroke", {
							Thickness = 2,
							Color = theme:GetColor("Border", "Default"),
						}),
					}),
				}),

				StoryLists = e(AutomatedScrollingFrame, {
					LayoutClass = "UIListLayout",

					Native = {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 1, -20),
					},
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

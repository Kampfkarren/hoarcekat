--!nonstrict
local NONE = newproxy(true)

local function isStoryScript(instance)
	return instance:IsA("ModuleScript") and instance.Name:match("%.story$")
end

local StoryObserver = {}
StoryObserver.__index = StoryObserver

function StoryObserver.new(setStoryScripts)
	local self = setmetatable({}, StoryObserver)
	self.setStoryScripts = setStoryScripts
	return self
end

function StoryObserver:patchStoryScripts(patch)
	if self.cleaning then
		return
	end

	self.setStoryScripts(function(current)
		local storyScripts = {}

		for storyScript in pairs(current or {}) do
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
			return storyScripts
		end

		return current
	end)
end

function StoryObserver:lookForStories(instance)
	for _, child in ipairs(instance:GetDescendants()) do
		self:checkStory(child)
	end
end

function StoryObserver:checkStory(instance)
	if isStoryScript(instance) then
		self:addStoryScript(instance)
	else
		self:removeStoryScript(instance)
	end
end

function StoryObserver:addStoryScript(storyScript)
	local connectionA, connectionB

	local function clean()
		self:removeStoryScript(storyScript)
		connectionA:Disconnect()
		connectionB:Disconnect()
	end

	connectionA = storyScript.Changed:Connect(function()
		if not isStoryScript(storyScript) then
			-- We were a story script, now we're not, remove us
			clean()
		end
	end)

	connectionB = storyScript.AncestryChanged:Connect(function()
		if not storyScript:IsDescendantOf(game) then
			-- We were removed from the data model
			clean()
		end
	end)

	self:patchStoryScripts({
		[storyScript] = true,
	})
end

function StoryObserver:removeStoryScript(storyScript)
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

return StoryObserver

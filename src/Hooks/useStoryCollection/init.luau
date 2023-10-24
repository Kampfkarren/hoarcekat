local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local USER_SERVICES = require(Hoarcekat.Plugin.Config).userServices

local StoryObserver = require(script.StoryCollection)

local function useStoryCollection()
	local storyScripts, setStoryScripts = React.useState({})

	React.useEffect(function()
		local storyObserver = StoryObserver.new(setStoryScripts)

		local connections: { RBXScriptConnection } = {}

		for _, serviceName in ipairs(USER_SERVICES) do
			local service = game:GetService(serviceName)

			storyObserver:lookForStories(service)

			table.insert(
				connections,
				service.DescendantAdded:Connect(function(child)
					storyObserver:lookForStories(child)
					storyObserver:checkStory(child)
				end)
			)
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { setStoryScripts })

	return React.useMemo(function()
		local storyTree = {}

		for storyScript in pairs(storyScripts or {}) do
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

		return storyTree
	end, { storyScripts })
end

return useStoryCollection

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local USER_SERVICES = require(Hoarcekat.Plugin.Config).userServices

local StoryObserver = require(script.StoryObserver)

-- TODO: FIX TYPE ISSUES IN THIS SCRIPT (LINE G7 ONWARDS)

local function useStoryCollection()
	local storyScripts, setStoryScripts = React.useState({} :: { [Instance]: boolean })

	React.useEffect(function()
		local storyObserver = StoryObserver.new(setStoryScripts)

		local connections: { RBXScriptConnection } = {}

		for _, serviceName in USER_SERVICES do
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
	end, {})

	return React.useMemo(function()
		local storyTree = {}

		for storyScript in storyScripts do
			local hierarchy = {}
			local parent: Instance? = storyScript

			while parent ~= game and parent ~= nil do
				table.insert(hierarchy, 1, parent)

				if parent and parent.Parent then
					parent = parent.Parent
				else
					break
				end
			end

			local current = storyTree

			for _, node in hierarchy do
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

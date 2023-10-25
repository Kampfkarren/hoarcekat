local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local StoryPreviewer = require(script.StoryPreviewer)
local useUpdateEffect = require(Hoarcekat.Plugin.Gui.Hooks.useUpdateEffect)

local function useStoryPreview(rootRef, selectedStory, expand, setCurrentPreview)
	local storyPreviewer = React.useRef(StoryPreviewer.new(rootRef, setCurrentPreview))

	React.useEffect(function()
		if storyPreviewer.current then
			storyPreviewer.current:setSelectedStory(selectedStory)
			storyPreviewer.current:setExpand(expand)
			storyPreviewer.current:refreshPreview()
		end

		return function()
			if storyPreviewer.current then
				storyPreviewer.current:clearPreview()
			end
		end
	end, {})

	useUpdateEffect(function()
		if storyPreviewer.current then
			storyPreviewer.current:setSelectedStory(selectedStory)
			storyPreviewer.current:setExpand(expand)
			storyPreviewer.current:refreshPreview()
		end
	end, { storyPreviewer.current, selectedStory, expand })

	return storyPreviewer.current
end

return useStoryPreview

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)

local StoryPreviewer = require(script.StoryPreviewer)

local function useStoryPreview(rootRef, selectedStory, expand, setCurrentPreview)
	local storyPreviewer = React.useRef(nil)

	if storyPreviewer.current == nil then
		storyPreviewer.current = StoryPreviewer.new(rootRef, setCurrentPreview)
	end

	React.useEffect(function()
		if storyPreviewer.current then
			storyPreviewer.current:setSelectedStory(selectedStory)
			storyPreviewer.current:setExpand(expand)
			storyPreviewer.current:refreshPreview()
		end

		return function()
			if storyPreviewer.current ~= nil then
				storyPreviewer.current:clearPreview()
			end
		end
	end, { selectedStory, expand })

	return storyPreviewer.current
end

return useStoryPreview

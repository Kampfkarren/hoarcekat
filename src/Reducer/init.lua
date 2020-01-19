local StoryPicker = require(script.StoryPicker)

return function(state, action)
	state = state or {}

	return {
		StoryPicker = StoryPicker(state.StoryPicker, action),
	}
end

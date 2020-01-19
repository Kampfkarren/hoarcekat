return function(state, action)
	state = state or nil

	if action.type == "SetSelectedStory" then
		if state == action.story then
			return nil
		else
			return action.story
		end
	end

	return state
end

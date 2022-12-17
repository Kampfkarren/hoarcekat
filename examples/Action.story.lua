return function(target, actions)
	local counter = 0

	local instance = Instance.new("TextButton")
	instance.AnchorPoint = Vector2.new(0.5, 0.5)
	instance.Position = UDim2.fromScale(0.5, 0.5)
	instance.Size = UDim2.fromScale(0.3, 0.1)
	instance.Text = counter
	instance.Parent = target

	actions:Register("rbxassetid://401613236", function()
		counter = counter + 1
		instance.Text = counter
	end)

	return function()
		instance:Destroy()
	end
end

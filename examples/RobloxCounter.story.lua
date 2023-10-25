return function(target)
	local counter = 0

	local instance = Instance.new("TextButton")
	instance.AnchorPoint = Vector2.new(0.5, 0.5)
	instance.Position = UDim2.fromScale(0.5, 0.5)
	instance.Size = UDim2.fromScale(0.3, 0.1)
	instance.Text = counter
	instance.MouseButton1Click:Connect(function()
		counter = counter + 1
		instance.Text = counter
	end)

	instance.Parent = target

	return function()
		instance:Destroy()
	end
end

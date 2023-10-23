local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local FitComponent = require(script.Parent.FitComponent)
local Roact = require(Hoarcekat.Packages.Roact)

local e = Roact.createElement

local function Content(props)
	return e("TextLabel", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.5,
		LayoutOrder = props.Number,
		Size = UDim2.new(1, 0, 0, 30),
		Text = props.Number,
		TextColor3 = Color3.new(1, 1, 1),
	})
end

local function TestFitComponent()
	return e(FitComponent, {
		ContainerClass = "Frame",
		ContainerProps = {
			BackgroundColor3 = Color3.new(1, 0, 0), -- We should see red seep through
			ClipsDescendants = true, -- If size doesn't change, we won't see anything
		},
		LayoutClass = "UIListLayout",
		LayoutProps = {
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	}, {
		e(Content, { Number = 3 }),
		e(Content, { Number = 2 }),
		e(Content, { Number = 1 }),
	})
end

return function(target)
	local handle = Roact.mount(e(TestFitComponent), target, "FitComponent")

	return function()
		Roact.unmount(handle)
	end
end

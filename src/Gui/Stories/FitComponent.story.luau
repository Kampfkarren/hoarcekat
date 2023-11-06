local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)
local ReactRoblox = require(Hoarcekat.Packages.ReactRoblox)

local FitComponent = require(Hoarcekat.Plugin.Gui.Components.FitComponent)

local e = React.createElement

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
		containerClass = "Frame",
		containerProps = {
			BackgroundColor3 = Color3.new(1, 0, 0), -- We should see red seep through
			ClipsDescendants = true, -- If size doesn't change, we won't see anything
		},
		layoutClass = "UIListLayout",
		layoutProps = {
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	}, {
		e(Content, { Number = 3 }),
		e(Content, { Number = 2 }),
		e(Content, { Number = 1 }),
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(e(TestFitComponent), target))

	return function()
		root:unmount()
	end
end

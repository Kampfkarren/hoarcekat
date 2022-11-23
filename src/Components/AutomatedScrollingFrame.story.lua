local Hoarcekat = script:FindFirstAncestor("Storyboards")

local AutomatedScrollingFrame = require(script.Parent.AutomatedScrollingFrame)
local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement

local function Cruft()
	return e("Frame", {
		BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
		Size = UDim2.new(1, 0, 0, 150),
	})
end

local function TestScrollingFrame()
	return e(AutomatedScrollingFrame, {
		LayoutClass = "UIListLayout",
		Native = {
			Size = UDim2.fromScale(0.8, 0.8),
		},
	}, {
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
		e(Cruft),
	})
end

return function(target)
	local handle = Roact.mount(e(TestScrollingFrame), target, "AutomatedScrollingFrame")

	return function()
		Roact.unmount(handle)
	end
end

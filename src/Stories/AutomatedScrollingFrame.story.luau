local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)
local ReactRoblox = require(Hoarcekat.Packages.ReactRoblox)

local e = React.createElement
local AutomatedScrollingFrame = require(Hoarcekat.Plugin.Components.AutomatedScrollingFrame)

local function Cruft()
	return e("Frame", {
		BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
		Size = UDim2.new(1, 0, 0, 150),
	})
end

local function TestScrollingFrame()
	return e(AutomatedScrollingFrame, {
		layoutClass = "UIListLayout",
		native = {
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
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(e(TestScrollingFrame), target, "AutomatedScrollingFrame"))

	return function()
		root:unmount()
	end
end

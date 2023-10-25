local ServerStorage = game:GetService("ServerStorage")
local React = require(ServerStorage.Hoarcekat.Packages.React)
local ReactRoblox = require(ServerStorage.Hoarcekat.Packages.ReactRoblox)

local e = React.createElement

local function Counter()
	local counter, setCounter = React.useState(0)

	return e("TextButton", {
		Text = counter,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.3, 0.1),

		[React.Event.Activated] = function()
			setCounter(counter + 1)
		end,
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(e(Counter), target))

	return function()
		root:unmount()
	end
end

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local React = require(Hoarcekat.Packages.React)
local ReactRoblox = require(Hoarcekat.Packages.ReactRoblox)

local Assets = require(Hoarcekat.Plugin.Assets)
local FloatingButton = require(Hoarcekat.Plugin.Gui.Components.FloatingButton)

local e = React.createElement

local function TestFloatingButton()
	return e(FloatingButton, {
		activated = function()
			print("activated!")
		end,
		image = Assets.preview,
		imageSize = UDim.new(0, 24),
		size = UDim.new(0, 40),
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal(e(TestFloatingButton), target))

	return function()
		root:unmount()
	end
end

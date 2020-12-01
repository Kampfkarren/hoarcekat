local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local FloatingButton = require(script.Parent.FloatingButton)
local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement

local function TestFloatingButton()
	return e(FloatingButton, {
		Activated = function()
			print("activated!")
		end,
		Image = "rbxasset://textures/ui/InspectMenu/ico_inspect@2x.png",
		ImageSize = UDim.new(0, 24),
		Size = UDim.new(0, 40),
	})
end

return function(target)
	local handle = Roact.mount(e(TestFloatingButton), target, "FloatingButton")

	return function()
		Roact.unmount(handle)
	end
end

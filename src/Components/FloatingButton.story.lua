local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Assets = require(Hoarcekat.Plugin.Assets)
local FloatingButton = require(script.Parent.FloatingButton)
local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement

local function TestFloatingButton()
	return e("Frame", {
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
	}, {
		FloatingButton = e(FloatingButton, {
			Activated = function()
				print("activated!")
			end,
			TooltipText = "This is an example tooltip",
			Image = Assets.preview,
			ImageSize = UDim.new(0, 24),
			Size = UDim.new(0, 40),
		}),
	})
end

return function(target)
	local handle = Roact.mount(e(TestFloatingButton), target, "FloatingButton")

	return function()
		Roact.unmount(handle)
	end
end

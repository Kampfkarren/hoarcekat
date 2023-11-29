local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local ResizeableFrame = require(script.Parent.ResizeableFrame)
local Roact = require(Hoarcekat.Vendor.Roact)

local e = Roact.createElement


return function(target)
	local handle = Roact.mount(e(ResizeableFrame), target, "FitComponent")

	return function()
		Roact.unmount(handle)
	end
end

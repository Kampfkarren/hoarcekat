local Hoarcekat = script:FindFirstAncestor("Storyboards")

local Roact = require(Hoarcekat.Vendor.Roact)

local Preview = require(script.Parent.Preview)
local Sidebar = require(script.Parent.Sidebar)

local VerticalSplitter = require(script.Parent.VerticalSplitter)

local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local e = Roact.createElement

local function App(props)
	return e(StudioThemeAccessor, {}, {
		function(theme)
			return e("Frame", {
				BackgroundColor3 = theme:GetColor("MainBackground", "Default"),
				Size = UDim2.fromScale(1, 1),
			}, {
				Splitter = e(VerticalSplitter, {
					Mouse = props.Mouse,
					Plugin = props.Plugin,
				}, {
					Left = e(Sidebar),
					Right = e(Preview),
				}),
			})
		end,
	})
end

return App

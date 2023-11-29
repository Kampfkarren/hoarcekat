local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Roact = require(Hoarcekat.Vendor.Roact)

local Preview = require(script.Parent.Preview)
local Sidebar = require(script.Parent.Sidebar)

local VerticalSplitter = require(script.Parent.VerticalSplitter)
local ReizeableFrame = require(script.Parent.ForkedComponents.ResizeableFrame)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local e = Roact.createElement

local App = Roact.Component:extend("App")

function App:init()
	self._sidebarSize, self._updateSidebarSize = Roact.createBinding(300)
end

function App:render()
	return e(StudioThemeAccessor, {}, {
		function(theme)
			return e("Frame", {
				BackgroundColor3 = theme:GetColor("MainBackground", "Default"),
				Size = UDim2.fromScale(1, 1),
			}, {
				ReizeableFrame = e(ReizeableFrame, {
					resized = function(value)
						self._updateSidebarSize(value)
					end,
				}),

				Sidebar = e("Frame", {
					BackgroundTransparency = 1,
					Size = self._sidebarSize:map(function(value)
						return UDim2.new(0, value, 1, 0)
					end),
				}, {
					Sidebar = e(Sidebar),
				}),

				Preview = e("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(1, 0),
					Size = self._sidebarSize:map(function(value)
						return UDim2.new(1, -value, 1, 0)
					end),
				}, {
					Preview = e(Preview),
				}),
			})
		end,
	})
end

return App

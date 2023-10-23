local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local e = React.createElement
local VerticalSplitter = require(Hoarcekat.Plugin.Components.VerticalSplitter)

type Props = { children: any?, mouse: PluginMouse }

local function App(props: Props)
	return e("Frame", {
		Size = UDim2.fromScale(1, 1),
	}, {
		Splitter = e(VerticalSplitter, {
			mouse = props.mouse,
			size = UDim2.fromScale(1, 1),
		}, {
			Left = e("Frame", {
				BackgroundColor3 = Color3.fromRGB(14, 14, 14),
				Size = UDim2.fromScale(1, 1),
			}),
			Right = e("Frame", {
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				Size = UDim2.fromScale(1, 1),
			}),
		}),
	})
end

return App

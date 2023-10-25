local ServerStorage = game:GetService("ServerStorage")
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local ReactRoblox = require(ServerStorage.Hoarcekat.Packages.ReactRoblox)
local React = require(Hoarcekat.Packages.React)

local e = React.createElement
local MainContext = require(Hoarcekat.Plugin.Contexts.MainContext)
local StudioTheme = require(Hoarcekat.Plugin.Contexts.StudioTheme)
local VerticalSplitter = require(Hoarcekat.Plugin.Components.VerticalSplitter)
local Sidebar = require(Hoarcekat.Plugin.Components.Sidebar)
local Preview = require(Hoarcekat.Plugin.Components.Preview)

type Props = {
	root: ReactRoblox.RootType,
	plugin: any,
	children: any?,
	mouse: PluginMouse,
	savedState: { selectedStory: Instance? }?,
}

local function App(props: Props)
	local theme = React.useContext(StudioTheme.Context)

	return e(StudioTheme.Provider, nil, {
		MainContext = e(MainContext.Provider, {
			root = props.root,
			plugin = props.plugin,
			savedState = props.savedState,
		}, {
			HoarcekatHolder = e("Frame", {
				BackgroundColor3 = theme.holder.background,
				Size = UDim2.fromScale(1, 1),
			}, {
				Splitter = e(VerticalSplitter, {
					mouse = props.mouse,
					size = UDim2.fromScale(1, 1),
				}, {
					Left = e("Frame", {
						BackgroundColor3 = Color3.fromRGB(14, 14, 14),
						Size = UDim2.fromScale(1, 1),
					}, {
						Sidebar = e(Sidebar),
					}),
					Right = e("Frame", {
						BackgroundColor3 = theme.holder.background,
						Size = UDim2.fromScale(1, 1),
					}, {
						Preview = e(Preview),
					}),
				}),
			}),
		}),
	})
end

return App

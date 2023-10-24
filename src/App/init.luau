local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Sidebar = require(Hoarcekat.Plugin.Components.Sidebar)
local React = require(Hoarcekat.Packages.React)

local e = React.createElement
local VerticalSplitter = require(Hoarcekat.Plugin.Components.VerticalSplitter)
local StudioTheme = require(Hoarcekat.Plugin.Contexts.StudioTheme)

type Props = { children: any?, mouse: PluginMouse }

local function App(props: Props)
	local theme = React.useContext(StudioTheme.Context)

	return e(StudioTheme.Provider, nil, {
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
					Sidebar = e(Sidebar, {
						selectStory = function(story)
							print(story, "was selected!")
						end,
						selectedStory = "Test",
					}),
				}),
				Right = e("Frame", {
					BackgroundColor3 = theme.holder.background,
					Size = UDim2.fromScale(1, 1),
				}),
			}),
		}),
	})
end

return App

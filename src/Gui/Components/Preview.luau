local CoreGui = game:GetService("CoreGui")
local Selection = game:GetService("Selection")

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local StudioTheme = require(Hoarcekat.Plugin.Gui.Contexts.StudioTheme)
local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)
local FloatingButton = require(Hoarcekat.Plugin.Gui.Components.FloatingButton)
local MainContext = require(Hoarcekat.Plugin.Gui.Contexts.MainContext)
local useStoryPreview = require(Hoarcekat.Plugin.Gui.Hooks.useStoryPreview)

local e = React.createElement

local function Preview()
	local mainContext = React.useContext(MainContext.Context)
	local selectedStory = mainContext.selectedStory
	local theme = React.useContext(StudioTheme.Context)

	local rootRef = React.useRef(nil)

	local currentPreview, setCurrentPreview = React.useState(nil)
	local expand, setExpand = React.useState(false)

	local storyPreviewer = useStoryPreview(rootRef, selectedStory, expand, setCurrentPreview)

	local expandSelection = React.useCallback(function()
		setExpand(function(current)
			local newExpandValue = not current

			if storyPreviewer then
				storyPreviewer:setDisplayParent(if newExpandValue then CoreGui else nil)
				storyPreviewer:updateDisplay()
			end

			return newExpandValue
		end)
	end, { storyPreviewer })

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = rootRef,
	}, {
		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
		}),

		ExpandMessage = if expand and currentPreview
			then e("Frame", {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 15),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				Icon = e("ImageLabel", {
					Image = "rbxassetid://11569282129",
					Position = UDim2.fromScale(0.5, 0.4),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0, 0.1),
				}, {
					UISizeConstraint = e("UISizeConstraint", {
						MinSize = Vector2.new(50, 50),
						MaxSize = Vector2.new(300, 300),
					}),

					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1,
						AspectType = Enum.AspectType.ScaleWithParentSize,
						DominantAxis = Enum.DominantAxis.Height,
					}),
				}),

				Message = e("TextLabel", {
					Text = "Story Mounted in <b>Studio Viewport</b>",
					RichText = true,
					TextColor3 = theme.textColor,
					Font = Enum.Font.SourceSans,
					TextSize = 22,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextWrapped = true,
					BackgroundTransparency = 1,
				}),
			})
			else nil,

		SelectInstanceButton = e("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.99, 0.99),
			Size = UDim2.fromOffset(40, 40),
			ZIndex = 2,
		}, {
			Button = e(FloatingButton, {
				activated = function()
					if currentPreview ~= nil and currentPreview.target ~= nil then
						Selection:Set({ currentPreview.target })
					end
				end,
				image = Assets.preview,
				imageSize = UDim.new(0, 24),
				size = UDim.new(0, 40),
			}),
		}),

		ExpandButton = e("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.99, -45, 0.99, 0),
			Size = UDim2.fromOffset(40, 40),
			ZIndex = 2,
		}, {
			Button = e(FloatingButton, {
				activated = expandSelection,
				image = "rbxasset://textures/ui/VR/toggle2D.png",
				imageSize = UDim.new(0, 24),
				size = UDim.new(0, 40),
			}),
		}),
	})
end

return Preview

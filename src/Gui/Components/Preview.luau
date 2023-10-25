--!nonstrict
local CoreGui = game:GetService("CoreGui")
local Selection = game:GetService("Selection")

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local React = require(Hoarcekat.Packages.React)

local Assets = require(Hoarcekat.Plugin.Assets)

local e = React.createElement
local StudioTheme = require(Hoarcekat.Plugin.Gui.Contexts.StudioTheme)
local MainContext = require(Hoarcekat.Plugin.Gui.Contexts.MainContext)
local FloatingButton = require(Hoarcekat.Plugin.Gui.Components.FloatingButton)

local useStoryPreview = require(Hoarcekat.Plugin.Gui.Hooks.useStoryPreview)

function Preview()
	local mainContext = React.useContext(MainContext.Context)
	local selectedStory = mainContext.selectedStory

	local theme = React.useContext(StudioTheme.Context)

	local rootRef = React.useRef(nil)

	local currentPreview, setCurrentPreview = React.useState(nil)
	local expand, setExpand = React.useState(false)

	local storyPreviewer = useStoryPreview(rootRef, selectedStory, expand, setCurrentPreview)

	local selectStoryInstance = React.useCallback(function()
		if currentPreview and currentPreview.target then
			Selection:Set({ currentPreview.target })
		end
	end, { currentPreview })

	local expandSelection = React.useCallback(function()
		setExpand(function(current)
			local newExpandValue = not current
			storyPreviewer:setDisplayParent(if newExpandValue then CoreGui else nil)
			storyPreviewer:updateDisplay()
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

		SelectInstanceButton = e("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.99, 0.99),
			Size = UDim2.fromOffset(40, 40),
			ZIndex = 2,
		}, {
			Button = e(FloatingButton, {
				activated = selectStoryInstance,
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

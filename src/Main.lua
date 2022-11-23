local RunService = game:GetService("RunService")

local Hoarcekat = script:FindFirstAncestor("Storyboards")

local Reducer = require(script.Parent.Reducer)
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactRodux = require(Hoarcekat.Vendor.RoactRodux)
local Rodux = require(Hoarcekat.Vendor.Rodux)

local App = require(script.Parent.Components.App)

local function getSuffix(plugin)
	if plugin.isDev then
		return " [DEV]", "Dev"
	else
		return "", ""
	end
end

local function Main(plugin, savedState)
	local displaySuffix, nameSuffix = getSuffix(plugin)
	local toolbar = plugin:toolbar("Storyboards" .. displaySuffix)

	local toggleButton = plugin:button(toolbar, "Storyboards", "Open the Storyboards window", "rbxassetid://11600481404")

	local store = Rodux.Store.new(Reducer, savedState)

	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 0, 0)
	local gui = plugin:createDockWidgetPluginGui("Storyboards" .. nameSuffix, info)
	gui.Name = "Storyboards" .. nameSuffix
	gui.Title = "Storyboards " .. displaySuffix
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	toggleButton:SetActive(gui.Enabled)

	local connection = toggleButton.Click:Connect(function()
		gui.Enabled = not gui.Enabled
		toggleButton:SetActive(gui.Enabled)
	end)

	local app = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		App = Roact.createElement(App, {
			Mouse = plugin:getMouse(),
			Plugin = plugin
		}),
	})

	local instance = Roact.mount(app, gui, "Storyboards")

	plugin:beforeUnload(function()
		Roact.unmount(instance)
		connection:Disconnect()
		return store:getState()
	end)

	if RunService:IsRunning() then
		return
	end

	local unloadConnection
	unloadConnection = gui.AncestryChanged:Connect(function()
		print("New Storyboards version coming online; unloading the old version")
		unloadConnection:Disconnect()
		plugin:unload()
	end)
end

return Main

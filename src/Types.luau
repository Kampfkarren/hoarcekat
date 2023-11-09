type Toolbars = { [string]: PluginToolbar }
type Widgets = { [string]: DockWidgetPluginGui }
type Buttons = { [PluginToolbar]: { [string]: PluginToolbarButton } }
type WatchingType = { [Instance]: { RBXScriptConnection } }
type BeforeUnloadCallback = () -> SaveState

export type SaveState = { selectedStory: Instance? }

export type PluginFacade = {
	_toolbars: Toolbars,
	_pluginGuis: Widgets,
	_buttons: Buttons,
	_watching: WatchingType,
	_beforeUnload: BeforeUnloadCallback?,
	isDev: boolean,

	toolbar: (self: PluginFacade, string) -> PluginToolbar,
	button: (self: PluginFacade, PluginToolbar, string, string, string) -> PluginToolbarButton,
	createDockWidgetPluginGui: (self: PluginFacade, string, ...any) -> DockWidgetPluginGui,
	getMouse: (self: PluginFacade) -> PluginMouse,
	beforeUnload: (self: PluginFacade, BeforeUnloadCallback) -> (),
	_load: (self: PluginFacade, SaveState) -> (),
	_reload: (self: PluginFacade) -> (),
	unload: (self: PluginFacade) -> SaveState,
	_watch: (self: PluginFacade, Instance) -> (),
}

export type StoryArray = { ModuleScript }
export type StoryTree = StoryArray | { [string]: StoryTree }
export type StoryScripts = { [Instance]: boolean }

return nil

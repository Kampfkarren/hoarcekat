<center><h1>Hoarcekat</h1></center>

## What is it?

Hoarcekat is a [Storybook-like](https://storybook.js.org/) plugin that makes it easy to preview individual UI elements.

Developers write "stories" that explain how their UI should be previewed. It runs without any knowledge of the rest of your application, meaning you can use it to easily create and preview your UI as isolated components.

With that in mind, Hoarcekat is **especially** useful when using libraries such as:
- [React-Lua](https://github.com/jsdotlua/react-lua) (or legacy [Roact](https://roblox.github.io/roact/)), 
- [Fusion](https://elttob.uk/Fusion)
- [Plasma](https://eryn.io/plasma/)

> Note: You do **not** have to use these libraries to be able to use Hoarcekat.



## How do I write a story?

Stories are simply a `ModuleScript` whose name ends with `.story`. A story returns a function that takes an `Instance` (the preview frame) that then returns a destructor function, which cleans up the instance of anything the component put in.

It's much simpler to understand when you look at [an example story](https://github.com/Kampfkarren/hoarcekat/blob/master/examples/RobloxCounter.story.luau).

## How do I download it?

> Method 1:

You can download the plugin [on the Roblox marketplace](https://www.roblox.com/library/4621580428/Hoarcekat).

> Method 2:

You can download the latest version in the [GitHub releases](https://github.com/Kampfkarren/hoarcekat/releases). From here, go to the "Plugins Folder" found under the "Plugins" tab in Roblox Studio, and put the `.rbxmx` in there.

## Why the name?

Roblox engineers have been working on their own Storybook-like plugin for a long time named "Horsecat". However, due to problems with which the solutions are outside their control, it has not been made available to the public yet. Hoarcekat is meant to hold over until the official Horsecat is unveiled. Thus, the name is just an intentionally botched spelling.

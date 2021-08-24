!!! info
	The following example assumes that you have successfully managed to [install Phantasm](/guide/installation) into `ReplicatedStorage`

Insert a new `LocalScript` instance into `StarterPlayer.StarterPlayerScripts` either via within Roblox Studio or via Rojo:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phantasm = require(ReplicatedStorage.PhantasmEngine)

local interfaceData = {
	Functions = {};
	Bindings = {};
	Elements = {
		HelloWorld = {
			ClassName = "TextLabel";
			Properties = {
				Size = UDim2.new(1, 0, 0, 250);
				Text = "Hello World!";
			};
		};
	};
}

local interface = Phantasm.mount(interfaceData)
```
When you run this in your game, you should see a large label spanning across your screen with the words "Hello World!" appear!
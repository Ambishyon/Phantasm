Everything in Phantasm is built out of elements. They are they smallest building blocks in the creation of UIs.

Elements are what describe how you want your UI to look and behave at a singular point in time. While an Element can be changed via code like any other instance once the interface has been mounted, this is not advised and you would be better off either using a `Binding` for a property or creating a `Component`.

Elements are automatically created based on the table structure provided in the `Elements` index of the interface's data. It requires a Roblox class name to be provided or, if using a component, a class name of "Component" and then provide the name of that component separately:

```lua
local interfaceData = {
	Elements = {
		Element1 = {
			ClassName = "Frame";
			Properties = {
				Size = UDim2.new(0, 20, 0, 20);
			};
		};
		ComponentElement = {
			ClassName = "Component";
			Component = "Slider";
			Properties = {
				Size = UDim2.new(0, 50, 0, 15);
				Value = .4;
			};
		};
	};
}
```

You can represent children of an Element by providing it with a `Children` index:

```lua
local interfaceData = {
	Elements = {
		Element1 = {
			ClassName = "Frame";
			Properties = {
				Size = UDim2.new(0, 20, 0, 20);
			};
			Children = {
				ChildElement = {
					ClassName = "TextLabel";
					Properties = {
						Text = "Hello World!";
					};
				};
			};
		};
		ComponentElement = {
			ClassName = "Component";
			Component = "Slider";
			Properties = {
				Size = UDim2.new(0, 50, 0, 15);
				Value = .4;
			};
			Children = {
				ChildElement = {
					ClassName = "TextLabel";
					Properties = {
						Text = "Components can have children too!";
					};
				};
			};
		};
	};
}
```

Defining the interface structure on its own doesn't do anything, however. In order to transform our interface structure into an actual, functioning interface with real Roblox instances, we need to call `PhantasmEngine.mountInterface`:

```lua
local myInterface = PhantasmEngine.mountInterface(interfaceData)
```

Mounting creates a new `Interface` object from the data you provide, and optionally if the second argument is provided, it will use the Instance provided as the container for all your interface's elements. If not provided, it will automatically generate a new ScreenGui which will be used as the container.

`PhantasmEngine.mountInterface` returns the `Interface` object that can be later used to destroy it or get information from it with `PhantasmEngine.demountInterface` or indexing the `Interface` object.

## Changing What's Being Rendered

In order to change the UI that has been created, it is as simple as getting the desired element in the interface and changing it's properties, which can be done in the same way you would an actual Roblox instance!

The `Interface` object and all of the elements and components parented to it are designed so that you can interact with them just like you would an actual Roblox instance for the sake of convenience.

Using `myInterface` from above, we can update the size and text of our label/frame:

```lua
myInterface.Element1.Size = UDim2.new(0, 50, 0, 20)
myInterface.Element1.ChildElement.Text = "Hello Again World!"
```

!!! info
	It is generally not advised to interact with the interface directly like this unless it is absolutely necessary.

	You should use a `Binding` or `Component` instead.

## Demounting the Interface

Phantasm provides a method called `PhantasmEngine.demountInterface` that can be used when we're done with our interface.

```lua
PhantasmEngine.demountInterface(myInterface)
```

Demounting destroys the `Interface` object, removes it from the render queue, and recursively destroys all the child elements and components, allowing the Roblox Instances those elements were occupying to be reused by other interfaces.

!!! warning
	Trying to use an interface after it has been passed to `PhantasmEngine.demountInterface` will result in errors!

## Incrementing Counter

Utilizing what we have covered so far, we can make a simple interface that tells you how long it has been running for.

This is a full example that should work when put into a `LocalScript` in `StarterPlayerScripts`. It makes the assumption that Phantasm has been installed into `ReplicatedStorage`

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phantasm = require(ReplicatedStorage.PhantasmEngine)

local interfaceData = {
	Elements = {
		TimeLabel = {
			ClassName = "TextLabel";
			Properties = {
				Size = UDim2.new(1, 0, 1, 0);
				Text = "Time Elapsed: 0";
			};
		};
	};
}

local currentTime = 0
local interface = Phantasm.mountInterface(interfaceData)

while true do
	wait(1)

	currentTime += 1
	interface.TimeLabel.Text = "Time Elapsed: " .. currentTime
end
```

In the next section, we'll cover components, which allow us to create reusable groups of elements, and introduce one of the two primary techniques to dynamically change UI in Phantasm.
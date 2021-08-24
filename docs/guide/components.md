Components are contained, reusable parts of your interface that you can combine to build a complete interface.

Components accept custom properties, and return elements that should represent those properties to be placed within its container.

## Types of Components

### Function Components

A *function* component is a component that was created from an element in the interface's or component's tree that was defined as a function. They're simply a function that returns a dynamic result.

```lua
{
	function()
		return {
			Element1 = {
				ClassName = "Frame";
				Properties = {
					BackgroundColor3 = Color3.new(0,0,0);
				};
			};
		}
	end;
}
```

### Dynamic Components

A *dynamic* component is a component that has been defined in either the interface's components index, the engine's components folder, or the shared components folder in `ReplicatedStorage.Phantasm`

```lua
{
	Properties = {
		Username = {
			Type = "string";
			Default = "Robloxian";
		};
	};

	Functions = {
		PrintUsername = function(self)
			print(self.Username)
		end;
	};

	InitialSize = UDim2.new(0, 80, 0, 20);
	Icon = "";
	Category = "";
	Description = "";

	Init = function(self, context, interfaceContext)
		print("Initialized Hello!")
	end;

	PreRender = function(self, context, interfaceContext)

	end;

	Constructor = function(self, context, interfaceContext)
		return {
			{
				ClassName = "TextLabel";
				Properties = {
					Text = "Hello, " .. self.Username .. "!";
				};
			};
		}
	end;

	PostRender = function(self, context, interfaceContext)

	end;
}
```

To explain what each of these means:

`Properties` - A table with property definitions which defines what type the property is, what it's defaults are, and depending on the property, various other factors that the editor uses to display it properly.

`Functions` - A table with function definitions which can be used as if they were a method of the component itself (ex: `Component:PrintUsername()` would fire the `PrintUsername` function in this table).

`InitialSize` - The initial size of the component when it is inserted in the editor.

`Icon` - The component's icon when displayed within the editor's Interface Explorer.

`Category` - The component's category within the editor's Insert window.

`Description` - The component's description when hovered over within the editor's Insert window or Interface Explorer.

`Init` - A function called by the engine when initializing the component.

`PreRender` - A function called by the engine right before the component is rendered.

`Constructor` - A function to be called by the engine when rendering the component to determine how it should appear dynamically.

`PostRender` - A function called by the engine right after the component has been rendered.

## Using Components

In our previous examples, we simply passed the ClassName of a Roblox Instance as an index when defining an element in our interface.

To define a component in our interface, we define the ClassName index as `Component` and specify what component we mean by defining the Component index as a string referring to the name of that component:

```lua
{
	ClassName = "Component";
	Component = "Hello";
	Properties = {
		Username = "Kamijou Touma";
	};
}
```

!!! info
	It is also possible to use components within other components!

!!! warning
	Make sure to avoid defining circular components, as Phantasm has no protection against this it will continuously create more and more components within them until your client crashes!

## Improving our Incrementing Counter

Now that we know how components work, we can revisit our incrementing counter example from the previous section and improve it using a function component. Changed sections have been highlighted.

```lua hl_lines="8 9 10 11 12 13 14 15 16 17 18 19"
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phantasm = require(ReplicatedStorage.PhantasmEngine)

local currentTime = 0
local interfaceData = {
	Elements = {
		-- Define a function component that represents our UI
		function()
			return {
				TimeLabel = {
					ClassName = "TextLabel";
					Properties = {
						Size = UDim2.new(1, 0, 1, 0);
						Text = "Time Elapsed: " .. currentTime
					};
				};
			}
		end;
	};
}
local interface = Phantasm.mountInterface(interfaceData)

while true do
	wait(1)

	currentTime += 1
end
```

!!! info
	If you want to try and take it a step further, why not try turning it into a reusable `Dynamic Component` on your own to learn how to use them!
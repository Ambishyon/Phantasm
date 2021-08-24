Phantasm handles Instance event connections automatically as part of the rendering process.

To connect an event, simply pass a property with `Phantasm.Event.EVENT_NAME` as the key and a function as the value.

Phantasm will automatically connect this function to the event for you and will pass the element that the event is connected to as the first argument to the callback, followed by any arguments that Roblox passed.

```lua
{
	ClassName = "TextButton"
	Properties = {
		Text = "Click me I beg you!";
		Size = UDim2.new(0, 200, 0, 80);

		[Phantasm.Event.Activated] = function()
			print("The button has been clicked!")
		end;
	};
}
```

To listen for `GetPropertyChangedSignal`, Phantasm provides a similar API, using properties with `Phantasm.Changed.PROPERTY_NAME` as their key:

```lua
{
	ClassName = "TextButton"
	Properties = {
		Text = "Click me I beg you!";
		Size = UDim2.new(0, 200, 0, 80);

		[Phantasm.Changed.AbsoluteSize] = function(element)
			print("Absolute size has changed to", element.AbsoluteSize)
		end;
	};
}
```

!!! info
	Events will automatically be disconnect when the element is destroyed!

!!! warning
	There is currently debate around whether or not an event should be defined using a custom `Event` type as a key instead of directly referencing the event's name so this may be subject to change in a future version.

As of right now, there exists no method to listen to `GetPropertyChangedSignal`, which was an oversight during the original creation of the engine and has plans to be fixed in the future.
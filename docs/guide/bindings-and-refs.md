In certain situations, Phantasm's process of managing properties is inadequite for managing some instance properties, and in cases where a property needs to change often, manually changing it via external code or a component is inefficient. Phantasm introduces Bindings and Refs for cases like this.

Bindings and Refs are intended to be used in cases where Phantasm is unable to solve a problem directly or its solution might not be performant enough or ideal, such as:

* Invoking functions on Roblox instances
* Gamepad selection
* Dynamic properties

## Bindings

Bindings are a objects that Phantasm uses to automatically evaluate and change the properties they have been subscribed to. When the engine determines that a binding's output has changed, it will automatically apply this change to the properties that have been subscribed to it.

### Properties

Bindings can be specified either from a module in the engine's Bindings folder, the Bindings table within the interface, or from the shared Bindings folder in `ReplicatedStorage.Phantasm`. As a result of this, bindings can be given a set of properties to use when they are being evaluated.

### Binding a Property

Bindings can be bound to a property with ease, simply define that property's value using a table format with the `Type` key being equal to `Binding`, the `Name` key being the name of the binding you want to use, and the `Properties` key, if present, being a table of properties to provide the binding at the time of evaluation. Alternatively, you can simplify this process by using `Phantasm.createBinding()`, which will create the data structure for you like so:

```lua
{
	Element = {
		ClassName = "TextLabel";
		Properties = {
			Text = Phantasm.createBinding("Name", {})
		};
	};
}
```

### Creating a Binding

To create a binding, define a data structure with keys for the `Properties`, `ReturnType`, `Category`, `Description`, and `Run` function like so:

```lua
{
	Properties = {
		FormatString = {
			Type = "string";
			Default = "OS Time: %s";
		};
	};
	ReturnType = "string";
	Category = "Time";
	Description = "Returns a formatted os.time string";
	Run = function(element, arguments)
		return string.format(arguments.FormatString, tostring(os.time()))
	end;
}
```

The reason why `ReturnType`, `Category`, and `Description` should be provided is because they tell Phantasm's editor what it should return, what category it should be in, and what to display when hovering over it for the description. These are useful because it allows you to guarantee that a UI designer will only apply this binding to properties that it will work on, and that the designer knows what they are intended for.

Similarly, the reason you need to define values in `Properties` as a table with a `Type` and `Default` is so that the editor can handle these appropriately and make sure they don't result in a binding being incorrectly applied.

## Refs

While bindings are incredibly helpful for individual properties, we may often want to access or reference an entire Roblox Instance and its methods, or provide a specific element to a component to be used for some purpose.

*Refs* are a special object that point to either an element's Roblox Instance or the element itself depending on the context.

A ref will point to an element's Roblox instance when being used as an element's property, while it will point to the element itself if it is being used as a property for a component, binding, or function.

### Refs in Action

To use a ref, call `Phantasm.createRef()` and put the result somewhere persistent, such as within `context` or `interfaceContext`. An optional argument can also be provided to specify the element or the element's id to reference it to.

```lua
{
	Init = function(self, context, interfaceContext)
		context.nextElement = phantasm.createRef()
	end;
}
```

Finally, we create the elements in the component's `Constructor`. in NextElement, we use the special key `Phantasm.Ref` to allow us to tell the engine to automatically assign the reference at `context.nextElement` to NextElement so that it may be used by Element either in that call or the next (this depends on the order in which the elements are created).

```lua
{
	Constructor = function(self, context, interfaceContext)
		return {
			Element = Phantasm.createElement("TextButton", {
				NextSelectionLeft = context.nextElement;
			});

			NextElement = Phantasm.createElement("TextButton", {
				[Phantasm.Ref] = context.nextElement;
			});
		}
	end;
}
```

!!! info
	If you want to access a Ref from external code or via a higher/different component, you can specify it in the component's context and access it via `componentName.Context`
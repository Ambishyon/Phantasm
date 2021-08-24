!!! warning
	This documentation is currently incomplete and will be finished in the near future. For now, most of the important methods and constants have been documented.

## Methods

### Phantasm.createElement

```
Phantasm.createElement(className, [props, [children]]) -> table
```

Creates an Element data structure that describes information about how a Roblox Instance should look like that can be used within an interface.

The `children` argument is a table specifying elements that are parented to this element.

!!! caution
	Modifying `props` after they're passed to into `createElement` may result in unexpected behaviour, use a Component instead.

---

### Phantasm.createComponent

```
Phantasm.createComponent(componentName, [props, [children]]) -> table
```

Creates a Component data structure that describes information about how a Component should be displayed that can be used within an interface.

---

### Phantasm.mountInterface

```
Phantasm.mountInterface(interfaceData, [parent]) -> PhantasmInterface
```

Generates a `PhantasmInterface` object that will create and handle all the elements, components, and fragments as specified in the `interfaceData` argument.

The resulting `PhantasmInterface` object can be interacted with nearly as if it were itself a Roblox Instance and can be passed to APIs like `Phantasm.unmountInterface`. It may also be used in the future for debugging APIs.

---

### Phantasm.demountInterface

```
Phantasm.demountInterface(interface) -> void
```

Destroys the given `PhantasmInterface` and all of its descendants. Does not work on a Roblox Instance and will also remove the interface from the render stack -- this must be given an interface that was returned by `Phantasm.mountInterface`.

---

## Constants

### Phantasm.Ref

Use `Phantasm.Ref` as a key in the properties of an element or component to tell the engine to automatically set that element or component as the specified Ref's reference.

More information about this can be found on [this page](../guide/bindings-and-refs).

---

### Phantasm.Event

Index into `Phantasm.Event` to receive a key that can be used to connect to events when creating elements:

```lua
Phantasm.createElement("TextButton", {
	[Phantasm.Event.Activated] = function(element, inputObject, clickCount)
		print(element, "clicked with inputObject", inputObject, "and count", clickCount)
	end;
})
```

!!! info
	Event callbacks receive the Phantasm Element as the first parameter, followed by any parameters yielded by the event.

Reference the [events guide](../guide/events) for further details.

---

### Phantasm.Changed

Index into `Phantasm.Changed` to receive a key that can be used to connect to [`GetPropertyChangedSignal`](http://wiki.roblox.com/index.php?title=API:Class/Instance/GetPropertyChangedSignal) events.

It functions similarly to `Phantasm.Event`:

```lua
Phantasm.createElement("TextButton", {
	[Phantasm.Changed.AbsoluteSize] = function(element)
		print("TextButton absoluteSize changed to", element.AbsoluteSize)
	end;
})
```
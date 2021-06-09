local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local PHANTASMFOLDER = ReplicatedStorage:WaitForChild("Phantasm")
local DEBUGMODE = true

local module = {}

local Classes = script.Parent.Parent.Classes
local Element
local Component

local engine = script.Parent.Parent
local folders = {
	Bindings = engine.Bindings;
	Functions = engine.Functions;
	Components = engine.Components;
}

local caches = {
	Bindings = {};
	Components = {};
	Functions = {};
}

local tweenableValues = {
	"string";
	"number";
	"boolean";
	"CFrame";
	"Color3";
	"UDim2";
	"UDim";
	"Ray";
	"NumberRange";
	"NumberSequenceKeypoint";
	"PhysicalProperties";
	"NumberSequence";
	"Region3";
	"Rect";
	"Vector2";
	"Vector3";
}

function module:IsTweenable(value)
	return table.find(tweenableValues, typeof(value)) ~= nil
end

function module:GetBinding(tree, name)
	tree = rawget(tree, "Data")
	if tree.Bindings and tree.Bindings[name] then
		return tree.Bindings[name].Run
	else
		if caches.Bindings[name] then
			return caches.Bindings[name].Run
		else
			local result = folders.Bindings:FindFirstChild(name) or PHANTASMFOLDER.Bindings:FindFirstChild(name)
			if result then
				local data = require(result)
				caches.Bindings[name] = data
				return data.Run
			end
		end
	end
end

function module:GetComponent(tree, name)
	tree = rawget(tree, "Data")
	if tree.Components and tree.Components[name] then
		return tree.Components[name]
	else
		if caches.Components[name] then
			return caches.Components[name]
		else
			local result = folders.Components:FindFirstChild(name) or PHANTASMFOLDER.Components:FindFirstChild(name)
			if result then
				local data = require(result)
				caches.Components[name] = data
				return data
			end
		end
	end
end

function module:ExecuteFunction(value, element, arguments, ...)
	if type(value) == "function" then
		return value(element, arguments, ...)
	elseif type(value) == "table" and value.Type == "Function" then
		local func = module:GetFunction(element.Tree, value.Name)
		if func then
			return func.Run(element, arguments, ...)
		end
	end
end

function module:GetFunction(tree, name)
	tree = rawget(tree, "Data")
	if tree.Functions and tree.Functions[name] then
		return tree.Functions[name]
	else
		if caches.Functions[name] then
			return caches.Functions[name]
		else
			local result = folders.Functions:FindFirstChild(name) or PHANTASMFOLDER.Functions:FindFirstChild(name)
			if result then
				local data = require(result)
				caches.Functions[name] = data
				return data
			end
		end
	end
end

--- A function that gets an element relative to another element using a path
function module:GetElementFromPath(object, path)
	local current = object
	local route = string.split(path, ".")

	for _, to in pairs(route) do
		current = current[to]
	end

	return current
end

--- A function that generates an individual element
function module:GenerateElement(name, ourTree, data, parent)
	if Element == nil then
		Element = require(Classes.Element)
	end
	if Component == nil then
		Component = require(Classes.Component)
	end

	local newElement

	if type(data) == "function" then
		module:DebugPrint("Creating component with name",name,"using constructor function:")
		module:DebugPrint(data)

		newElement = Component.new(name, data, ourTree, parent or ourTree)
	elseif data.ClassName == "Component" then
		module:DebugPrint("Creating component with name",name,"and data:")
		module:DebugPrint(data)

		newElement = Component.new(name, data, ourTree, parent or ourTree)
		if data.Overlay then
			newElement.Object.Parent = ourTree.OverlayGUI
		end

		if data.Children then
			newElement.Children = module:GenerateElements(ourTree, data.Children, newElement)
		end
	else
		module:DebugPrint("Creating element with name",name,"and data:")
		module:DebugPrint(data)

		newElement = Element.new(name, data, ourTree, parent or ourTree)
		if data.Overlay then
			newElement.Object.Parent = ourTree.OverlayGUI
		end

		if data.Children then
			newElement.Children = module:GenerateElements(ourTree, data.Children, newElement)
		end
	end

	return newElement
end

--- A function that generates an element tree
function module:GenerateElements(ourTree, data, mainParent)
	if Element == nil then
		Element = require(Classes.Element)
	end
	if Component == nil then
		Component = require(Classes.Component)
	end
	local function traverseTree(tree, parent)
		local results = {}

		for name, v in pairs(tree) do
			local newElement = module:GenerateElement(name, ourTree, v, parent)

			results[name] = newElement
		end

		return results
	end

	return traverseTree(data, mainParent)
end

function module:InDebugMode()
	return DEBUGMODE
end

function module:DebugPrint(...)
	if DEBUGMODE then
		print("[PHANTASM]:", ...)
	end
end

function module:DeepCopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[module:DeepCopy(orig_key, copies)] = module:DeepCopy(orig_value, copies)
			end
			setmetatable(copy, module:DeepCopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function module:CopyTo(from, to)
	for i, v in pairs(from) do
		to[i] = module:DeepCopy(v)
	end
end

function module:ReconcileTable(target, template)
	for name, value in pairs(template) do
		if type(name) ~= "string" then
			continue
		end
		if target[name] == nil then
			target[name] = module:DeepCopy(value)
		elseif typeof(value) == "table" and typeof(target[name]) == "table" then
			module:ReconcileTable(target[name], value)
		end
	end
end

function module:ApplyDifferences(tab: table, differences: table): table
	local changed = {}

	for i, v in pairs(differences.Additions) do
		tab[i] = v
		table.insert(changed, i)
	end

	for _, v in pairs(differences.Deletions) do
		tab[v] = nil
		table.insert(changed, v)
	end

	for i, v in pairs(differences.Changes) do
		if typeof(v) == "table" and v.Changes and v.Additions and v.Deletions then
			module:ApplyDifferences(tab[i], v)
		else
			tab[i] = v
		end
		table.insert(changed, i)
	end

	return changed
end

function module:GenerateDifferences(table1, table2, alreadyChecked)
	local alreadyChecked = alreadyChecked or {}
	local diffList = {
		Additions = {};
		Changes = {};
		Deletions = {};
	}

	for name, value in pairs(table1) do
		if table2[name] ~= nil then
			if typeof(table2[name]) == "table" and typeof(value) == "table" then
				if alreadyChecked[table2[name]] or alreadyChecked[value] then
					continue
				end
				alreadyChecked[table2[name]] = true
				alreadyChecked[value] = true
				if not module:CompareTables(value, table2[name]) then
					diffList.Changes[name] = module:GenerateDifferences(value, table2[name], alreadyChecked)
				end
			elseif (typeof(value) ~= typeof(table2[name])) or (value ~= table2[name]) then
				diffList.Changes[name] = table2[name]
			end
		else
			table.insert(diffList.Deletions, name)
		end
	end

	for name, value in pairs(table2) do
		if table1[name] == nil then
			diffList.Additions[name] = value
		end
	end

	return diffList
end

function module:ShallowCompare(table1, table2)
	local changed = {}

	local avoid_loops = {}
	for i, v in pairs(table1) do
		if table2[i] ~= nil then
			if (typeof(v) == "table" and module:CompareTables(v, table2[i])) or (typeof(v) ~= typeof(table2[i])) or (v ~= table2[i]) then
				table.insert(changed, i)
			end
		else
			table.insert(changed, i)
		end
	end

	for i, v in pairs(table2) do
		if table1[i] == nil then
			table.insert(changed, i)
		end
	end

	return changed
end

function module:JSONCompare(table1, table2)
	local json1,json2 = HttpService:JSONEncode(table1), HttpService:JSONEncode(table2)

	return json1 == json2
end

function module:CombineTables(table1: table, table2: table): table
	local newTable = module:DeepCopy(table1)
	module:CopyTo(table2, newTable)

	return newTable
end

function module:CompareTables(table1, table2)
	local avoid_loops = {}
	local function recurse(t1, t2)
		-- compare value types
		if typeof(t1) ~= typeof(t2) then return false end
		-- Base case: compare simple values
		if type(t1) ~= "table" then return t1 == t2 end
		-- Now, on to tables.
		-- First, let's avoid looping forever.
		if avoid_loops[t1] then return avoid_loops[t1] == t2 end
		avoid_loops[t1] = t2
		-- Copy keys from t2
		local t2keys = {}
		local t2tablekeys = {}
		for k, _ in pairs(t2) do
			if type(k) == "table" then table.insert(t2tablekeys, k) end
			t2keys[k] = true
		end
		-- Let's iterate keys from t1
		for k1, v1 in pairs(t1) do
			local v2 = t2[k1]
			if type(k1) == "table" then
				-- if key is a table, we need to find an equivalent one.
				local ok = false
				for i, tk in ipairs(t2tablekeys) do
					if module:CompareTables(k1, tk) and recurse(v1, t2[tk]) then
						table.remove(t2tablekeys, i)
						t2keys[tk] = nil
						ok = true
						break
					end
				end
				if not ok then return false end
			else
				-- t1 has a key which t2 doesn't have, fail.
				if v2 == nil then return false end
				t2keys[k1] = nil
				if not recurse(v1, v2) then return false end
			end
		end
		-- if t2 has a key which t1 doesn't have, fail.
		if next(t2keys) then return false end
		return true
	end
	return recurse(table1, table2)
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------Create Function Begins---------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--[[
A "Create" function for easy creation of Roblox instances. The function accepts a string which is the classname of
the object to be created. The function then returns another function which either accepts accepts no arguments, in
which case it simply creates an object of the given type, or a table argument that may contain several types of data,
in which case it mutates the object in varying ways depending on the nature of the aggregate data. These are the
type of data and what operation each will perform:
1) A string key mapping to some value:
      Key-Value pairs in this form will be treated as properties of the object, and will be assigned in NO PARTICULAR
      ORDER. If the order in which properties is assigned matter, then they must be assigned somewhere else than the
      |Create| call's body.

2) An integral key mapping to another Instance:
      Normal numeric keys mapping to Instances will be treated as children if the object being created, and will be
      parented to it. This allows nice recursive calls to Create to create a whole hierarchy of objects without a
      need for temporary variables to store references to those objects.

3) A key which is a value returned from Create.Event( eventname ), and a value which is a function function
      The Create.E( string ) function provides a limited way to connect to signals inside of a Create hierarchy
      for those who really want such a functionality. The name of the event whose name is passed to
      Create.E( string )

4) A key which is the Create function itself, and a value which is a function
      The function will be run with the argument of the object itself after all other initialization of the object is
      done by create. This provides a way to do arbitrary things involving the object from withing the create
      hierarchy.
      Note: This function is called SYNCHRONOUSLY, that means that you should only so initialization in
      it, not stuff which requires waiting, as the Create call will block until it returns. While waiting in the
      constructor callback function is possible, it is probably not a good design choice.
      Note: Since the constructor function is called after all other initialization, a Create block cannot have two
      constructor functions, as it would not be possible to call both of them last, also, this would be unnecessary.


Some example usages:

A simple example which uses the Create function to create a model object and assign two of it's properties.
local model = Create'Model'{
    Name = 'A New model',
    Parent = game.Workspace,
}


An example where a larger hierarchy of object is made. After the call the hierarchy will look like this:
Model_Container
 |-ObjectValue
 |  |
 |  `-BoolValueChild
 `-IntValue

local model = Create'Model'{
    Name = 'Model_Container',
    Create'ObjectValue'{
        Create'BoolValue'{
            Name = 'BoolValueChild',
        },
    },
    Create'IntValue'{},
}


An example using the event syntax:

local part = Create'Part'{
    [Create.E'Touched'] = function(part)
        print("I was touched by "..part.Name)
    end,
}


An example using the general constructor syntax:

local model = Create'Part'{
    [Create] = function(this)
        print("Constructor running!")
        this.Name = GetGlobalFoosAndBars(this)
    end,
}


Note: It is also perfectly legal to save a reference to the function returned by a call Create, this will not cause
      any unexpected behavior. EG:
      local partCreatingFunction = Create'Part'
      local part = partCreatingFunction()
]]

--the Create function need to be created as a functor, not a function, in order to support the Create.E syntax, so it
--will be created in several steps rather than as a single function declaration.
local function Create_PrivImpl(objectType)
	if type(objectType) ~= 'string' then
		error("Argument of Create must be a string", 2)
	end
	--return the proxy function that gives us the nice Create'string'{data} syntax
	--The first function call is a function call using Lua's single-string-argument syntax
	--The second function call is using Lua's single-table-argument syntax
	--Both can be chained together for the nice effect.
	return function(dat)
		--default to nothing, to handle the no argument given case
		dat = dat or {}

		--make the object to mutate
		local obj = Instance.new(objectType)
		local parent = nil

		--stored constructor function to be called after other initialization
		local ctor = nil

		for k, v in pairs(dat) do
			--add property
			if type(k) == 'string' then
				if k == 'Parent' then
					-- Parent should always be set last, setting the Parent of a new object
					-- immediately makes performance worse for all subsequent property updates.
					parent = v
				else
					obj[k] = v
				end


			--add child
			elseif type(k) == 'number' then
				if type(v) ~= 'userdata' then
					error("Bad entry in Create body: Numeric keys must be paired with children, got a: "..type(v), 2)
				end
				v.Parent = obj


			--event connect
			elseif type(k) == 'table' and k.__eventname then
				if type(v) ~= 'function' then
					error("Bad entry in Create body: Key `[Create.E\'"..k.__eventname.."\']` must have a function value\
					       got: "..tostring(v), 2)
				end
				local ev: RBXScriptSignal = obj[k.__eventname]
				ev:Connect(v)


			--define constructor function
			elseif k == module.Create then
				if type(v) ~= 'function' then
					error("Bad entry in Create body: Key `[Create]` should be paired with a constructor function, \
					       got: "..tostring(v), 2)
				elseif ctor then
					--ctor already exists, only one allowed
					error("Bad entry in Create body: Only one constructor function is allowed", 2)
				end
				ctor = v


			else
				error("Bad entry ("..tostring(k).." => "..tostring(v)..") in Create body", 2)
			end
		end

		--apply constructor function if it exists
		if ctor then
			ctor(obj)
		end

		if parent then
			obj.Parent = parent
		end

		--return the completed object
		return obj
	end
end

--now, create the functor:
module.Create = setmetatable({}, {__call = function(tb, ...) return Create_PrivImpl(...) end})

--and create the "Event.E" syntax stub. Really it's just a stub to construct a table which our Create
--function can recognize as special.
module.Create.E = function(eventName)
	return {__eventname = eventName}
end

-------------------------------------------------Create function End----------------------------------------------------

return module

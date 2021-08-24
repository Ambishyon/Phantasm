local Libraries = script.Parent.Parent.Libraries
local Util

local GuiWhitelist = {
	DisplayOrder = true;
	IgnoreGuiInset = true;
	Enabled = true;
	ResetOnSpawn = true;
	ZIndexBehavior = true;
	AutoLocalize = true;
	RootLocalizationTable = true;
}

local Nilable = {
	Theme = true;
}

--- Custom navigator class to replicate actual instance behaviour
local class = {}

function class:GetChildren()
	local object = self
	local result = {}
	Util:CopyTo(object.Children or object.Elements, result)

	for i, v in pairs(result) do
		result[i] = v
	end

	return result
end

function class:FindFirstChild(name, recursive)
	local object = self

	local function search(parent)
		for _, element in pairs(parent.Children) do
			if element.Name == name then
				return element
			else
				if recursive then
					local res = search(element)
					if res then
						return res
					end
				end
			end
		end
	end

	return search(object)
end

function class:FindFirstChildOfClass(name, recursive)
	local object = self

	local function search(parent)
		for _, element in pairs(parent.Children) do
			if element.ClassName == name then
				return element
			else
				if recursive then
					local res = search(element)
					if res then
						return res
					end
				end
			end
		end
	end

	return search(object)
end

function class:FindFirstChildWhichIsA(name, recursive)
	local object = self

	local function search(parent)
		for _, element in pairs(parent.Children) do
			if element:IsA(name) then
				return element
			else
				if recursive then
					local res = search(element)
					if res then
						return res
					end
				end
			end
		end
	end

	return search(object)
end

function class:GetDescendants()
	local object = self

	local desc = {}

	local function index(what)
		for _, v in pairs(what.Children) do
			table.insert(desc, v)
			index(v)
		end
	end

	index(object)

	return desc
end

function class:FindFirstAncestor(name: string)
	local object = self

	repeat
		object = object.Parent
	until object ~= self and (object == nil or object.Name == name)

	return object
end

function class:FindFirstAncestorOfClass(name: string)
	local object = self

	repeat
		object = object.Parent
	until object ~= self and (object == nil or object.ClassName == name)

	return object
end

function class:FindFirstAncestorWhichIsA(name: string)
	local object = self

	repeat
		object = object.Parent
	until object ~= self and (object == nil or object:IsA(name))

	return object
end

function class:ClearAllChildren()
	local object = self

	for i, element in pairs(object.Children) do
		element:Destroy()
		object.Children[i] = nil
	end
end

return function(object)
	if Util == nil then
		Util = require(Libraries.Util)
	end

	object.__index = function(self, what)
		local Children, Properties, Component, Object, Name, Elements = (rawget(self, "Children") or rawget(self, "Elements")),
			rawget(self, "Properties"),
			rawget(self, "Component"),
			rawget(self, "Object"),
			rawget(self, "Name"),
			rawget(self, "Elements")

		-- Initial check to see if there is an artifical instance function
		local result = class[what]

		-- If it is something that can be nil, return it no matter what
		if Nilable[what] then
			return rawget(self, what)
		end

		-- Check to see if it is a private class function
		if result == nil and string.sub(what, 1, 2) == "__" then
			return rawget(self, what)
		end

		if result == nil then
			-- Check if there's a class specific function
			result = object[what]
		end

		if result == nil and Component then
			-- Check if there is a component function that can be fired
			if Component.Functions then
				if self.__Functions == nil then
					self.__Functions = {}
				end
				if self.__Functions[what] == nil then
					self.__Functions = function(...)
						return Component.Functions[what](self, ...)
					end
				end
				result = self.__Functions[what]
			end
		end

		if result == nil and Component and Component.Properties then
			local propExists = Component.Properties[what] ~= nil
			if propExists and Properties[what] == nil then
				return Properties[what]
			end
		end

		if result == nil and Object and not Component then
			-- It's an element so we directly grab the property from the actual instance
			result = Object[what]
		end

		if result == nil and Properties then
			result = Properties[what]

			if result ~= nil and Component then
				if typeof(result) == "function" then
					result = result(self, {}, what)
				elseif typeof(result) == "table" and result.Type == "Binding" then
					local binding = Util:GetBinding(self.Tree, result.Name)
					if binding then
						result = binding(self.Tree, {}, what)
					else
						error(string.format("[PHANTASM]: %s is not a valid binding for property '%s' of %s", result.Name, what, Name))
					end
				end
			end

			if result == nil and Object then
				result = Object[what]
				if Children[what] and Children[what].Object == result then
					result = nil
				end
			end
		end

		if result == nil then
			result = Children[what]
		end

		if Elements and result == nil then
			result = Elements[what]
		end

		assert(result ~= nil, string.format("%s is not a valid member of %s", what, Name))

		if type(result) == "table" and result.Type == "Ref" then
			local component = self:FindFirstAncestorWhichIsA("Component")
			if component then
				result = component:GetFromId(result.Id)
			else
				result = rawget(self, "Tree"):GetFromId(result.Id)
			end
		end

		return result
	end

	object.__newindex = function(self, what, to)
		if string.sub(what, 1, 2) == "__" then
			rawset(self, what, to)
		else
			local ClassName, Component, Properties = rawget(self, "ClassName"),
				rawget(self, "Component"),
				rawget(self, "Properties")

			if ClassName == "Component" then
				local propertyInfo = Component.Properties[what]
				if propertyInfo then
					assert(propertyInfo.Visible == true or propertyInfo.Visible == nil, string.format("%s is a readonly property", what))
				end
			end

			if ClassName == "Interface" then
				if GuiWhitelist[what] then
					self.Object[what] = to
				else
					Properties[what] = to
				end
			else
				Properties[what] = to
			end

			if what == "Name" then
				rawset(self, "Name", to)
			end
		end
	end
end

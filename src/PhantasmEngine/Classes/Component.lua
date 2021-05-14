local Libraries = script.Parent.Parent.Libraries
local Util
local Classes = script.Parent
local Maid = require(Classes.Maid)
local Navigator = require(Classes.Navigator)

local class = {}
Navigator(class)

function class.new(name: string, data: table, tree: table, parent: table|nil)
	if Util == nil then
		Util = require(Libraries.Util)
	end
	local self = {}

	self.Children = {}
	self.Tree = tree
	self.Parent = parent
	self.Context = {}

	if type(data) == "function" then
		self.Properties = {}
		self.Component = {
			Constructor = data;
		}
	else
		self.Properties = data.Properties
		self.Component = Util:GetComponent(tree, data.Component)
	end
	
	self.Name = name

	return setmetatable(self, class)
end

function class:Render()
	local component = self.Component
	-- Generate the tree and check for differences
	local constructor = component.Constructor

	if component.PreRender then
		component.PreRender(self.Properties, self.Context, self.Tree.Context)
	end

	local data = type(constructor) == "table" and constructor or constructor(self.Properties, self.Context, self.Tree.Context)

	local function traverseTree(tree, parent)
		for name, element in pairs(parent.Children) do
			if tree.Children[name] then
				local treeElement = tree.Children[name]
				for prop, val in pairs(treeElement.Properties) do
					element.Properties[prop] = val
				end
				traverseTree(treeElement, element)
			else
				element:Destroy()
				parent.Children[name] = nil
			end
		end

		for name, treeElement in pairs(tree.Children) do
			local element = parent.Children[name]
			if element == nil then
				element = Util:GenerateElements(self.Tree, {treeElement})
				for _, v in pairs(element) do
					element = v
					break
				end
				element.Object.Parent = parent.Object or parent.Parent
				parent.Children[name] = element
			end
		end
	end

	for name, element in pairs(self.Children) do
		if data.Children[name] then
			local treeElement = data.Children[name]
			for prop, val in pairs(treeElement.Properties) do
				element.Properties[prop] = val
			end
			traverseTree(treeElement, element)
		else
			element:Destroy()
			self.Children[name] = nil
		end
	end

	for name, treeElement in pairs(data.Children) do
		local tree = self.Children[name]
		if tree == nil then
			local element = Util:GenerateElements(self.Tree, {treeElement})
			for _, v in pairs(element) do
				element = v
				break
			end
			element.Object.Parent = self.Parent
			self.Children[name] = element
		end
	end

	-- Render all children
	for _, child in pairs(self.Children) do
		child:Render()
	end

	if component.PostRender then
		component.PostRender(self.Properties, self.Context, self.Tree.Context)
	end
end

function class:IsA(name)
	local firstObject
	for _, element in pairs(self.Children) do
		firstObject = element
		break
	end

	if name == "Component" then
		return true
	elseif firstObject and not firstObject.ClassName == "Component" then
		return firstObject.Object:IsA(name)
	end
end

function class:Destroy()
	for _, element in pairs(self.Children) do
		element:Destroy()
	end
end

return class
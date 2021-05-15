--[[
--File Name: Component.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:45:53 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util
local Classes = script.Parent
local Maid = require(Classes.Maid)
local Element = require(Classes.Element)
local Navigator = require(Classes.Navigator)
local AnimationSet = require(Classes.AnimationSet)

local class = {}
Navigator(class)

function class.new(name: string, data: table, tree: table, parent: table|nil)
	if Util == nil then
		Util = require(Libraries.Util)
	end
	local self = {}

	self.ClassName = "Component"
	self.Children = {}
	self.Tree = tree
	self.Parent = parent
	self.Context = {}
	self.__Animations = nil

	self.Elements = {}
	self.__Properties = {}

	if type(data) == "function" then
		self.Animations = {}
		self.Properties = {}
		self.Component = {
			Constructor = data;
		}
		self.Object = Element.new(name, {
			ClassName = "Frame";
			Properties = {
				BackgroundTransparency = 1;
				Size = UDim2.new(1,0,1,0);
				Position = UDim2.new();
			};
		}, tree, parent)
	else
		self.Animations = data.Animations or {}
		self.Properties = data.Properties
		self.Component = Util:GetComponent(tree, data.Component)
		self.Object = Element.new(name, {
			ClassName = "Frame";
			Properties = {
				BackgroundTransparency = 1;
				Size = self.Properties.Size or UDim2.new(1,0,1,0);
				Position = self.Properties.Position or UDim2.new();
			};
		}, tree, parent)
	end
	
	self.Name = name

	return setmetatable(self, class)
end

function class:PlayAnimation(name)
	local animData = self.Animations[name]
	assert(animData, string.format("Component '%s' does not have an animation with the name '%s'", self.Name, name))
	-- If the animation is already playing, stop and destroy it before replaying
	self:StopAnimation(name)
	-- Now we play the animation
	if animData then
		self.__Animations[name] = AnimationSet.new(self, animData)
		self.__Animations[name]:Play()
	end
end

function class:StopAnimation(name)
	assert(self.Animations[name], string.format("Component '%s' does not have an animation with the name '%s'", self.Name, name))
	if self.__Animations[name] then
		self.__Animations[name]:Destroy()
		self.__Animations[name] = nil
	end
end

function class:Render()
	local component = self.Component

	-- Check for differences in the component properties
	if not Util:ShallowCompare(self.__Properties, self.Properties) then
		self.Object.Size = self.Properties.Size
		self.Object.Position = self.Properties.Position
		self.__Properties = self.Properties
	end

	-- Generate the tree and check for differences
	local constructor = component.Constructor

	if component.PreRender then
		component.PreRender(self.Properties, self.Context, self.Tree.Context)
	end

	local data = type(constructor) == "table" and constructor or constructor(self.Properties, self.Context, self.Tree.Context)

	local function traverseTree(tree, parent)
		for name, element in pairs(parent.Children) do
			if tree.Children[name] then
				-- The element's properties has changed
				local treeElement = tree.Children[name]
				for prop, val in pairs(treeElement.Properties) do
					element.Properties[prop] = val
				end
				-- Has the element's class changed?
				if element.ClassName ~= treeElement.ClassName then
					-- It has changed, recreate the element
					Util:DebugPrint(string.format("Recreating element '%s' as class '%s' (previously '%s')", element.Name, treeElement.ClassName, element.ClassName))
					element:Destroy()
					element = Util:GenerateElement(name, self.Tree, treeElement, parent)
					parent.Children[name] = element
				else
					-- It hasn't changed, traverse its children
					if treeElement.Children then
						traverseTree(treeElement, element)
					end
				end
			else
				-- The element was destroyed
				element:Destroy()
				parent.Children[name] = nil
			end
		end

		for name, treeElement in pairs(tree.Children) do
			local element = parent.Children[name]
			if element == nil then
				-- The element is new, create it
				element = Util:GenerateElement(name, self.Tree, treeElement, parent)
				parent.Children[name] = element
			end
		end
	end

	for name, element in pairs(self.Elements) do
		if data[name] then
			-- The element's properties has changed
			local treeElement = data[name]
			for prop, val in pairs(treeElement.Properties) do
				element.Properties[prop] = val
			end
			-- The element's animations may have changed
			if treeElement.StateAnimations then
				for state, anim in pairs(treeElement.StateAnimations) do
					element.StateAnimations[state] = anim
				end
			else
				element.StateAnimations = {}
			end
			-- The element's sounds may have changed
			if treeElement.Sounds then
				for state, sound in pairs(treeElement.Sounds) do
					element.Sounds[state] = sound
				end
			else
				element.Sounds = {}
			end
			-- Has the element's class changed?
			if element.ClassName ~= treeElement.ClassName then
				-- It has changed, recreate the element
				Util:DebugPrint(string.format("Recreating element '%s' as class '%s' (previously '%s')", element.Name, treeElement.ClassName, element.ClassName))
				element:Destroy()
				element = Util:GenerateElement(name, self.Tree, treeElement, self)
				self.Elements[name] = element
			else
				-- It hasn't changed, traverse its children if possible
				if treeElement.Children then
					traverseTree(treeElement, element)
				end
			end
		else
			-- The element was destroyed
			element:Destroy()
			self.Elements[name] = nil
		end
	end

	for name, treeElement in pairs(data) do
		local tree = self.Elements[name]
		if tree == nil then
			-- The element is new, create it
			local element = Util:GenerateElement(name, self.Tree, treeElement, self)
			self.Elements[name] = element
		end
	end

	-- Render all children
	for _, child in pairs(self.Children) do
		child:Render()
	end

	-- Render all component elements
	for _, child in pairs(self.Elements) do
		child:Render()
	end

	if component.PostRender then
		component.PostRender(self.Properties, self.Context, self.Tree.Context)
	end
end

function class:IsA(name)
	if name == "Component" then
		return true
	end
end

function class:Destroy()
	for _, element in pairs(self.Children) do
		element:Destroy()
	end
end

return class
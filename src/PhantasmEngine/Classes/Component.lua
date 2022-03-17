local HttpService = game:GetService("HttpService")

local Libraries = script.Parent.Parent.Libraries
local Util
local Classes = script.Parent
local Element = require(Classes.Element)
local Navigator = require(Classes.Navigator)
local AnimationSet = require(Classes.AnimationSet)

local Phantasm = require(script.Parent.Parent)

local class = {}
Navigator(class)

function class.new(name: string, data: table, tree: table, parent: table|nil)
	if Util == nil then
		Util = require(Libraries.Util)
	end
	local self = {}

	self.ClassName = "Component"
	self.Id = type(data) == "table" and data.Id or HttpService:GenerateGUID(false)
	self.Children = {}
	self.Tree = tree
	self.Parent = parent
	self.Context = {}
	self.__Animations = {}

	self.Elements = {}
	self.__Properties = {}

	if type(data) == "function" then
		self.Animations = {}
		self.Properties = {}
		self.Component = {
			Constructor = data;
			Properties = {};
			Functions = {};
		}
		self.Object = Element.new(name, {
			ClassName = "Frame";
			Properties = {
				BackgroundTransparency = 1;
				Size = UDim2.new(1,0,1,0);
				Position = UDim2.new();
			};
		}, tree, parent)

		self.Visible = true
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

		for prop, val in pairs(self.Component.Properties) do
			if self.Properties[prop] == nil then
				self.Properties[prop] = val.Default
			else
				if typeof(self.Properties[prop]) == "table" and typeof(val.Default) == "table" then
					self.Properties[prop] = Util:CombineTables(val.Default, self.Properties[prop])
				end
			end
		end

		self.Visible = (data.Visible ~= nil and data.Visible) or (data.Visible == nil and true)
	end

	self.Name = name

	setmetatable(self, class)

	if self.Component.Init then
		self.Component.Init(self, self.Context, self.Tree.Context)
	end

	return self
end

function class:GetFromId(id)
	for _, v in pairs(self:GetDescendants()) do
		if v.Id == id then
			return v
		end
	end
end

function class:GetElements()
	local desc = {}

	local function index(what)
		for _, v in pairs(what.Children) do
			table.insert(desc, v)
			index(v)
		end
	end

	for _, element in pairs(self.Elements) do
		table.insert(desc, element)
		index(element)
	end

	return desc
end

function class:GetAnimationState()
	
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
	debug.profilebegin("Component Render")
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
		component.PreRender(self, self.Context, self.Tree.Context)
	end

	local data = type(constructor) == "table" and constructor or constructor(self, self.Context, self.Tree.Context)

	local function traverseTree(tree, parent)
		for name, element in pairs(parent.Children) do
			if tree.Children[name] then
				-- Has the element's properties changed?
				local originalProperties = element.Data.Properties or {}
				local treeElement = tree.Children[name]
				if element.State ~= "Normal" then
					if treeElement.StateAnimations and treeElement.StateAnimations[element.State] and treeElement.StateAnimations[element.State].Goal then
						for prop, _ in pairs(treeElement.StateAnimations[element.State].Goal) do
							treeElement.Properties[prop] = element.Properties[prop]
						end
					end
				end
				if not Util:CompareTables(originalProperties, treeElement.Properties) then
					-- It has changed, update the element
					local diff = Util:GenerateDifferences(originalProperties, treeElement.Properties)
					for prop, val in pairs(Util:CombineTables(diff.Additions, diff.Changes)) do
						-- Skip an event property if there is already a function generated for it
						-- as we can be certain it is just the same function as before.
						if type(element.Properties[prop]) == "function" then
							continue
						end
						Util:DebugPrint(string.format("Property '%s' of component element '%s' changed to '%s'", tostring(prop), name, tostring(val)))
						element.Properties[prop] = val
					end
					element.Data.Properties = treeElement.Properties
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
			if element.State ~= "Normal" then
				if treeElement.StateAnimations and treeElement.StateAnimations[element.State] and treeElement.StateAnimations[element.State].Goal then
					for prop, _ in pairs(treeElement.StateAnimations[element.State].Goal) do
						treeElement.Properties[prop] = element.Properties[prop]
					end
				end
			end
			for prop, val in pairs(treeElement.Properties) do
				-- Skip an event property if there is already a function generated for it
				-- as we can be certain it is just the same function as before.
				if type(element.Properties[prop]) == "function" then
					continue
				end
				element.Properties[prop] = val
			end
			-- The element's animations may have changed
			if treeElement.StateAnimations then
				for state, anim in pairs(treeElement.StateAnimations) do
					if state == "Normal" then
						-- Normal state requires special behavior due to how it functions
						for i, v in pairs(anim) do
							if i ~= "Goal" then
								element.StateAnimations[state][i] = v
							end
						end
					else
						element.StateAnimations[state] = anim
					end
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

	-- Update container visiblity
	self.Object.Visible = self.Visible

	-- Render container
	self.Object:Render()

	-- Render all children
	for _, child in pairs(self.Children) do
		child:Render()
	end

	-- Render all component elements
	for _, child in pairs(self.Elements) do
		child:Render()
	end

	if component.PostRender then
		component.PostRender(self, self.Context, self.Tree.Context)
	end
	debug.profileend()
end

function class:IsA(name)
	return name == "Component"
end

function class:Destroy()
	if self.Component.Cleanup then
		self.Component.Cleanup(self, self.Context, self.Tree.Context)
	end
	for _, v in pairs(self.__Animations) do
		v:Destroy()
	end
	self.__Animations = {}
	self.Object:Destroy()
	for _, element in pairs(self.Children) do
		element:Destroy()
	end
	for _, element in pairs(self.Elements) do
		element:Destroy()
	end
end

return class
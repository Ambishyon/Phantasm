local Players = game:GetService("Players")

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)
local Classes = script.Parent
local Maid = require(Classes.Maid)
local Navigator = require(Classes.Navigator)
local AnimationSet = require(Classes.AnimationSet)

local player = Players.LocalPlayer
local class = {}
Navigator(class)

local engineProperties = {
	Functions = true;
	Bindings = true;
	Elements = true;
	Components = true;
	Animations = true;
	Theme = true;
	Init = true;
	Cleanup = true;
}

local engineDefaults = {
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
}

-- MountedInterfaces
function class.new(data: table, parent: Instance?)
	local self = {}

	self.Data = data
	self.Maid = Maid.new()
	self.Name = "Interface"
	self.Parent = nil
	self.ClassName = "Interface"

	self.Components = data.Components or {}
	self.Functions = data.Functions or {}
	self.Bindings = data.Bindings or {}
	self.Animations = data.Animations or {}
	self.Theme = data.Theme or {}

	self.__Animations = {}

	self.Context = {}

	self.Object = parent or Instance.new("ScreenGui", player.PlayerGui)
	self.__HadParent = parent ~= nil

	self.OverlayGUI = Instance.new("Frame")
	self.OverlayGUI.BackgroundTransparency = 1
	self.OverlayGUI.Size = UDim2.fromScale(1,1)
	self.OverlayGUI.ZIndex = 999999
	self.OverlayGUI.Name = "Phantasm Overlay"
	self.OverlayGUI.Parent = self.Object

	self.Elements = Util:GenerateElements(self, data.Elements)

	if parent == nil then
		for prop, val in pairs(engineDefaults) do
			if data[prop] ~= nil then continue end
			self.Object[prop] = val
		end

		for prop, val in pairs(data) do
			if engineProperties[prop] then continue end
			self.Object[prop] = val
		end
	end
	setmetatable(self, class)

	if data.Init then
		data.Init(self, self.Context)
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

function class:GetAnimationState()
	
end

function class:PlayAnimation(name: string)
	local animData = self.Animations[name]
	assert(animData, string.format("[PHANTASM]: Interface '%s' does not have an animation with the name '%s'", self.Name, name))
	-- If the animation is already playing, stop and destroy it before replaying
	self:StopAnimation(name)
	-- Now we play the animation
	if animData then
		self.__Animations[name] = AnimationSet.new(self, animData)
		self.__Animations[name]:Play()
	end
end

function class:StopAnimation(name: string)
	assert(self.Animations[name], string.format("[PHANTASM]: Interface '%s' does not have an animation with the name '%s'", self.Name, name))
	if self.__Animations[name] then
		self.__Animations[name]:Destroy()
		self.__Animations[name] = nil
	end
end

function class:IsA(name: string)
	return name == self.ClassName
end

function class:Render()
	for _, element in pairs(self.Elements) do
		element:Render()
	end
end

function class:Destroy()
	if self.Data.Cleanup then
		self.Data.Cleanup(self, self.Context)
	end

	for _, v in pairs(self.__Animations) do
		v:Destroy()
	end
	rawset(self, "__Animations", nil)
	self.Maid:Destroy()
	for _, v in pairs(self.Elements) do
		v:Destroy()
	end
	rawset(self, "Data", nil)
	rawset(self, "Tree", nil)
	if not rawget(self, "__HadParent") then
		self.Object:Destroy()
	else
		self.OverlayGUI:Destroy()
	end
end

return class

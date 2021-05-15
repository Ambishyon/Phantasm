--[[
--File Name: Interface.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:40:36 pm
--Modified By: TheGrimDeathZombie
--]]

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

	self.__Animations = nil

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

	return setmetatable(self, class)
end

function class:PlayAnimation(name)
	local animData = self.Animations[name]
	assert(animData, string.format("Interface '%s' does not have an animation with the name '%s'", self.Name, name))
	-- If the animation is already playing, stop and destroy it before replaying
	self:StopAnimation(name)
	-- Now we play the animation
	if animData then
		self.__Animations[name] = AnimationSet.new(self, animData)
		self.__Animations[name]:Play()
	end
end

function class:StopAnimation(name)
	assert(self.Animations[name], string.format("Interface '%s' does not have an animation with the name '%s'", self.Name, name))
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
	self.Maid:Destroy()
	self.Data = nil
	self.Tree = nil
	if not self.__HadParent then
		self.Object:Destroy()
	else
		self.OverlayGUI:Destroy()
	end
end

return class
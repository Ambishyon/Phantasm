--[[
--File Name: Animator.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:49:48 pm
--Modified By: TheGrimDeathZombie
--]]

local RunService = game:GetService("RunService")

local Libraries = script.Parent.Parent.Libraries
local BoatTween = require(Libraries.BoatTween)
local Util

--- Responsible for animating elements, components and interfaces using BoatTween
local class = {}
class.__index = class

function class.new(element, animationData)
	if Util == nil then
		Util = require(Libraries.Util)
	end
	local self = setmetatable({}, class)

	self.Playing = false
	self.__Tweens = {}
	self.__InitialValues = {}
	self.__Target = element
	self.__AnimationData = animationData

	self.__Completed = Instance.new("BindableEvent")
	self.Completed = self.__Completed.Event

	self.Properties = {}
	self.StackData = {
		Animator = self;
		Properties = self.Properties;
	}

	return self
end

function class:ResetValues()
	assert(self.__Tweens, "This animator has already been destroyed")
	for prop, val in pairs(self.__InitialValues) do
		self.Properties[prop] = val
	end
end

function class:Play()
	assert(self.__Tweens, "This animator has already been destroyed")
	if self.Playing then
		self:Stop()
		RunService.Heartbeat:Wait()
	end

	local properties = rawget(self.__Target, "Properties")
	for prop, val in pairs(properties) do
		if Util:IsTweenable(val) then
			Util:DebugPrint(string.format("Setting up default property '%s' for animation for element '%s' with value '%s'", prop, self.__Target.Name, tostring(val)))
			self.Properties[prop] = val
		end
	end

	self.__Tweens = {}

	for prop, values in pairs(self.__AnimationData) do
		self.__InitialValues[prop] = values.InitialValue
		local lastTime = 0
		for _, keyframe in pairs(values.Frames) do
			local propTable = {
				[prop] = keyframe.Value;
			}
			local tween = BoatTween:Create(self.Properties, {
				Goal = propTable;
				Time = keyframe.Time - lastTime;
				EasingStyle = keyframe.EasingStyle;
				EasingDirection = keyframe.EasingDirection;
				DelayTime = 0;
				RepeatCount = 0;
				Reverses = false;
				StepType = "RenderStepped";
			})
			table.insert(self.__Tweens, {
				Tween = tween;
				DelayTime = lastTime;
			})
			lastTime = keyframe.Time
		end
	end

	self.Playing = true

	local delayedTweens = {}
	for _, props in pairs(self.__Tweens) do
		local tween = props.Tween
		local delayTime = props.DelayTime
		if delayTime == 0 then
			tween:Play()
		else
			table.insert(delayedTweens, {
				Tween = tween;
				DelayTime = delayTime;
				Playing = false;
			})
		end
	end

	local heartbeatConnection
	local start = os.clock()
	local tweensDone = false
	heartbeatConnection = RunService.Heartbeat:Connect(function()
		local now = os.clock() - start
		if not self.Playing then
			heartbeatConnection:Disconnect()
			return
		end
		if tweensDone then
			local allDone = true
			for _, props in pairs(self.__Tweens) do
				local tween = props.Tween
				if tween.PlaybackState == Enum.PlaybackState.Playing then
					allDone = false
				end
			end
			if allDone then
				self.__Completed:Fire()
				self.Playing = false
				heartbeatConnection:Disconnect()
				return
			end
		else
			local allPlaying = true
			for _, props in pairs(delayedTweens) do
				if not props.Playing then
					if now > props.DelayTime then
						props.Playing = true
						props.Tween:Play()
					else
						allPlaying = false
					end
				end
			end
			tweensDone = allPlaying
		end
	end)
end

function class:Stop()
	assert(self.__Tweens, "This animator has already been destroyed")
	self.Playing = false
	for _, props in pairs(self.__Tweens) do
		props.Tween:Stop()
	end
end

function class:Destroy()
	for _, props in pairs(self.__Tweens) do
		props.Tween:Destroy()
	end
	self.__Tweens = nil
end

return class
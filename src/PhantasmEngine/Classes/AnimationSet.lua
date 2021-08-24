local Classes = script.Parent
local Animator = require(Classes.Animator)

--- Custom class for handling animating the properties of several objects at once
local class = {}
class.__index = class

local function indexPath(object, path)
	local current = object
	local route = string.split(path, ".")

	for _, to in pairs(route) do
		current = current[to]
	end

	return current
end

function class.new(object, animData)
	local self = setmetatable({}, class)

	self.Animators = {}
	for path, data in pairs(animData) do
		local actualObject = indexPath(object, path)
		self.Animators[actualObject] = Animator.new(actualObject, data)
	end

	return self
end

function class:Play()
	assert(self.Animators, "This AnimationSet has already been destroyed")
	for object, animator in pairs(self.Animators) do
		object.AnimationStack:AddToStack(animator.StackData)
	end
end

function class:Stop()
	assert(self.Animators, "This AnimationSet has already been destroyed")
	for _, animator in pairs(self.Animators) do
		animator:Stop()
	end
end

function class:Destroy()
	assert(self.Animators, "This AnimationSet has already been destroyed")
	for _, animator in pairs(self.Animators) do
		animator:Destroy()
	end
	self.Animators = nil
end

return class

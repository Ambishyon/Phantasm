--- A class for handling multiple animations being played at once
local class = {}
class.__index = class

function class.new(element)
	local self = setmetatable({}, class)

	self.__Stack = {}
	self.__Element = element

	return self
end

function class:AddToStack(data: table, index: number?)
	if index then
		table.insert(self.__Stack, index, data)
	else
		table.insert(self.__Stack, data)
	end
	data.Animator:Play()
end

function class:Update()
	local mergedResults = {}

	for _, animData in pairs(self.__Stack) do
		local isPlaying do
			if animData.Animator.PlaybackState then
				isPlaying = animData.Animator.PlaybackState == Enum.PlaybackState.Playing or animData.Animator.PlaybackState == Enum.PlaybackState.Delayed
			else
				isPlaying = animData.Animator.Playing
			end
		end

		if isPlaying then
			-- Done in a way so that whatever is last in the stack (highest) is what gets used
			for prop, val in pairs(animData.Properties) do
				mergedResults[prop] = val
			end
		else
			-- Apply its final values to the stack before removing
			for prop, val in pairs(animData.Properties) do
				mergedResults[prop] = val
			end
			-- Remove it from the stack as it is no longer playing
			table.remove(self.__Stack, table.find(self.__Stack, animData))
		end
	end

	-- Apply the combined results of all the playing animations in the stack
	for prop, val in pairs(mergedResults) do
		rawget(self.__Element, "Properties")[prop] = val
	end
end

return class

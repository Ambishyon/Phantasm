local Players = game:GetService("Players")

local player = Players.LocalPlayer
local class = {}
class.__index = class

-- MountedInterfaces
function class.new(data)
	local self = setmetatable({}, class)

	self.Data = data
	self.Tree = nil
	
	self.GUI = Instance.new("ScreenGui", player.PlayerGui)

	return self
end

return class
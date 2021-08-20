local class = {}
class.__index = class

function class.new(name, contextMenu)
	assert(contextMenu ~= nil, "[PHANTASM]: Invalid argument #2 to MenuButton.new (ContextMenu cannot be nil)")
	assert(contextMenu:IsA("ContextMenu"), "[PHANTASM]: Invalid argument #2 to MenuButton.new (expected a ContextMenu)")
	local self = setmetatable({}, class)

	self.Name = name
	self.ContextMenu = contextMenu
	self.Enabled = true
	self.MenuOpen = false

	self.__Clicked = Instance.new("BindableEvent")
	self.Clicked = self.__Clicked.Event

	return self
end

return class
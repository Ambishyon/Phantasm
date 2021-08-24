local class = {}
class.__index = class

function class.new(title, contextMenu)
	local self = setmetatable({}, class)

	self.Title = title
	self.ContextMenu = contextMenu

	return self
end

function class:IsA(what)
	return what == "ContextSubmenu"
end

return class
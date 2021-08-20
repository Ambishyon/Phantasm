local class = {}
class.__index = class

function class.new(name: string, icon: string, alignment: Enum.HorizontalAlignment, subTools: table)
	local self = setmetatable({}, class)

	self.Name = name
	self.Icon = icon
	self.Alignment = alignment
	self.SubTools = subTools or {}
	self.Enabled = true
	self.Active = false
	self.MenuOpen = false

	self.__ToolbarClicked = Instance.new("BindableEvent")
	self.ToolbarClicked = self.__ToolbarClicked.Event

	return self
end

function class:IsA(what)
	return what == "Tool"
end

return class
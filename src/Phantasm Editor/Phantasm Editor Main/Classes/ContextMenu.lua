local Classes = script.Parent
local ContextButton = require(Classes.ContextButton)
local ContextSubmenu = require(Classes.ContextSubmenu)
local ContextSeparator = require(Classes.ContextSeparator)

local class = {}
class.__index = class

function class.new()
	local self = setmetatable({}, class)

	self.__Items = {}

	return self
end

function class:GetItems()
	return self.__Items
end

function class:AddButton(title, subtitle, icon)
	local btn = ContextButton.new(title, subtitle, icon)
	table.insert(self.__Items, btn)
	return btn
end

function class:AddSubmenu(title, contextMenu)
	local submenu = ContextSubmenu.new(title, contextMenu)
	table.insert(self.__Items, submenu)
	return submenu
end

function class:AddSeparator()
	local separator = ContextSeparator.new()
	table.insert(self.__Items, separator)
end

function class:IsA(what)
	return what == "ContextMenu"
end

return class
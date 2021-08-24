local Classes = script.Parent.Parent.Classes
local MenuButton = require(Classes.MenuButton)

local module = {}

local buttons = {}

function module:AddMenuButton(name, contextMenu)
	local btn = MenuButton.new(name, contextMenu)
	table.insert(buttons, btn)
	return btn
end

function module:GetMenuButtons()
	return buttons
end

return module
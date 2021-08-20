local Classes = script.Parent.Parent.Classes
local Tool = require(Classes.Tool)

local module = {}

local buttons = {}

function module:AddTool(name, icon, alignment, subTools)
	local btn = Tool.new(name, icon, alignment, subTools)
	table.insert(buttons, btn)

	btn.ToolbarClicked:Connect(function()
		for _, button in pairs(buttons) do
			button.Active = button == btn
		end
	end)

	return btn
end

function module:GetTools()
	return buttons
end

return module
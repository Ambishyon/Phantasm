local Providers = script.Parent.Parent.Providers
local ToolbarTools = require(Providers.ToolbarTools)
local Classes = script.Parent.Parent.Classes
local Tool = require(Classes.Tool)

local module = {}

local SelectTool = ToolbarTools:AddTool("Select", "rbxassetid://7286810843", Enum.HorizontalAlignment.Left)
local RectangleTool = ToolbarTools:AddTool("Rectangle", "rbxassetid://7286811234", Enum.HorizontalAlignment.Left)
local TextTool = ToolbarTools:AddTool("Text", "rbxassetid://7286810399", Enum.HorizontalAlignment.Left)
local HandTool = ToolbarTools:AddTool("Hand", "rbxassetid://7286811610", Enum.HorizontalAlignment.Left)

SelectTool.Active = true

return module
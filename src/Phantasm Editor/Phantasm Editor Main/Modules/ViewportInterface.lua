local CoreGui = game:GetService("CoreGui")

local module = {}

local PhantasmEngine = require(script.Parent.Parent.PhantasmEngine)

local GUI = Instance.new("ScreenGui")
GUI.IgnoreGuiInset = true
GUI.Enabled = false
GUI.Parent = CoreGui

local Interface = require(script.Parent.Parent.Interfaces.Viewport)
local Viewport = PhantasmEngine.mountInterface(Interface, GUI)

GUI:GetPropertyChangedSignal("Enabled"):Connect(function()
	workspace.CurrentCamera.CameraType = GUI.Enabled and Enum.CameraType.Scriptable or Enum.CameraType.Fixed
end)

function module.init(plugin: Plugin)
	local Toolbar = plugin:CreateToolbar("Phantasm UI")
	local EditorButton = Toolbar:CreateButton("Phantasm_Editor", "Open or close the editor for Phantasm", "rbxassetid://7288265850", "Editor")
	local SettingsButton = Toolbar:CreateButton("Phantasm_Settings", "Open the settings for Phantasm", "rbxassetid://7288266967", "Settings")

	module.Toolbar = Toolbar
	module.EditorButton = EditorButton
	module.SettingsButton = SettingsButton

	EditorButton.Click:Connect(function()
		GUI.Enabled = not GUI.Enabled
		EditorButton:SetActive(GUI.Enabled)
	end)

	plugin.Unloading:Connect(function()
		PhantasmEngine.demountInterface(Viewport)
		GUI:Destroy()
	end)
end

return module
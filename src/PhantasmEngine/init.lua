-- Check if another module has already loaded Phantasm before, if so, return
-- that instead to prevent multiple from running at once.
if _G.Phantasm then
	return _G.Phantasm
end

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Libraries = script.Libraries
local Classes = script.Classes
local Interface = require(Classes.Interface)
local Util = require(Libraries.Util)
local Interpreter = require(Libraries.Interpeter)
local Globals = require(script.Globals)

local PHANTASMFOLDER = ReplicatedStorage:WaitForChild("Phantasm", 5) or Util.Create("Folder") {
	Parent = ReplicatedStorage;
	Name = "Phantasm";
	Util.Create("Folder") {
		Name = "Components";
	};
	Util.Create("Folder") {
		Name = "Functions";
	};
	Util.Create("Folder") {
		Name = "Bindables";
	};
}

if RunService:IsStudio() and RunService:IsRunning() == false then
	-- If the code is running in studio and isn't running in a live game, we can assume it is running
	-- in a plugin context we make sure not to make any unwanted mess for the users of the plugin
	PHANTASMFOLDER.Parent = script
end

local module = {}

local MountedInterfaces = {}

function module.mountInterface(data: table | ModuleScript, parent)
	if typeof(data) == "Instance" then
		data = Interpreter.fromObject(data)
	end
	local newInterface = Interface.new(data, parent)

	table.insert(MountedInterfaces, newInterface)

	return newInterface
end

function module.demountInterface(interface: table)
	local index = table.find(MountedInterfaces, interface)

	if index then
		interface:Destroy()
		table.remove(MountedInterfaces, index)
	end
end

RunService.RenderStepped:Connect(function(dt)
	for _, interface in pairs(MountedInterfaces) do
		interface:Render()
	end
end)

_G.Phantasm = module

print("----------------------------------------------------------------")
print(string.format("This game is running Phantasm V%s by TheGrimDeathZombie/Reapimus", Globals.VERSION))
if Util:InDebugMode() then
	print("Debug Mode is active")
end
print("Phantasm Engine has successfully loaded")
print("----------------------------------------------------------------")

return module
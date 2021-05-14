local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Libraries = script.Libraries
local Classes = script.Classes
local Element = require(Classes.Element)
local Interface = require(Classes.Interface)
local Maid = require(Classes.Maid)
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

RunService.RenderStepped:Connect(function(dt)
	for _, interface in pairs(MountedInterfaces) do
		interface:Render()
	end
end)

print("----------------------------------------------------------------")
print(string.format("This game is running Phantasm V%s by TheGrimDeathZombie/Reapimus", Globals.VERSION))
if Util:InDebugMode() then
	print("Debug Mode is active")
end
print("Phantasm Engine has successfully loaded")
print("----------------------------------------------------------------")

return module
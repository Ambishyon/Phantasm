-- Check if another module has already loaded Phantasm before, if so, return
-- that instead to prevent multiple from running at once.
if _G.Phantasm then
	return _G.Phantasm
end

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Libraries = script.Libraries
local Classes = script.Classes
local API = script.API
local Interface = require(Classes.Interface)
local Util = require(Libraries.Util)
local Interpreter = require(Libraries.Interpeter)
local Globals = require(script.Globals)
local Changed, Event, Ref = require(API:FindFirstChild("Changed")), require(API.Event), require(API.Ref)

local module = {}
local MountedInterfaces = {}

module.Changed = Changed
module.Event = Event
module.Ref = Ref

module.__debuggerPauseState = false
function module.setDebuggerPauseState(state: boolean)
	module.__debuggerPauseState = state
end

function module.getDebuggerPauseState(): boolean
	return module.__debuggerPauseState
end

function module.getMountedInterfaces()
	local res = {}
	for _, interface in pairs(MountedInterfaces) do
		table.insert(res, interface)
	end
	return res
end

function module.createElement(className: string, properties: table?, children: table?): table
	return {
		ClassName = className;
		Properties = properties or {};
		Children = children or {};
	}
end

function module.createPortal(target: Instance, className: string, properties: table?, children: table?): table
	return {
		ClassName = className;
		Portal = target;
		Properties = properties or {};
		Children = children or {};
	}
end

function module.createRef(element: any): table
	return {
		Type = "Ref";
		Id = type(element) == "table" and element.Id or element;
	}
end

function module.createFragment(elements: table): table
	return {
		ClassName = "Fragment";
		Children = elements;
	}
end

function module.createComponent(className: string, properties: table?, children: table?): table
	return {
		ClassName = "Component";
		Component = className;
		Properties = properties or {};
		Children = children or {};
	}
end

function module.createBinding(name: string, properties: table): table
	return {
		Type = "Binding";
		Name = name;
		Properties = properties;
	}
end

function module.createFunction(name: string, properties: table): table
	return {
		Type = "Function";
		Name = name;
		Properties = properties;
	}
end

function module.mountInterface(data: table | ModuleScript, parent: Instance?)
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
		table.remove(MountedInterfaces, index)
		interface:Destroy()
	end
end

RunService.RenderStepped:Connect(function(dt)
	if module.__debuggerPauseState then return end
	for _, interface in pairs(MountedInterfaces) do
		interface:Render()
	end
end)

_G.Phantasm = module

if RunService:IsClient() and not RunService:IsStudio() then
	print("----------------------------------------------------------------")
	print(string.format("This game is running Phantasm V%s by Ambishyon", Globals.VERSION))
	if Util:InDebugMode() then
		print("Debug Mode is active")
	end
	print("Phantasm Engine has successfully loaded")
	print("----------------------------------------------------------------")
end

return module
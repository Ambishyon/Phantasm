local HttpService = game:GetService("HttpService")

local Libraries = script.Parent.Parent.Libraries
local Util
local Classes = script.Parent
local Navigator = require(Classes.Navigator)

local Phantasm = require(script.Parent.Parent)

local class = {}
Navigator(class)

function class.new(name: string, data: table, tree: table, parent: table|nil)
	if Util == nil then
		Util = require(Libraries.Util)
	end
	local self = {}

	self.ClassName = "Fragment"
	self.Name = name
	self.Id = data.Id or HttpService:GenerateGUID(false)
	self.Children = Util:GenerateElements(self, data.Children, parent)
	self.Tree = tree
	self.Parent = parent

	return setmetatable(self, class)
end

function class:IsA(what)
	return what == "Fragment"
end

function class:Destroy()
	for _, element in pairs(self.Children) do
		element:Destroy()
	end
end

return class
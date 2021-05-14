local Players = game:GetService("Players")

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)
local Classes = script.Parent
local Maid = require(Classes.Maid)
local Navigator = require(Classes.Navigator)

local player = Players.LocalPlayer
local class = {}
Navigator(class)

-- MountedInterfaces
function class.new(data: table, parent: Instance?)
	local self = {}

	self.Data = data
	self.Maid = Maid.new()
	self.Name = "Interface"
	self.Parent = nil

	self.Components = data.Components
	self.Functions = data.Functions
	self.Bindings = data.Bindings
	self.Animations = data.Animations

	self.Context = {}
	
	self.GUI = parent or Instance.new("ScreenGui", player.PlayerGui)
	self.__HadParent = parent ~= nil

	self.OverlayGUI = Instance.new("Frame")
	self.OverlayGUI.BackgroundTransparency = 1
	self.OverlayGUI.Size = UDim2.fromScale(1,1)
	self.OverlayGUI.ZIndex = 999999
	self.OverlayGUI.Name = "Phantasm Overlay"
	self.OverlayGUI.Parent = self.GUI

	self.Elements = Util:GenerateElements(self, data.Elements)

	return setmetatable(self, class)
end

function class:Render()
	for _, element in pairs(self.Elements) do
		element:Render()
	end
end

function class:Destroy()
	self.Maid:Destroy()
	self.Data = nil
	self.Tree = nil
	if not self.__HadParent then
		self.GUI:Destroy()
	else
		self.OverlayGUI:Destroy()
	end
end

return class
local NUMBERPATTERN = "(%d+)(%w*)" -- returns number, unit

local Libraries = script.Parent.Parent.Libraries
local ObjectCache = require(Libraries.ObjectCache)
local Classes = script.Parent
local Maid = require(Classes.Maid)

local caches = {}

local camera = workspace.CurrentCamera
local units = {
	-- Normal
	["cm"] = function(value)
		return value * 38
	end;
	["mm"] = function(value)
		return value * 4
	end;
	["in"] = function(value)
		return value * 96
	end;
	["px"] = function(value)
		return value
	end;
	["pt"] = function(value)
		return math.floor(value * 1.33333333)
	end;
	["pc"] = function(value)
		return math.floor(value * 16)
	end;
	["vw"] = function(value)
		return (camera.ViewportSize.X*.01)*value
	end;
	["vh"] = function(value)
		return (camera.ViewportSize.Y*.01)*value
	end;
	["vmin"] = function(value)
		return (getViewportDimension(true)*.01)*value
	end;
	["vmax"] = function(value)
		return (getViewportDimension(false)*.01)*value
	end;
	["s"] = function(value)
		return value
	end;
	["mins"] = function(value)
		return value * 60
	end;
	-- Element-Based
	["em"] = function(value, element)
		return value * element.TextSize
	end;
	["rem"] = function(value, element)
		return value * 14
	end;
	["%"] = function(value, element)
		local parentElement = element:FindFirstAncestorWhichIsA("GuiBase2d")
		return (value/100) * (parentElement and parentElement.AbsoluteSize.X or 0)
	end;
}

function getViewportDimension(bigger)
	return bigger and (camera.ViewportSize.X > camera.ViewportSize.Y and camera.ViewportSize.X) or (camera.ViewportSize.X < camera.ViewportSize.Y and camera.ViewportSize.X) or camera.ViewportSize.Y
end

function interpretNumber(value: string, element: Instance): number
	local result = 0

	for _, v in pairs(string.split(value, ",")) do
		local num, unit = string.match(v, NUMBERPATTERN)
		if num and unit then
			local converter = units[unit]
			if converter then
				result += converter(tonumber(num), element)
			else
				result += tonumber(num)
			end
		elseif tonumber(value) then
			result += tonumber(value)
		end
	end

	return result
end

local class = {}
class.__index = class

function class.new(name, data)
	local self = setmetatable({}, class)

	if caches[data.ClassName] == nil then
		caches[data.ClassName] = ObjectCache.new(Instance.new(data.ClassName), 100)
	end

	self.ClassName = data.ClassName
	self.Properties = data.Properties
	self.Data = data
	self.Children = {}

	self.Object = caches[self.ClassName]:GetObject()
	self.Maid = Maid.new()

	self.Object.Name = name
	self.Name = name

	return self
end

function class:Render()
	local mainGUI = self.Object:FindFirstAncestorOfClass("ScreenGui")

	local parentSize do
		local parent = self.Object:FindFirstAncestorWhichIsA("GuiObject") or self.Object:FindFirstAncestorWhichIsA("ScreenGui")
		if parent then
			parentSize = parent.AbsoluteSize
		else
			parentSize = Vector2.new()
		end
	end

	if self.Object:IsA"GuiObject" and self.Properties.Size then
		if typeof(self.Properties.Size) == "UDim2" then
			self.Object.Size = self.Properties.Size
		else
			local x, y = interpretNumber(self.Properties.Size.X, self.Object), interpretNumber(self.Properties.Size.Y, self.Object)
			self.Object.Size = UDim2.fromOffset(x, y)
		end
	end

	if self.Object:IsA"GuiObject" and self.Properties.Position then
		if typeof(self.Properties.Position) == "UDim2" then
			self.Object.Position = self.Properties.Position
		else
			local x, y = interpretNumber(self.Properties.Position.X, self.Object), interpretNumber(self.Properties.Position.Y, self.Object)
			self.Object.Position = UDim2.fromOffset(x, y)
		end
	end
end

function class:Destroy()
	self.Maid:DoCleaning()
	caches[self.ClassName]:ReturnObject(self.Object)
	self.Object = nil
end

return class
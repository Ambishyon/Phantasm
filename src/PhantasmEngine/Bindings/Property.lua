--[[
--File Name: Property.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:13 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Property = {
			Type = "string";
			Default = "";
		};
	};
	ReturnType = "string";
	Category = "Common";
	Description = "Gets a component specific property";
	Run = function(element, arguments)
		local component = element:FindFirstAncestorOfClass("Component")
		if component then
			return component[arguments.Property]
		end
	end;
}
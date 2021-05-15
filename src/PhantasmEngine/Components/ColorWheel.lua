--[[
--File Name: ColorWheel.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:47:57 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Disabled = {
			Type = "boolean";
			Default = false;
		};
		Color = {
			Type = "Color3";
			Default = Color3.new(1,1,1);
		};
	};
	
	Icon = "";
	Category = "Common";
	Description = "A component that allows the user to select a color";

	PreRender = function(properties, context, interfacecontext)
		if properties.Color == nil then
			properties.Color = Color3.new(1, 1, 1)
		end
	end;

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
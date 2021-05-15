--[[
--File Name: RadioButtons.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:48:33 pm
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
		Options = {
			Type = "Array";
			ArrayType = "string";
			Default = {
				"Yes";
				"No";
			};
		};
		Chosen = {
			Type = "string";
			Default = "";
		};
	};
	
	Icon = "";
	Category = "Common";
	Description = "A component that allows the user to pick from an array of specified options";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
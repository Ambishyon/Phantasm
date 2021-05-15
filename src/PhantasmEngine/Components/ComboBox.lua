--[[
--File Name: ComboBox.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:48:41 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
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
			Default = "Yes";
		};
		Disabled = {
			Type = "boolean";
			Default = false;
		};
	};
	
	Icon = "";
	Category = "Common";
	Description = "A component that allows the player to choose an option from a list of choices upon clicking";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
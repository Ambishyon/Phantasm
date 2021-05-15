--[[
--File Name: GameTime.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:48:40 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Lighting = game:GetService("Lighting")

return {
	Properties = {

	};
	ReturnType = "string";
	Category = "Time";
	Description = "Returns the current in-game time";
	Run = function(element, arguments)
		return Lighting.TimeOfDay
	end;
}
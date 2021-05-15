--[[
--File Name: PhysicsFPS.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:03 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "number";
	Category = "Game";
	Description = "Gets the current physics FPS";
	Run = function(element, arguments)
		return workspace:GetRealPhysicsFPS()
	end;
}
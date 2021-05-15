--[[
--File Name: TeamColor.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:20 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		
	};
	ReturnType = "Color3";
	Category = "Player";
	Description = "Gets the players team color";
	Run = function(element, arguments)
		return Player.TeamColor
	end;
}
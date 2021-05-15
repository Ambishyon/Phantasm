--[[
--File Name: TeamName.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:24 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		
	};
	ReturnType = "string";
	Category = "Player";
	Description = "Gets the players team name";
	Run = function(element, arguments)
		return Player.Team and Player.Team.Name or ""
	end;
}
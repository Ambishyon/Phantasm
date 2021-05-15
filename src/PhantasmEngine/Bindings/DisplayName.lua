--[[
--File Name: DisplayName.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:48:16 pm
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
	Description = "Gets the players display name";
	Run = function(element, arguments)
		return Player.DisplayName
	end;
}
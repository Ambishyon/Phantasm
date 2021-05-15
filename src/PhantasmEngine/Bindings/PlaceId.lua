--[[
--File Name: PlaceId.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:05 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "number";
	Category = "Game";
	Description = "Gets the placeid of the server";
	Run = function(element, arguments)
		return game.PlaceId
	end;
}
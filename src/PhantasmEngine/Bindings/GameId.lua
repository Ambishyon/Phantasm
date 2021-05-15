--[[
--File Name: GameId.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:48:30 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "number";
	Category = "Game";
	Description = "Gets the id of the game";
	Run = function(element, arguments)
		return game.GameId
	end;
}
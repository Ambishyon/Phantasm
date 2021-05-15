--[[
--File Name: CreatorType.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:48:06 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "string";
	Category = "Game";
	Description = "Gets whether or not the game's creator is a group or a player";
	Run = function(element, arguments)
		return game.CreatorType.Name
	end;
}
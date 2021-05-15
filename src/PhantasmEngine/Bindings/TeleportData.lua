--[[
--File Name: TeleportData.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:43 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local TeleportService = game:GetService("TeleportService")
local TeleportData = TeleportService:GetLocalPlayerTeleportData() or {}

return {
	Properties = {
		Name = {
			Type = "string";
			Default = "";
		};
	};
	ReturnType = "Variant";
	Category = "Player";
	Description = "Gets the value of something within the players teleport data";
	Run = function(element, arguments)
		return TeleportData[arguments.Name]
	end;
}
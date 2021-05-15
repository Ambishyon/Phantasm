--[[
--File Name: PlayerThumbnail.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:10 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		Size = {
			Type = "number";
			Default = 150;
		};
		Type = {
			Type = "Dropdown";
			Default = "AvatarHeadShot";
			Options = {
				"AvatarHeadShot";
				"Avatar";
			};
		};
	};
	ReturnType = "string";
	Category = "Player";
	Description = "Gets the players avatar thumbnail";
	Run = function(element, arguments)
		return string.format("rbxthumb://type=%s&id=%s&w=%w&h=%s", arguments.Type, Player.UserId, tostring(arguments.Size), tostring(arguments.Size))
	end;
}
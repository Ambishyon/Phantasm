--[[
--File Name: Health.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:48:47 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		FormatString = {
			Type = "string";
			Default = "%h/%m";
		}
	};
	ReturnType = "string";
	Category = "Player";
	Description = "Gets the players health and/or max health";
	Run = function(element, arguments, propertyName)
		local human do
			if Player.Character and Player.Character:FindFirstChild("Humanoid") then
				human = Player.Character.Humanoid
			else
				human = {
					Health = 0;
					MaxHealth = 100;
				}
			end
		end

		if propertyName == "Progress" then
			return (human.Health/human.MaxHealth)
		end

		local formats = {
			["%h"] = math.floor(human.Health);
			["%m"] = math.floor(human.MaxHealth);
			["%H"] = (human.Health/human.MaxHealth)*100
		}

		local result = arguments.FormatString

		for i, v in pairs(formats) do
			result = string.gsub(result, i, tostring(v))
		end

		return result
	end;
}
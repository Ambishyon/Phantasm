--[[
--File Name: Translate.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:49:46 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer
local LocalizationService = game:GetService("LocalizationService")
local Translator: Translator do
	local success, result = pcall(function()
		return LocalizationService:GetTranslatorForPlayerAsync(Player)
	end)

	if success then
		Translator = result
	else
		Translator = LocalizationService:GetTranslatorForPlayer(Player)
	end
end

return {
	Properties = {
		Text = {
			Type = "string";
			Default = "";
		}
	};
	ReturnType = "string";
	Category = "Localization";
	Description = "Gets the specified translated string";
	Run = function(element, arguments)
		return Translator:Translate(element.Object, arguments.Text)
	end;
}
--[[
--File Name: GetCore.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:48:43 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local StarterGui = game:GetService("StarterGui")

return {
	Properties = {
		Name = {
			Type = "string";
			Default = "";
		};
	};
	ReturnType = "Variant";
	Category = "CoreScripts";
	Description = "Gets the result of the GetCore function";
	Run = function(element, arguments)
		return StarterGui:GetCore(arguments.Name)
	end;
}
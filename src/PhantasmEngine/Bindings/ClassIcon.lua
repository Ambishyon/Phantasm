--[[
--File Name: ClassIcon.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:47:50 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local StudioService = game:GetService("StudioService")

return {
	Properties = {
		ClassName = {
			Type = "string";
			Default = "Instance"
		}
	};
	ReturnType = "string|Vector2";
	Category = "Plugin";
	Description = "Gets the class icon information for the specified class (returns differently based on the property it is bound to)";
	Run = function(element, arguments, propertyName)
		local icon = StudioService:GetClassIcon(arguments.ClassName)
		if propertyName == "ImageRectOffset" then
			return icon.ImageRectOffset
		elseif propertyName == "ImageRectSize" then
			return icon.ImageRectSize
		else
			return icon.Image
		end
	end;
}
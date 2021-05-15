--[[
--File Name: Slider.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:48:45 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Value = {
			Type = "number";
			Default = 0;
		};
		Steps = {
			Type = "number";
			Default = 0;
		};
		Range = {
			Type = "NumberRange";
			Default = NumberRange.new(0, 1);
		};
		BarAppearance = {
			Type = "Dictionary";
			Default = {
				Image = "";
				ImageColor3 = Color3.new(1,1,1);
				ImageSize = Vector2.new();
				Thickness = UDim2.new(0,8);
			};
		};
		SliderAppearance = {
			Type = "Dictionary";
			Default = {
				Image = "";
				ImageColor3 = Color3.new(1,1,1);
				Size = UDim2.new(0,10,.7,0);
			};
		};
		Disabled = {
			Type = "boolean";
			Default = false;
		};
	};
	
	Icon = "";
	Category = "Common";
	Description = "A component that displays a slider that the user can utilize to choose a number";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
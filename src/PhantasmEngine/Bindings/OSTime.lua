--[[
--File Name: OSTime.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 5:48:52 pm
--Modified By: TheGrimDeathZombie
--]]

local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "number";
	Category = "Time";
	Description = "Gets the current os time in seconds";
	Run = function(element, arguments)
		return os.time()
	end;
}
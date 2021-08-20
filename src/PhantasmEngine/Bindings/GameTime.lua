local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Lighting = game:GetService("Lighting")

return {
	Properties = {

	};
	ReturnType = "string";
	Category = "Time";
	Description = "Returns the current in-game time";
	Run = function(element, arguments)
		return Lighting.TimeOfDay
	end;
}
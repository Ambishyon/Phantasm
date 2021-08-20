local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "number";
	Category = "Game";
	Description = "Gets the current physics FPS";
	Run = function(element, arguments)
		return workspace:GetRealPhysicsFPS()
	end;
}
local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		
	};
	ReturnType = "Color3";
	Category = "Player";
	Description = "Gets the players team color";
	Run = function(element, arguments)
		return Player.TeamColor
	end;
}
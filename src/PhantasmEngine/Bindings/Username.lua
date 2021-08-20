local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		
	};
	ReturnType = "string";
	Category = "Player";
	Description = "Gets the players username";
	Run = function(element, arguments)
		return Player.Name
	end;
}
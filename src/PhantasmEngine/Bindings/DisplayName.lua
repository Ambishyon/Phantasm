local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {

	};
	ReturnType = "string";
	Category = "Player";
	Description = "Gets the players display name";
	Run = function(element, arguments)
		return Player.DisplayName
	end;
}
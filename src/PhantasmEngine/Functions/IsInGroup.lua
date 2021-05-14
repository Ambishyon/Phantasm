local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		GroupId = {
			Type = "number";
			Default = 0;
		}
	};
	Category = "Player";
	Description = "Gets whether or not the player is in the specified group";
	Run = function(element, arguments, ...)
		return Player:IsInGroup(arguments.GroupId)
	end
}
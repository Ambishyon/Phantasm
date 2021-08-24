local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		UserId = {
			Type = "number";
			Default = 0;
		};
	};
	Category = "Player";
	Description = "Gets whether or not the player is friends with another player";
	Run = function(element, arguments, ...)
		return Player:IsFriendsWith(arguments.UserId)
	end
}
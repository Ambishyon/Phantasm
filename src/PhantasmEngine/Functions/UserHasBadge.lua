local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local BadgeService = game:GetService("BadgeService")
local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		BadgeId = {
			Type = "number";
			Default = 0;
		};
	};
	Category = "Badges";
	Description = "Gets whether or not the player has the specified badge";
	Run = function(element, arguments, ...)
		return BadgeService:UserHasBadgeAsync(Player.UserId, arguments.BadgeId)
	end
}
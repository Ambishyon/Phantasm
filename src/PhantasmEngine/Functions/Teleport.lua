local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local TeleportService = game:GetService("TeleportService")

return {
	Properties = {
		PlaceId = {
			Type = "number";
			Default = 0;
		};
	};
	Category = "Teleport";
	Description = "Teleports the player to the specified placeid";
	Run = function(element, arguments, ...)
		TeleportService:Teleport(arguments.PlaceId)
	end
}
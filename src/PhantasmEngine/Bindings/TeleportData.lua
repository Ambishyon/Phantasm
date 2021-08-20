local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local TeleportService = game:GetService("TeleportService")
local TeleportData = TeleportService:GetLocalPlayerTeleportData() or {}

return {
	Properties = {
		Name = {
			Type = "string";
			Default = "";
		};
	};
	ReturnType = "Variant";
	Category = "Player";
	Description = "Gets the value of something within the players teleport data";
	Run = function(element, arguments)
		return TeleportData[arguments.Name]
	end;
}
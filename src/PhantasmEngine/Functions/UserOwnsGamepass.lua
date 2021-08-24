local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local MarketplaceService = game:GetService("MarketplaceService")
local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		GamepassId = {
			Type = "number";
			Default = 0;
		};
	};
	Category = "Marketplace";
	Description = "Checks whether or not the player owns the specified gamepass";
	Run = function(element, arguments, ...)
		return MarketplaceService:UserOwnsGamePassAsync(Player.UserId, arguments.GamepassId)
	end
}
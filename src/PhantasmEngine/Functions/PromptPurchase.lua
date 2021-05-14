local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local MarketplaceService = game:GetService("MarketplaceService")
local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		AssetId = {
			Type = "number";
			Default = 0;
		};
	};
	Category = "Marketplace";
	Description = "Prompts the purchase of an asset with the given id";
	Run = function(element, arguments, ...)
		MarketplaceService:PromptPurchase(Player, arguments.AssetId)
	end
}
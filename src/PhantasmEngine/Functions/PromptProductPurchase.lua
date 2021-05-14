local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local MarketplaceService = game:GetService("MarketplaceService")
local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		ProductId = {
			Type = "number";
			Default = 0;
		};
	};
	Category = "Marketplace";
	Description = "Prompts the purchase of a developer product";
	Run = function(element, arguments, ...)
		MarketplaceService:PromptProductPurchase(Player, arguments.ProductId)
	end
}
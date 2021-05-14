local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local MarketplaceService = game:GetService("MarketplaceService")
local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		
	};
	Category = "Marketplace";
	Description = "Prompts the purchase of premium";
	Run = function(element, arguments, ...)
		MarketplaceService:PromptPremiumPurchase(Player)
	end
}
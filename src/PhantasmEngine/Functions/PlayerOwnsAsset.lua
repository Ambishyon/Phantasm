local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local MarketplaceService = game:GetService("MarketplaceService")
local Player = game:GetService("Players").LocalPlayer

local Cache = {}

return {
	Properties = {
		AssetId = {
			Type = "number";
			Default = 0;
		};
	};
	Category = "Marketplace";
	Description = "Gets whether or not the player owns the specified asset";
	Run = function(element, arguments, ...)
		local id = arguments.AssetId
		if Cache[id] then
			return Cache[id]
		else
			local success, result = pcall(function()
				return MarketplaceService:PlayerOwnsAsset(Player, id)
			end)
			if success then
				Cache[id] = result
				return result
			else
				return false
			end
		end
	end
}
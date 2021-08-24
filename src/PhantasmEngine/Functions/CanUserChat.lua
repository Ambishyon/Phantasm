local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Chat = game:GetService("Chat")
local Player = game:GetService("Players").LocalPlayer

return {
	Properties = {
		
	};
	Category = "Chat";
	Description = "Gets whether or not the player can chat";
	Run = function(element, arguments, ...)
		return Chat:CanUserChatAsync(Player.UserId)
	end
}
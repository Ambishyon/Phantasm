local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		
	};
	Category = "Game";
	Description = "Gets whether or not this is a reserved server";
	Run = function(element, arguments, ...)
		return game.PrivateServerOwnerId == 0 and game.PrivateServerId ~= ""
	end
}
local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "number";
	Category = "Game";
	Description = "Gets the placeid of the server";
	Run = function(element, arguments)
		return game.PlaceId
	end;
}
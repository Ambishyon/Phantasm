local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {

	};
	ReturnType = "string";
	Category = "Game";
	Description = "Gets whether or not the game's creator is a group or a player";
	Run = function(element, arguments)
		return game.CreatorType.Name
	end;
}
local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")

local Name do
	if game.CreatorType == Enum.CreatorType.Group then
		Name = GroupService:GetGroupInfoAsync(game.CreatorId).Name
	else
		Name = Players:GetNameFromUserIdAsync(game.CreatorId)
	end
end

return {
	Properties = {

	};
	ReturnType = "string";
	Category = "Game";
	Description = "Gets the name of the game's creator";
	Run = function(element, arguments)
		return Name
	end;
}
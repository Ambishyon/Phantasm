local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Studio = settings().Studio

return {
	Properties = {
		Color = {
			Type = "StudioStyleGuideColor";
			Default = Enum.StudioStyleGuideColor.MainBackground;
		};
		Modifier = {
			Type = "StudioStyleGuideModifier";
			Default = Enum.StudioStyleGuideModifier.Default;
		};
	};
	ReturnType = "Color3";
	Category = "Plugin";
	Description = "Gets the studio theme color specified";
	Run = function(element, arguments)
		return Studio.Theme:GetColor(arguments.Color, arguments.Modifier)
	end;
}
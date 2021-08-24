local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local StarterGui = game:GetService("StarterGui")

return {
	Properties = {
		CoreGuiType = {
			Type = "Enum";
			EnumType = Enum.CoreGuiType;
			Default = Enum.CoreGuiType.All;
		};
	};
	Category = "CoreScripts";
	Description = "Gets the enabled state of a Roblox CoreGUI";
	Run = function(element, arguments, ...)
		return StarterGui:GetCoreGuiEnabled(arguments.CoreGuiType)
	end
}
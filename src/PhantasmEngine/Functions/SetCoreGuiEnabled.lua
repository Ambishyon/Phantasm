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
		Enabled = {
			Type = "boolean";
			Default = true;
		};
	};
	Category = "CoreScripts";
	Description = "Sets the enabled state of a Roblox CoreGUI";
	Run = function(element, arguments, ...)
		StarterGui:SetCoreGuiEnabled(arguments.CoreGuiType, arguments.Enabled)
	end
}
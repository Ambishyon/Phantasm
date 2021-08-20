local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local StarterGui = game:GetService("StarterGui")

return {
	Properties = {
		Name = {
			Type = "string";
			Default = "";
		};
	};
	ReturnType = "Variant";
	Category = "CoreScripts";
	Description = "Gets the result of the GetCore function";
	Run = function(element, arguments)
		return StarterGui:GetCore(arguments.Name)
	end;
}
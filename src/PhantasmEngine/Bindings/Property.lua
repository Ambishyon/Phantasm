local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Property = {
			Type = "string";
			Default = "";
		};
	};
	ReturnType = "string";
	Category = "Common";
	Description = "Gets a component specific property";
	Run = function(element, arguments)
		local component = element:FindFirstAncestorOfClass("Component")
		if component then
			return component[arguments.Property]
		end
	end;
}
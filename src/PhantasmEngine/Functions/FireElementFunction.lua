local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Element = {
			Type = "Element";
			Default = nil;
		};
		Name = {
			Type = "ElementFunction";
			Default = "";
		};
		Arguments = {
			Type = "array";
			Default = {};
		};
	};
	Category = "Common";
	Description = "Fires the specified function of the element that has been specified";
	Run = function(element, arguments)
		local func = Util:GetElementFromPath(element:FindFirstAncestorOfClass("Component") or element:FindFirstAncestorOfClass("Interface"), arguments.Element) [arguments.Name]
		if func then
			func(unpack(arguments.Arguments))
		else
			warn(string.format("FireElementFunction requires a valid function, '%s' is not a valid function", arguments.Name))
		end
	end;
}
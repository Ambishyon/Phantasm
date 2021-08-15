local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Element = {
			Type = "Element";
			Default = nil;
		};
	};
	Category = "Common";
	Description = "Fires the specified function of the element that has been specified";
	Run = function(element, arguments)
		local target = Util:GetElementFromPath(element:FindFirstAncestorOfClass("Component") or element:FindFirstAncestorOfClass("Interface"), arguments.Element)
		target.Visible = not target.Visible
	end;
}
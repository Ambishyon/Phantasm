local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Progress = {
			Type = "number";
			Range = NumberRange.new(0,1);
			Default = .5;
		};
		Appearance = {
			Type = "Dictionary";
			Default = {
				Image = "";
				ImageColor3 = Color3.new(1,1,1);
				ImageSize = Vector2.new();
			};
		};
	};
	
	Icon = "";
	Category = "Common";
	Description = "A component that shows the user the progress of a task or how much of something is left";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Disabled = {
			Type = "boolean";
			Default = false;
		};
		Options = {
			Type = "Array";
			ArrayType = "string";
			Default = {
				"Yes";
				"No";
			};
		};
		Chosen = {
			Type = "string";
			Default = "";
		};
	};

	InitialSize = UDim2.fromOffset(100,25);
	Icon = "";
	Category = "Common";
	Description = "A component that allows the user to pick from an array of specified options";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
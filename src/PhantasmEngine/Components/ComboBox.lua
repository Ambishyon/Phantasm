local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
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
			Default = "Yes";
		};
		Disabled = {
			Type = "boolean";
			Default = false;
		};
	};
	
	Icon = "";
	Category = "Common";
	Description = "A component that allows the player to choose an option from a list of choices upon clicking";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
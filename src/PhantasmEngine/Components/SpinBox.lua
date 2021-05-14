local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Value = {
			Type = "number";
			Default = 0;
		};
		UseRange = {
			Type = "boolean";
			Default = true;
		};
		Range = {
			Type = "NumberRange";
			Default = NumberRange.new(0, 40);
		};
		Disabled = {
			Type = "boolean";
			Default = false;
		};
	};
	
	Icon = "";
	Category = "Common";
	Description = "A numerical entry box that allows for direct entry of the number or allows the user to click and slide the number";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
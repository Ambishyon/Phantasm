local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Value = {
			Type = "boolean";
			Default = false;
		};
		Disabled = {
			Type = "boolean";
			Default = false;
		};
		Appearance = {
			Type = "Dictionary";
			Default = {
				Image = "";
				ImageColor3 = Color3.new(1,1,1);
				ImageRectSize = Rect.new();
				ScaleType = Enum.ScaleType.Stretch;
				Size = UDim2.new(1,0,1,0);
			};
		};
		TickAppearance = {
			Type = "Dictionary";
			Default = {
				Image = "";
				ImageColor3 = Color3.new(1,1,1);
				ImageRectSize = Rect.new();
				ScaleType = Enum.ScaleType.Stretch;
				Size = UDim2.new(0.9,0,.9,0);
			};
		};
		DisabledAppearance = {
			Type = "Dictionary";
			Default = {
				Image = "";
				ImageColor3 = Color3.new(1,1,1);
				ImageRectSize = Rect.new();
				ScaleType = Enum.ScaleType.Stretch;
				Size = UDim2.new(0,10,.7,0);
			};
		};
	};

	Icon = "";
	Category = "Common";
	Description = "A component that allows the user to turn something on or off";

	Constructor = function(properties, context, interfaceContext)
		
	end;
}
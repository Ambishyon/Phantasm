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
			};
		};
		BarAppearance = {
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
		return {
			Background = {
				ClassName = "ImageLabel";
				Properties = {
					BackgroundTransparency = properties.Appearance.BackgroundTransparency or 1;
					BackgroundColor3 = properties.Appearance.BackgroundColor3 or Color3.new(.8,.8,.8);
					BorderSizePixel = properties.Appearance.BorderSizePixel or 2;
					BorderColor3 = properties.Appearance.BorderColor3 or Color3.new(0,0,0);
					Image = properties.Appearance.Image;
					ImageColor3 = properties.Appearance.ImageColor3;
					Size = UDim2.fromScale(1,1);
				};
				Children = {
					Bar = {
						ClassName = "ImageLabel";
						Properties = {
							BackgroundTransparency = properties.BarAppearance.BackgroundTransparency or 1;
							BackgroundColor3 = properties.BarAppearance.BackgroundColor3 or Color3.new(1,1,1);
							BorderSizePixel = properties.Appearance.BorderSizePixel or 0;
							BorderColor3 = properties.Appearance.BorderColor3 or Color3.new(0,0,0);
							Image = properties.BarAppearance.Image;
							ImageColor3 = properties.BarAppearance.ImageColor3;
							Size = UDim2.fromScale(properties.Value, 1);
							ImageRectSize = Vector2.new(properties.BarAppearance.ImageSize.X * properties.Value, properties.BarAppearance.ImageSize.Y);
						};
					};
				};
			}
		}
	end;
}
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
			Type = "Appearance";
			ClassName = "ImageLabel";
			Default = {
				Image = "";
				BackgroundColor3 = Color3.fromRGB(39, 39, 39);
				BorderColor3 = Color3.fromRGB(27, 27, 27);
			};
		};
		BarAppearance = {
			Type = "Appearance";
			ClassName = "ImageLabel";
			Default = {
				Image = "";
				BackgroundColor3 = Color3.fromRGB(65, 65, 65);
				BorderSizePixel = 0;
			};
		};
	};

	InitialSize = UDim2.fromOffset(100,15);
	Icon = "";
	Category = "Common";
	Description = "A component that shows the user the progress of a task or how much of something is left";

	Constructor = function(properties, context, interfaceContext)
		return {
			Background = {
				ClassName = "ImageLabel";
				Properties = Util:CombineTables(properties.Appearance, {
					Size = UDim2.fromScale(1,1);
				});
				Children = {
					Bar = {
						ClassName = "ImageLabel";
						Properties = Util:CombineTables(properties.BarAppearance, {
							Size = UDim2.fromScale(1,1);
						});
						Children = {
							Gradient = {
								ClassName = "UIGradient";
								Properties = {
									Transparency = NumberSequence.new({
										NumberSequenceKeypoint.new(0, 0);
										NumberSequenceKeypoint.new(.001, 1);
										NumberSequenceKeypoint.new(1,1);
									});
									Offset = Vector2.new(properties.Progress, 0);
								};
							}
						};
					};
				};
			}
		}
	end;
}

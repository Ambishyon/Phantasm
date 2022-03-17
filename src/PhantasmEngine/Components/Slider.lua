local UserInputService = game:GetService("UserInputService")

local Phantasm = require(script.Parent.Parent)
local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Value = {
			Type = "number";
			Default = 0;
		};
		Interval = {
			Type = "number";
			Default = 0;
		};

		BarThickness = {
			Type = "UDim";
			Default = UDim.new(.15,0);
		};

		BarAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "rbxassetid://6999567596";
				ImageColor3 = Color3.fromRGB(49, 49, 49);
				BackgroundTransparency = 1;
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(3, 3, 147, 147);
			};
		};

		BarDisabledAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				ImageColor3 = Color3.fromRGB(26, 26, 26);
			};
		};

		SliderAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "rbxassetid://6999567596";
				ImageColor3 = Color3.fromRGB(16, 172, 211);
				BackgroundTransparency = 1;
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(3, 3, 147, 147);
				Size = UDim2.new(.05, 0, .95, 0);
			};
		};
		SliderHoverAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				ImageColor3 = Color3.fromRGB(65, 191, 223);
			};
		};
		SliderPressedAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				ImageColor3 = Color3.fromRGB(27, 148, 179);
			};
		};
		SliderDisabledAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				ImageColor3 = Color3.fromRGB(25, 93, 110);
			};
		};

		Disabled = {
			Type = "boolean";
			Default = false;
		};
	};

	Icon = "";
	Category = "Common";
	Description = "A component that displays a slider that the user can utilize to choose a number";

	Init = function(self, context, interfaceContext)
		self.Maid:GiveTask(UserInputService.InputEnded:Connect(function(inputObject, gameProcessed)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				context.MouseDown = false
			end
		end))
	end;

	PreRender = function(self, context, interfaceContext)
		if self.Disabled then return end
		if context.MouseDown then
			local input = self.Input

			local absolutePosition, absoluteSize = input.AbsolutePosition, input.AbsoluteSize
			local mousePos = UserInputService:GetMouseLocation()

			local result = math.clamp(mousePos.X - absolutePosition.X, 0, absoluteSize.X)/absoluteSize.X

			self.Value = (self.Interval > 0 and math.floor((result / self.Interval) + .5) * self.Interval) or result
		end
	end;

	Constructor = function(self, context, interfaceContext)
		return {
			Input = {
				ClassName = "TextButton";
				Properties = {
					BackgroundTransparency = 1;
					Size = UDim2.fromScale(1,1);
					Text = "";

					[Phantasm.Event.MouseButton1Down] = function()
						context.MouseDown = true
					end;

					[Phantasm.Event.MouseButton1Up] = function()
						context.MouseDown = false
					end;
					ZIndex = 100;
				};
				Children = {
					Bar = {
						ClassName = "ImageLabel";
						Properties = Util:CombineTables(Util:CombineTables(self.BarAppearance, self.Disabled and self.BarDisabledAppearance or {}), {
							Size = UDim2.new(UDim.new(1,0), self.BarThickness);
							Position = UDim2.fromScale(0,.5);
							AnchorPoint = Vector2.new(0,.5);
						});
					};
					Slider = {
						ClassName = "ImageLabel";
						Properties = Util:CombineTables(Util:CombineTables(self.SliderAppearance, self.Disabled and self.SliderDisabledAppearance or {}), {
							Position = UDim2.fromScale(self.Value, .5);
							AnchorPoint = Vector2.new(.5,.5);
							ZIndex = 2;
						});
						StateAnimations = self.Disabled and {
							Normal = {
								Time = .001;
							};
						} or {
							Normal = {
								Time = .001;
							};
							Hover = {
								Time = .001;
								Goal = self.SliderHoverAppearance;
							};
							Pressed = {
								Time = .001;
								Goal = self.SliderPressedAppearance;
							};
						};
					}
				};
			};
		}
	end;
}
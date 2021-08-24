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
		Value = {
			Type = "string";
			Default = nil;
		};

		Padding = {
			Type = "UDim";
			Default = UDim.new(0, 5);
		};

		Appearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				Image = "rbxassetid://6939333450";
				ImageColor3 = Color3.fromRGB(39, 39, 39);
				BackgroundTransparency = 1;
				Size = UDim2.new(.3, 0, 0, 15);
			};
		};
		HoverAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				ImageColor3 = Color3.fromRGB(65, 65, 65);
			};
		};
		PressedAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				ImageColor3 = Color3.fromRGB(17, 17, 17);
			};
		};
		DisabledAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				ImageColor3 = Color3.fromRGB(20, 20, 20);
			};
		};

		SelectedAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "rbxassetid://6939333994";
				ImageColor3 = Color3.fromRGB(11, 129, 184);
				BackgroundTransparency = 1;
				Size = UDim2.new(.9, 0, .9, 0);
			};
		};

		Font = {
			Type = "Dictionary";
			Default = {
				Font = Enum.Font.SourceSans;
				TextSize = 14;
				TextColor3 = Color3.new(1,1,1);
				TextScaled = false;
				TextWrapped = true;
				TextTransparency = 0;
				TextStrokeTransparency = 1;
				TextStrokeColor3 = Color3.new(0,0,0);
				TextTruncate = Enum.TextTruncate.AtEnd;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Center;
				RichText = false;
				LineHeight = 1;
			};
		};
	};

	InitialSize = UDim2.fromOffset(160,60);
	Icon = "";
	Category = "Common";
	Description = "A component that allows the user to pick from an array of specified options";

	PreRender = function(self, context, interfaceContext)
		if not table.find(self.Options, self.Value) then
			self.Value = self.Options[1]
		end
	end;

	Constructor = function(self, context, interfaceContext)
		local children = {
			ListLayout = {
				ClassName = "UIListLayout";
				Properties = {
					Padding = self.Padding;
				};
			};
		}

		for i, option in pairs(self.Options) do
			table.insert(children, {
				ClassName = "Frame";
				Properties = {
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, self.Appearance.Size.Y.Scale, self.Appearance.Size.Y.Offset);
					LayoutOrder = i;
				};
				Children = {
					Layout = {
						ClassName = "UIListLayout";
						Properties = {
							FillDirection = Enum.FillDirection.Horizontal;
							VerticalAlignment = Enum.VerticalAlignment.Center;
							Padding = UDim.new(0, 4);
						};
					};
					Input = {
						ClassName = "ImageButton";
						Properties = Util:CombineTables(Util:CombineTables(self.Appearance, self.Disabled and self.DisabledAppearance or {}), {
							Position = UDim2.new(0, 0, 0, 0);
							AnchorPoint = Vector2.new(0, .5);
							LayoutOrder = 0;
							Activated = function()
								if self.Disabled then return end
								self.Value = option
							end;
						});
						Children = {
							IsSelected = {
								ClassName = "ImageLabel";
								Properties = Util:CombineTables(self.SelectedAppearance, {
									Position = UDim2.fromScale(.5, .5);
									AnchorPoint = Vector2.new(.5, .5);
									Visible = self.Value == option;
								});
							};
							AspectRatio = {
								ClassName = "UIAspectRatioConstraint";
								Properties = {};
							};
						};
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
								Goal = self.HoverAppearance;
							};
							Pressed = {
								Time = .001;
								Goal = self.PressedAppearance;
							};
						};
					};
					Label = {
						ClassName = "TextLabel";
						Properties = Util:CombineTables(self.Font, {
							BackgroundTransparency = 1;
							LayoutOrder = 1;
							Text = option;
							AutomaticSize = Enum.AutomaticSize.X;
							Size = UDim2.fromScale(.6, 1);
						});
					};
				};
			})
		end

		return children
	end;
}
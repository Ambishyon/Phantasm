local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

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
			Default = nil;
		};
		Disabled = {
			Type = "boolean";
			Default = false;
		};

		Appearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				Image = "";
				AutoButtonColor = false;
				BackgroundColor3 = Color3.fromRGB(39, 39, 39);
				BorderColor3 = Color3.fromRGB(27, 27, 27);
			};
		};
		HoverAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				Image = "";
				BackgroundColor3 = Color3.fromRGB(65, 65, 65);
			};
		};
		PressedAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				Image = "";
				BackgroundColor3 = Color3.fromRGB(17, 17, 17);
			};
		};

		ButtonAppearance = {
			Type = "Properties";
			ClassName = "TextButton";
			Default = {
				BackgroundColor3 = Color3.fromRGB(255,255,255);
				BackgroundTransparency = 1;
			};
		};

		ButtonHoverAppearance = {
			Type = "Properties";
			ClassName = "TextButton";
			Default = {
				BackgroundTransparency = .8;
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

		ArrowDown = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "";
				BackgroundTransparency = 1;
				Size = UDim2.new(.1,0,.9);
			};
		};

		ArrowUp = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "";
				BackgroundTransparency = 1;
				Size = UDim2.new(.1,0,.9);
			};
		};

		DropdownAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "";
				BackgroundColor3 = Color3.fromRGB(39, 39, 39);
				BorderColor3 = Color3.fromRGB(27, 27, 27);
			};
		};

		ScrollbarAppearance = {
			Type = "Properties";
			ClassName = "ScrollingFrame";
			Default = {
				ScrollBarThickness = 6;
			};
		};
	};

	InitialSize = UDim2.fromOffset(70,25);
	Icon = "";
	Category = "Common";
	Description = "A component that allows the player to choose an option from a list of choices upon clicking";

	Init = function(self, context, interfaceContext)
		self.Maid:GiveTask(UserInputService.InputEnded:Connect(function(inputObject, gameProcessed)
			if gameProcessed then return end
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				if interfaceContext.OpenDropdown == self then
					interfaceContext.OpenDropdown = nil
				end
			end
		end))
	end;

	PreRender = function(self, context, interfaceContext)
		if not table.find(self.Options, self.Chosen) then
			self.Chosen = self.Options[1]
		end
	end;

	Constructor = function(properties, context, interfaceContext)
		local totalSize = 0
		local buttons = {
			{
				ClassName = "UIListLayout";
				Properties = {};
			};
		}

		for i, choice in pairs(properties.Options) do
			local calculatedSize = TextService:GetTextSize(choice, properties.Font.TextSize or 14, properties.Font.Font or Enum.Font.SourceSans, Vector2.new(properties.Object.AbsoluteSize.X,math.huge))
			totalSize += calculatedSize.Y

			local btn = {
				ClassName = "TextButton";
				Properties = Util:CombineTables(Util:CombineTables(properties.Font, {
					Size = UDim2.new(1,0,0,calculatedSize.Y+4);
					Text = choice;
					LayoutOrder = i;
					Activated = function()
						properties.Chosen = choice
						interfaceContext.OpenDropdown = nil
					end;
				}), properties.ButtonAppearance or {
					BackgroundTransparency = 1;
					BackgroundColor3 = Color3.fromRGB(255,255,255);
				});
				StateAnimations = {
					Normal = {
						Time = .001;
					};
					Hover = {
						Time = .001;
						Goal = properties.ButtonHoverAppearance or {
							BackgroundTransparency = .9;
						};
					};
				};
			}

			table.insert(buttons, btn)
		end

		return {
			Button = {
				ClassName = "ImageButton";
				Properties = Util:CombineTables(properties.Appearance, {
					Size = UDim2.fromScale(1,1);
					Activated = function()
						interfaceContext.OpenDropdown = (interfaceContext.OpenDropdown == properties and nil) or (interfaceContext.OpenDropdown ~= properties and properties)
					end;
				});
				Children = {
					Label = {
						ClassName = "TextLabel";
						Properties = Util:CombineTables(properties.Font, {
							Text = properties.Chosen;
							Size = UDim2.fromScale(1,1);
							BackgroundTransparency = 1;
						});
					};
					Arrow = {
						ClassName = "ImageLabel";
						Properties = Util:CombineTables(interfaceContext.OpenDropdown == properties and properties.ArrowUp or properties.ArrowDown, {
							AnchorPoint = Vector2.new(1,.5);
							Position = UDim2.fromScale(.98,.5);
							BackgroundTransparency = 1
						});
						Children = {
							{
								ClassName = "UIAspectRatioConstraint";
								Properties = {};
							};
						};
					};
				};
				StateAnimations = {
					Normal = {
						Time = .001;
					};
					Hover = {
						Time = .001;
						Goal = properties.HoverAppearance or {
							BackgroundTransparency = .9;
						};
					};
					Pressed = {
						Time = .001;
						Goal = properties.PressedAppearance or {
							BackgroundTransparency = .9;
						};
					};
				};
			};
			Dropdown = {
				Overlay = true;
				ClassName = "ImageLabel";
				Properties = Util:CombineTables(properties.DropdownAppearance, {
					Size = UDim2.new(1,0,0,math.min(totalSize, 40));
					Position = UDim2.fromScale(0,1);
					Visible = interfaceContext.OpenDropdown == properties;
				});
				Children = {
					Scroller = {
						ClassName = "ScrollingFrame";
						Properties = Util:CombineTables(properties.ScrollbarAppearance, {
							AutomaticCanvasSize = Enum.AutomaticSize.Y;
							BackgroundTransparency = 1;
							Position = UDim2.fromScale(.5,.5);
							Size = UDim2.new(1,-2,1,-2);
							BorderSizePixel = 0;
							AnchorPoint = Vector2.new(.5,.5);
						});
						Children = buttons;
					};
				};
			};
		}
	end;
}

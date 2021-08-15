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
		Value = {
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
				Image = "rbxassetid://6939334639";
				ImageColor3 = Color3.fromRGB(49, 49, 49);
				BackgroundTransparency = 1;
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(3, 3, 147, 147);
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
				ImageColor3 = Color3.fromRGB(22, 22, 22);
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

		FontPadding = {
			Type = "Properties";
			ClassName = "UIPadding";
			Default = {
				PaddingLeft = UDim.new(0, 3);
				PaddingRight = UDim.new(0, 3);
				PaddingBottom = UDim.new();
				PaddingTop = UDim.new();
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
				Image = "rbxassetid://6939334974";
				BackgroundTransparency = 1;
				Size = UDim2.new(.1,0,.9);
			};
		};

		ArrowUp = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "rbxassetid://6939335229";
				BackgroundTransparency = 1;
				Size = UDim2.new(.1,0,.9);
			};
		};

		DropdownAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "rbxassetid://6939334639";
				ImageColor3 = Color3.fromRGB(39, 39, 39);
				BackgroundTransparency = 1;
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(3, 3, 147, 147);
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
		if not table.find(self.Options, self.Value) then
			self.Value = self.Options[1]
		end
	end;

	Constructor = function(self, context, interfaceContext)
		local totalSize = 0
		local buttons = {
			{
				ClassName = "UIListLayout";
				Properties = {};
			};
		}

		for i, choice in pairs(self.Options) do
			local calculatedSize = TextService:GetTextSize(choice, self.Font.TextSize or 14, self.Font.Font or Enum.Font.SourceSans, Vector2.new(self.Object.AbsoluteSize.X,math.huge))
			totalSize += calculatedSize.Y

			local btn = {
				ClassName = "TextButton";
				Properties = Util:CombineTables(Util:CombineTables(self.Font, {
					Size = UDim2.new(1,0,0,calculatedSize.Y+4);
					Text = choice;
					LayoutOrder = i;
					Activated = function()
						self.Value = choice
						interfaceContext.OpenDropdown = nil
					end;
				}), self.ButtonAppearance or {
					BackgroundTransparency = 1;
					BackgroundColor3 = Color3.fromRGB(255,255,255);
				});
				Children = {
					Padding = {
						ClassName = "UIPadding";
						Properties = self.FontPadding;
					};
				};
				StateAnimations = {
					Normal = {
						Time = .001;
					};
					Hover = {
						Time = .001;
						Goal = self.ButtonHoverAppearance or {
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
				Properties = Util:CombineTables(Util:CombineTables(self.Appearance, self.Disabled and self.DisabledAppearance or {}), {
					Size = UDim2.fromScale(1,1);
					Activated = function()
						if self.Disabled then return end
						interfaceContext.OpenDropdown = (interfaceContext.OpenDropdown == self and nil) or (interfaceContext.OpenDropdown ~= self and self)
					end;
				});
				Children = {
					Label = {
						ClassName = "TextLabel";
						Properties = Util:CombineTables(self.Font, {
							Text = self.Value;
							Size = UDim2.fromScale(1,1);
							BackgroundTransparency = 1;
						});
						Children = {
							Padding = {
								ClassName = "UIPadding";
								Properties = self.FontPadding;
							};
						};
					};
					Arrow = {
						ClassName = "ImageLabel";
						Properties = Util:CombineTables(interfaceContext.OpenDropdown == self and self.ArrowUp or self.ArrowDown, {
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
			Dropdown = {
				Overlay = true;
				ClassName = "ImageLabel";
				Properties = Util:CombineTables(self.DropdownAppearance, {
					Size = UDim2.new(1,0,0,math.min(totalSize, 40));
					Position = UDim2.fromScale(0,1);
					Visible = (not self.Disabled and interfaceContext.OpenDropdown == self);
				});
				Children = {
					Scroller = {
						ClassName = "ScrollingFrame";
						Properties = Util:CombineTables(self.ScrollbarAppearance, {
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

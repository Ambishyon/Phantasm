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
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				Image = "rbxassetid://6939335665";
				ImageColor3 = Color3.fromRGB(49, 49, 49);
				BackgroundTransparency = 1;
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

		TickAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				Image = "rbxassetid://6939335907";
				ImageColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1;
			};
		};

		DisabledTickAppearance = {
			Type = "Properties";
			ClassName = "ImageLabel";
			Default = {
				ImageColor3 = Color3.fromRGB(182, 182, 182);
			};
		};

		DisabledAppearance = {
			Type = "Properties";
			ClassName = "ImageButton";
			Default = {
				ImageColor3 = Color3.fromRGB(44, 44, 44);
			};
		};
	};

	Icon = "";
	Category = "Common";
	Description = "A component that allows the user to turn something on or off";

	Constructor = function(self, context, interfaceContext)
		return {
			Button = {
				ClassName = "ImageButton";
				Properties = Util:CombineTables(Util:CombineTables(self.Appearance, self.Disabled and self.DisabledAppearance or {}), {
					Size = UDim2.fromScale(1,1);
					Activated = function()
						if self.Disabled then return end
						self.Value = not self.Value
					end;
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
						Goal = self.HoverAppearance;
					};
					Pressed = {
						Time = .001;
						Goal = self.PressedAppearance;
					};
				};
				Children = {
					Tick = {
						ClassName = "ImageLabel";
						Properties = Util:CombineTables(Util:CombineTables(self.TickAppearance, self.Disabled and self.DisabledTickAppearance or {}), {
							Size = UDim2.fromScale(1,1);
							Visible = self.Value;
						});
					};
				};
			};
		}
	end;
}
local Providers = script.Parent.Parent.Providers
local MenuButtons = require(Providers.MenuButtons)
local ToolbarTools = require(Providers.ToolbarTools)

local interface = {
	Functions = {

	};
	Bindings = {

	};
	Elements = {
		Background = {
			ClassName = "Frame";
			Properties = {
				BorderSizePixel = 0;
				BackgroundColor3 = {
					Type = "Binding";
					Name = "StudioColor";
					Properties = {
						Color = Enum.StudioStyleGuideColor.ViewPortBackground;
						Modifier = Enum.StudioStyleGuideModifier.Default;
					};
				};
				Size = UDim2.new(1, 0, 1, 0);
			};
			Children = {
				Menu = {
					ClassName = "Frame";
					Properties = {
						BorderSizePixel = 0;
						BackgroundColor3 = {
							Type = "Binding";
							Name = "StudioColor";
							Properties = {
								Color = Enum.StudioStyleGuideColor.Titlebar;
								Modifier = Enum.StudioStyleGuideModifier.Default;
							};
						};
						Size = UDim2.new(1, 0, 0, 14);
					};
					Children = {
						MenuButtonsContainer = function()
							local children = {
								[0] = {
									ClassName = "UIListLayout";
									Properties = {
										FillDirection = Enum.FillDirection.Horizontal;
									};
								}
							}
							local buttons = MenuButtons:GetMenuButtons()
							for _, button in pairs(buttons) do
								if button.Enabled then
									table.insert(children, {
										ClassName = "TextButton";
										Properties = {
											BackgroundColor3 = Color3.new(0,0,0);
											BackgroundTransparency = 1;
											BorderSizePixel = 0;
											AutoButtonColor = false;
											TextSize = 8;
											TextYAlignment = Enum.TextYAlignment.Center;
											TextXAlignment = Enum.TextXAlignment.Center;
											Text = button.Name;
											TextColor3 = {
												Type = "Binding";
												Name = "StudioColor";
												Properties = {
													Color = Enum.StudioStyleGuideColor.MainText;
													Modifier = Enum.StudioStyleGuideModifier.Default;
												};
											};
											Size = UDim2.new(0, 48, 1, 0);

											Activated = function()
												button.__Clicked:Fire()
											end;
										};
										StateAnimations = {
											Normal = {
												Time = .001;
											};
											Hover = {
												Time = .001;
												Goal = {
													BackgroundTransparency = .9;
												};
											};
											Pressed = {
												Time = .001;
												Goal = {
													BackgroundTransparency = .9;
												};
											};
										}
									})
								end
							end

							return children
						end
					};
				};
				Tabs = {
					ClassName = "Frame";
					Properties = {
						BorderSizePixel = 0;
						BackgroundColor3 = {
							Type = "Binding";
							Name = "StudioColor";
							Properties = {
								Color = Enum.StudioStyleGuideColor.MainBackground;
								Modifier = Enum.StudioStyleGuideModifier.Default;
							};
						};
						Size = UDim2.new(1, 0, 0, 17);
						Position = UDim2.new(0, 0, 0, 14);
					};
				};
				Toolbar = {
					ClassName = "Frame";
					Properties = {
						BorderSizePixel = 0;
						BackgroundColor3 = {
							Type = "Binding";
							Name = "StudioColor";
							Properties = {
								Color = Enum.StudioStyleGuideColor.RibbonTab;
								Modifier = Enum.StudioStyleGuideModifier.Default;
							};
						};
						Size = UDim2.new(1, 0, 0, 25);
						Position = UDim2.new(0, 0, 0, 31);
					};
					Children = {
						ToolbarToolsContainer = function()
							local children = {
								[0] = {
									ClassName = "UIListLayout";
									Properties = {
										FillDirection = Enum.FillDirection.Horizontal;
									};
								}
							}
							local buttons = ToolbarTools:GetTools()
							for _, button in pairs(buttons) do
								if button.Enabled and button.Alignment == Enum.HorizontalAlignment.Left then
									table.insert(children, {
										ClassName = "TextButton";
										Properties = {
											BackgroundColor3 = button.Active and {
												Type = "Binding";
												Name = "StudioColor";
												Properties = {
													Color = Enum.StudioStyleGuideColor.MainButton;
													Modifier = Enum.StudioStyleGuideModifier.Selected;
												};
											} or {
												Type = "Binding";
												Name = "StudioColor";
												Properties = {
													Color = Enum.StudioStyleGuideColor.RibbonTab;
													Modifier = Enum.StudioStyleGuideModifier.Default;
												};
											};
											BorderSizePixel = 0;
											AutoButtonColor = false;
											TextSize = 8;
											TextYAlignment = Enum.TextYAlignment.Center;
											TextXAlignment = Enum.TextXAlignment.Center;
											Text = "";
											Size = UDim2.new(0, 25, 1, 0);

											Activated = function()
												button.__ToolbarClicked:Fire()
											end;
										};
										StateAnimations = {
											Normal = {
												Time = .001;
											};
											Hover = {
												Time = .001;
												Goal = {
													BackgroundColor3 = button.Active and {
														Type = "Binding";
														Name = "StudioColor";
														Properties = {
															Color = Enum.StudioStyleGuideColor.MainButton;
															Modifier = Enum.StudioStyleGuideModifier.Selected;
														};
													} or {
														Type = "Binding";
														Name = "StudioColor";
														Properties = {
															Color = Enum.StudioStyleGuideColor.RibbonButton;
															Modifier = Enum.StudioStyleGuideModifier.Hover;
														};
													};
												};
											};
											Pressed = {
												Time = .001;
												Goal = {
													BackgroundColor3 = button.Active and {
														Type = "Binding";
														Name = "StudioColor";
														Properties = {
															Color = Enum.StudioStyleGuideColor.MainButton;
															Modifier = Enum.StudioStyleGuideModifier.Selected;
														};
													} or {
														Type = "Binding";
														Name = "StudioColor";
														Properties = {
															Color = Enum.StudioStyleGuideColor.RibbonButton;
															Modifier = Enum.StudioStyleGuideModifier.Pressed;
														};
													};
												};
											};
										};
										Children = {
											Icon = {
												ClassName = "ImageLabel";
												Properties = {
													Size = UDim2.fromScale(.45, .45);
													Image = button.Icon;
													BackgroundTransparency = 1;
													AnchorPoint = Vector2.new(.5, .5);
													Position = UDim2.fromScale(.5, .5);
												};
											};
											Arrow = {
												ClassName = "ImageButton";
												Properties = {
													Size = UDim2.fromOffset(5, 8);
													Image = "rbxassetid://7287433602";
													BackgroundTransparency = 1;
													AnchorPoint = Vector2.new(1, .5);
													Position = UDim2.new(1, -1, .5, 0);
													ScaleType = Enum.ScaleType.Crop;
													Visible = #button.SubTools > 0;
												};
												StateAnimations = {
													Normal = {
														Time = .25;
													};
													Hover = {
														Time = .25;
														Goal = {
															Position = UDim2.new(1, -1, .5, 3);
														};
													};
													Pressed = {
														Time = .25;
														Goal = {
															Position = UDim2.new(1, -1, .5, 3);
														};
													};
												};
											};
										};
									})
								end
							end

							return children
						end
					};
				};
				Viewport = {
					ClassName = "Frame";
					Properties = {
						BorderSizePixel = 0;
						BackgroundTransparency = 1;
						Size = UDim2.new(1, 0, 1, -56);
						Position = UDim2.new(0, 0, 0, 56);
						ClipsDescendants = true;
					};
					Children = {
						Canvas = {
							ClassName = "Frame";
							Properties = {
								BorderSizePixel = 2;
								BorderColor3 = {
									Type = "Binding";
									Name = "StudioColor";
									Properties = {
										Color = Enum.StudioStyleGuideColor.Border;
										Modifier = Enum.StudioStyleGuideModifier.Default;
									};
								};
								BackgroundColor3 = Color3.fromRGB(200,200,200);
								Size = UDim2.new(0, 900, 0, 460);
								Position = UDim2.new(0.5, 0, 0.5, 0);
								AnchorPoint = Vector2.new(.5,.5);
							}
						};
					};
				};
			}
		}
	};
}

return interface
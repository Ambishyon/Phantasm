local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

local Chat = game:GetService("Chat")

return {
	Properties = {
		Arguments = {
			Type = "Dictionary";
			Default = {
				BubbleDuration = 15;
				MaxBubbles = 3;
				BackgroundColor3 = Color3.fromRGB(250,250,250);
				TextColor3 = Color3.fromRGB(57, 59, 61);
				TextSize = 16;
				Font = Enum.Font.GothamSemibold;
				Transparency = .1;
				CornerRadius = UDim.new(0,12);
				TailVisible = true;
				Padding = 8;
				MaxWidth = 300;
				VerticalStudsOffset = 0;
				BubblesSpacing = 6;
				MinimizeDistance = 40;
				MaxDistance = 100;
			};
		}
	};
	Category = "Chat";
	Description = "Set the bubble chat settings";
	Run = function(element, arguments, ...)
		Chat:SetBubbleChatSettings(arguments.Arguments)
	end
}
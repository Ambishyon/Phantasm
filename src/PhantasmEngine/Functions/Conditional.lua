local Libraries = script.Parent.Parent.Libraries
local Util = require(Libraries.Util)

return {
	Properties = {
		Condition = {
			Type = "Function";
			Default = {
				Type = "Function";
				Name = "";
				Settings = {};
			};
		};
		True = {
			Type = "Function";
			Default = {
				Type = "Function";
				Name = "";
				Settings = {};
			};
		};
		False = {
			Type = "Function";
			Default = {
				Type = "Function";
				Name = "";
				Settings = {};
			};
		};
	};
	Category = "Common";
	Description = "Checks if the condition function returns a true value, will fire the True or False function depending on the result";
	Run = function(element, arguments, ...)
		if Util:ExecuteFunction(arguments.Condition, element, arguments, ...) then
			if arguments.True then
				Util:ExecuteFunction(arguments.True, element, arguments, ...)
			end
		else
			if arguments.False then
				Util:ExecuteFunction(arguments.False, element, arguments, ...)
			end
		end
	end
}
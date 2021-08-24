local api = {}

local readOnlyEventType = {
	__newindex = function(self)
		error(string.format("Event.Changed.%s is read only!", self.Name), 1)
	end;
}

setmetatable(api, {
	__index = function(self, what)
		local event = setmetatable({
			Type = "Changed";
			Name = what;
		}, readOnlyEventType)
		rawset(self, what, event)
		return event
	end;

	__newindex = function()
		error("Changed is read only!", 1)
	end;
})

return api
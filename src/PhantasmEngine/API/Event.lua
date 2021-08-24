local api = {}

local readOnlyEventType = {
	__newindex = function(self)
		error(string.format("Event.%s is read only!", self.Name), 1)
	end;
}

setmetatable(api, {
	__index = function(self, what)
		local event = setmetatable({
			Type = "Event";
			Name = what;
		}, readOnlyEventType)
		rawset(self, what, event)
		return event
	end;

	__newindex = function()
		error("Event is read only!", 1)
	end;
})

return api
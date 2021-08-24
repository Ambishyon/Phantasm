local api = {}

setmetatable(api, {
	__index = function()
		error("Ref is read only!", 1)
	end;

	__newindex = function()
		error("Ref is read only!", 1)
	end;
})

return api
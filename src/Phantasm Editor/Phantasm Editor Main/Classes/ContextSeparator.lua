local class = {}
class.__index = class

function class.new()
	local self = setmetatable({}, class)

	return self
end

function class:IsA(what)
	return what == "ContextSeparator"
end

return class
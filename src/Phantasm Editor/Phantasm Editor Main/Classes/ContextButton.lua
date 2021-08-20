local class = {}
class.__index = class

function class.new(title, subtitle, icon)
	local self = setmetatable({}, class)

	self.Title = title
	self.Subtitle = subtitle
	self.Icon = icon
	self.Disabled = false
	self.Active = false

	self.__Clicked = Instance.new("BindableEvent")
	self.Clicked = self.__Clicked.Event

	return self
end



function class:IsA(what)
	return what == "ContextButton"
end

return class
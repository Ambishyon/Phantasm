local module = {}

--- Converts a valid object to something the engine can use in-game.
function module.fromObject(object: ModuleScript): table
	local Settings = require(object)

	local data = {
		Functions = {};
		Bindings = {};
		Elements = {};
	}

	for _, v in pairs(object.Functions:GetChildren()) do
		local func = require(v)
		assert(type(func) == "function", string.format("Expected type 'function' for '%s', got '%s' instead", v.Name, type(func)))
		data.Functions[v.Name] = func
	end

	for _, v in pairs(object.Bindings:GetChildren()) do
		local binding = require(v)
		assert(type(binding) == "function", string.format("Expected type 'function' for '%s', got '%s' instead", v.Name, type(binding)))
		data.Bindings[v.Name] = binding
	end

	for _, v in pairs(object.Elements:GetChildren()) do
		-- TODO: Validate proper element structure.
		local element = require(v)
		assert(type(element) == "table", string.format("Expected type 'table' for '%s', got '%s' instead", v.Name, type(element)))
		data.Elements[v.Name] = element
	end

	return data
end

--- Plugin-only method used to convert the data to something the engine can load up in-game 
function module.toObject(data: table): ModuleScript
	-- TODO: Make this functional
end

return module
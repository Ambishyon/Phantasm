local module = {}

local structures = {
	Element = {
		ClassName = "string";
		Properties = "table";
		Children = {
			Optional = true;
			Type = "Structure";
		};
	};
}

structures.Element.Children.Structure = structures.Element

function module.validateStructure(structure: table, with: table): boolean
	for index, expectedType in pairs(with) do
		if type(expectedType) == "table" then
			if expectedType.Optional == false and structure[index] == nil then
				return false
			elseif structure[index] then
				if expectedType.Type == "Structure" then
					if not module.validateStructure(structure[index], expectedType.Structure) then
						return false
					end
				else
					if typeof(structure[index]) ~= expectedType.Type then
						return false
					end
				end
			end
		elseif typeof(structure[index]) ~= expectedType then
			return false
		end
	end
	return true
end

--- Converts a valid object to something the engine can use in-game.
function module.fromObject(object: ModuleScript): table
	local Settings = require(object)

	local data = {
		Functions = {};
		Bindings = {};
		Elements = {};
		Components = {};
	}

	for _, v in pairs(object.Functions:GetChildren()) do
		-- TODO: Validate proper function structure
		local func = require(v)
		assert(type(func) == "function", string.format("[PHANTASM]: Expected type 'function' for '%s', got '%s' instead", v.Name, type(func)))
		data.Functions[v.Name] = func
	end

	for _, v in pairs(object.Bindings:GetChildren()) do
		-- TODO: Validate proper binding structure
		local binding = require(v)
		assert(type(binding) == "function", string.format("[PHANTASM]: Expected type 'function' for '%s', got '%s' instead", v.Name, type(binding)))
		data.Bindings[v.Name] = binding
	end

	for _, v in pairs(object.Elements:GetChildren()) do
		local element = require(v)
		assert(type(element) == "table", string.format("[PHANTASM]: Expected type 'table' for '%s', got '%s' instead", v.Name, type(element)))
		if not module.validateStructure(element, structures.Element) then
			warn(string.format("[PHANTASM]: Malformed element structure '%s', skipping element"), v.Name)
			continue
		end
		data.Elements[v.Name] = element
	end

	for _, v in pairs(object.Components:GetChildren()) do
		-- TODO: Validate proper component structure.
		local element = require(v)
		assert(type(element) == "table", string.format("[PHANTASM]: Expected type 'table' for '%s', got '%s' instead", v.Name, type(element)))
		data.Components[v.Name] = element
	end

	return data
end

--- Plugin-only method used to convert the data to something the engine can load up in-game 
function module.toObject(data: table): ModuleScript
	-- TODO: Make this functional
end

return module
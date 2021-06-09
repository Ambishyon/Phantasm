local module = {}

local interpreterTemplates = script.Parent.InterpreterTemplates

local structures = {
	Element = {
		ClassName = "string";
		Properties = "table";
		StateAnimations = {
			Optional = true;
			Type = "table";
		};
		Sounds = {
			Optional = true;
			Type = "table";
		};
		Children = {
			Optional = true;
			Type = "ArrayStructure";
			Structure = "Element";
		}
	};
	Binding = {
		Properties = {
			Optional = true;
			Type = "table";
		};
		ReturnType = {
			Optional = true;
			Type = "string";
		};
		Category = {
			Optional = true;
			Type = "string";
		};
		Description = {
			Optional = true;
			Type = "string";
		};
		Run = "function";
	};
	Component = {
		Children = {
			Optional = true;
			Type = "ArrayStructure";
			Structure = "Element";
		};
		Properties = {
			Optional = true;
			Type = "table";
		};
		Category = {
			Optional = true;
			Type = "string";
		};
		Description = {
			Optional = true;
			Type = "string";
		};
		Icon = {
			Optional = true;
			Type = "string";
		};
		Constructor = "function";
	}
}

local function validateStructure(structure: table, with: table): boolean
	for index, expectedType in pairs(with) do
		if type(expectedType) == "table" then
			if expectedType.Optional ~= true and structure[index] == nil then
				return false
			elseif structure[index] then
				if expectedType.Type == "Structure" then
					if not validateStructure(structure[index], expectedType.Structure) then
						return false
					end
				elseif expectedType.Type == "ArrayStructure" then
					if not type(structure[index]) == "table" then
						return false
					end

					for _, v in pairs(structure[index]) do
						if not validateStructure(v, type(expectedType.Structure) == "string" and structures[expectedType.Structure] or expectedType.Structure) then
							return false
						end
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

	for i, v in pairs(Settings) do
		if data[i] ~= nil then continue end
		data[i] = v
	end

	for _, v in pairs(object.Functions:GetChildren()) do
		local func = require(v)
		assert(type(func) == "table", string.format("[PHANTASM]: Expected type 'table' for function '%s', got '%s' instead", v.Name, type(func)))
		if not validateStructure(func, structures.Function) then
			warn(string.format("[PHANTASM]: Malformed function structure '%s', skipping function"), v.Name)
			continue
		end
		data.Functions[v.Name] = func
	end

	for _, v in pairs(object.Bindings:GetChildren()) do
		local binding = require(v)
		assert(type(binding) == "table", string.format("[PHANTASM]: Expected type 'table' for binding '%s', got '%s' instead", v.Name, type(binding)))
		if not validateStructure(binding, structures.Binding) then
			warn(string.format("[PHANTASM]: Malformed binding structure '%s', skipping binding"), v.Name)
			continue
		end
		data.Bindings[v.Name] = binding
	end

	for _, v in pairs(object.Elements:GetChildren()) do
		local element = require(v)
		assert(type(element) == "table", string.format("[PHANTASM]: Expected type 'table' for element '%s', got '%s' instead", v.Name, type(element)))
		if not validateStructure(element, structures.Element) then
			warn(string.format("[PHANTASM]: Malformed element structure '%s', skipping element"), v.Name)
			continue
		end
		data.Elements[v.Name] = element
	end

	for _, v in pairs(object.Components:GetChildren()) do
		local element = require(v)
		assert(type(element) == "table", string.format("[PHANTASM]: Expected type 'table' for component '%s', got '%s' instead", v.Name, type(element)))
		if not validateStructure(element, structures.Component) then
			warn(string.format("[PHANTASM]: Malformed component structure '%s', skipping component"), v.Name)
			continue
		end
		data.Components[v.Name] = element
	end

	return data
end

--- Plugin-only method used to convert the data to something the engine can load up in-game 
function module.toObject(data: table): ModuleScript
	local replacement = {
		DISPLAYORDER = data.DisplayOrder or 0;
		IGNOREGUIINSET = data.IgnoreGuiInset or false;
		RESETONSPAWN = (data.ResetOnSpawn ~= nil and data.ResetOnSpawn) or (data.ResetOnSpawn == nil and true);
		ZINDEXBEHAVIOR = data.ZIndexBehavior or Enum.ZIndexBehavior.Sibling;
	}

	local object = interpreterTemplates.Interface:Clone()
	object.Source = string.gsub(object.Source, ".+", replacement)
end

return module

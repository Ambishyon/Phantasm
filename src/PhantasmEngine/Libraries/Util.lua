local HttpService = game:GetService("HttpService")
local module = {}

function module:DeepCopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[module:DeepCopy(orig_key, copies)] = module:DeepCopy(orig_value, copies)
			end
			setmetatable(copy, module:DeepCopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function module:CopyTo(from, to)
	for i, v in pairs(from) do
		to[i] = module:DeepCopy(v)
	end
end

function module:ReconcileTable(target, template)
	for name, value in pairs(template) do
		if type(name) ~= "string" then
			continue
		end
		if target[name] == nil then
			target[name] = module:DeepCopy(value)
		elseif typeof(value) == "table" and typeof(target[name]) == "table" then
			module:ReconcileTable(target[name], value)
		end
	end
end

function module:ApplyDifferences(tab: table, differences: table): table
	local changed = {}

	for i, v in pairs(differences.Additions) do
		tab[i] = v
		table.insert(changed, i)
	end

	for _, v in pairs(differences.Deletions) do
		tab[v] = nil
		table.insert(changed, v)
	end

	for i, v in pairs(differences.Changes) do
		if typeof(v) == "table" and v.Changes and v.Additions and v.Deletions then
			module:ApplyDifferences(tab[i], v)
		else
			tab[i] = v
		end
		table.insert(changed, i)
	end

	return changed
end

function module:GenerateDifferences(table1, table2, alreadyChecked)
	local alreadyChecked = alreadyChecked or {}
	local diffList = {
		Additions = {};
		Changes = {};
		Deletions = {};
	}
	
	for name, value in pairs(table1) do
		if table2[name] ~= nil then
			if typeof(table2[name]) == "table" and typeof(value) == "table" then
				if alreadyChecked[table2[name]] or alreadyChecked[value] then
					continue
				end
				alreadyChecked[table2[name]] = true
				alreadyChecked[value] = true
				if not module:CompareTables(value, table2[name]) then
					diffList.Changes[name] = module:GenerateDifferences(value, table2[name], alreadyChecked)
				end
			elseif (typeof(value) ~= typeof(table2[name])) or (value ~= table2[name]) then
				diffList.Changes[name] = table2[name]
			end
		else
			table.insert(diffList.Deletions, name)
		end
	end
	
	for name, value in pairs(table2) do
		if table1[name] == nil then
			diffList.Additions[name] = value
		end
	end
	
	return diffList
end

function module:ShallowCompare(table1, table2)
	local changed = {}
	
	local avoid_loops = {}
	for i, v in pairs(table1) do
		if table2[i] ~= nil then
			if (typeof(v) == "table" and module:CompareTables(v, table2[i])) or (typeof(v) ~= typeof(table2[i])) or (v ~= table2[i]) then
				table.insert(changed, i)
			end
		else
			table.insert(changed, i)
		end
	end
	
	for i, v in pairs(table2) do
		if table1[i] == nil then
			table.insert(changed, i)
		end
	end
	
	return changed
end

function module:JSONCompare(table1, table2)
	local json1,json2 = HttpService:JSONEncode(table1), HttpService:JSONEncode(table2)
	
	return json1 == json2
end

function module:CompareTables(table1, table2)
	local avoid_loops = {}
	local function recurse(t1, t2)
		-- compare value types
		if type(t1) ~= type(t2) then return false end
		-- Base case: compare simple values
		if type(t1) ~= "table" then return t1 == t2 end
		-- Now, on to tables.
		-- First, let's avoid looping forever.
		if avoid_loops[t1] then return avoid_loops[t1] == t2 end
		avoid_loops[t1] = t2
		-- Copy keys from t2
		local t2keys = {}
		local t2tablekeys = {}
		for k, _ in pairs(t2) do
			if type(k) == "table" then table.insert(t2tablekeys, k) end
			t2keys[k] = true
		end
		-- Let's iterate keys from t1
		for k1, v1 in pairs(t1) do
			local v2 = t2[k1]
			if type(k1) == "table" then
				-- if key is a table, we need to find an equivalent one.
				local ok = false
				for i, tk in ipairs(t2tablekeys) do
					if module:CompareTables(k1, tk) and recurse(v1, t2[tk]) then
						table.remove(t2tablekeys, i)
						t2keys[tk] = nil
						ok = true
						break
					end
				end
				if not ok then return false end
			else
				-- t1 has a key which t2 doesn't have, fail.
				if v2 == nil then return false end
				t2keys[k1] = nil
				if not recurse(v1, v2) then return false end
			end
		end
		-- if t2 has a key which t1 doesn't have, fail.
		if next(t2keys) then return false end
		return true
	end
	return recurse(table1, table2)
end

return module

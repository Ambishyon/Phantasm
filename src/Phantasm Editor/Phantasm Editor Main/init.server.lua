local inits = {}

for _, module in pairs(script.Modules:GetChildren()) do
	local data = require(module)
	if data.init then
		table.insert(inits, data.init)
	end
end

for _, init in pairs(inits) do
	init(plugin)
end
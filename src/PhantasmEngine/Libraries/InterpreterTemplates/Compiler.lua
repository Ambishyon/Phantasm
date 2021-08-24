local results = {}

for _, v in pairs(script:GetChildren()) do
	results[v.Name] = require(v)
end

return results

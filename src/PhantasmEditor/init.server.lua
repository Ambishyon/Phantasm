--[[
--File Name: init.server.lua
--Author: TheGrimDeathZombie
--Last Modified: Saturday, 15th May 2021 3:27:26 pm
--Modified By: TheGrimDeathZombie
--]]

local inits = {}

for _, module in pairs(script.Modules:GetChildren()) do
	local data = require(module)
	if data.Init then
		table.insert(inits, data.Init)
	end
end

for _, init in pairs(inits) do
	init(plugin)
end
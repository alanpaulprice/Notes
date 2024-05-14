local addonName, addon = ...
addon.Utilities = {}
local Utilities = addon.Utilities

function Utilities:GetTableKeys(input)
	local keys = {}

	for key, _ in pairs(input) do
		table.insert(keys, tostring(key))
	end

	return unpack(keys)
end

function Utilities:PrintTableKeys(input, sorted)
	local keys = { Utilities:GetTableKeys(input) }

	if sorted ~= false then
		table.sort(keys)
	end

	for _, key in ipairs(keys) do
		print(key)
	end
end

local addonName, addon = ...
addon.Utilities = {}
local Utilities = addon.Utilities

function Utilities:CheckIsEnumMember(input, enum)
	for _, value in pairs(enum) do
		if input == value then
			return true
		end
	end

	error("Invalid enum member " .. tostring(input) .. " received")
end

-- More than two arguments can be provided, to indicate that the value can be one of multiple types.
function Utilities:CheckType(input, ...)
	local expectedTypes = { ... }

	if #expectedTypes == 0 then
		error("No expected types received. One or more must be provided.")
	end

	local validTypes = { "nil", "boolean", "number", "string", "function", "userdata", "thread", "table" }

	for _, expectedType in ipairs(expectedTypes) do
		local expectedTypeIsValid = false

		for _, validType in ipairs(validTypes) do
			if expectedType == validType then
				expectedTypeIsValid = true
			end
		end

		if not expectedTypeIsValid then
			error("Invalid type `" .. expectedType .. "` received.")
		end
	end

	local inputType = type(input)
	local typeIsExpected = false

	for _, expectedType in ipairs(expectedTypes) do
		if inputType == expectedType then
			typeIsExpected = true
		end
	end

	if not typeIsExpected then
		local quotedExpectedTypes = {}
		for _, str in ipairs(expectedTypes) do
			table.insert(quotedExpectedTypes, "`" .. str .. "`")
		end
		local expectedTypesString = table.concat(quotedExpectedTypes, " or ")
		error(
			"Expected type: "
				.. expectedTypesString
				.. ", received `"
				.. tostring(input)
				.. "` (type: `"
				.. type(input)
				.. "`)."
		)
	end
end

function Utilities:FilterNonNumericCharactersFromString(input)
	self:CheckType(input, "string")

	local result = ""

	for i = 1, #input do
		local character = string.sub(input, i, i)
		if (i == 1 and character == "-") or (tonumber(character) ~= nil) then
			result = result .. character
		end
	end

	return result
end

function Utilities:RoundNumber(number, numberOfPlaces, roundUpHalves)
	self:CheckType(number, "number")
	self:CheckType(numberOfPlaces, "number", "nil")
	self:CheckType(roundUpHalves, "boolean", "nil")

	numberOfPlaces = numberOfPlaces or 0
	local factor = 10 ^ numberOfPlaces
	local shiftedNumber = number * factor

	local fractionalPart = shiftedNumber % 1
	local roundedNumber

	-- Exact halves (.5) are rounded up by default.
	if fractionalPart == 0.5 and roundUpHalves ~= false then
		roundedNumber = math.ceil(shiftedNumber) / factor
	else
		roundedNumber = math.floor(shiftedNumber + 0.5) / factor
	end

	return roundedNumber
end

function Utilities:TableContainsValue(table, value)
	for _, tableValue in pairs(table) do
		if tableValue == value then
			return true
		end
	end

	return false
end

function Utilities:AddToInspector(data, strName)
	if DevTool and addon.DEBUG then
		DevTool:AddData(data, strName)
	end
end

function Utilities:CloneTable(original)
	local clone

	if type(original) == "table" then
		clone = {}
		for orig_key, originalValue in next, original, nil do
			clone[self:CloneTable(orig_key)] = self:CloneTable(originalValue)
		end
		setmetatable(clone, self:CloneTable(getmetatable(original)))
	else
		clone = original
	end

	return clone
end

function Utilities:RunCallbackForGameVersion(callbacks)
	self:CheckType(callbacks, "table")
	self:CheckType(callbacks.mainline, "function", "nil")
	self:CheckType(callbacks.classic, "function", "nil")
	self:CheckType(callbacks.cataclysmClassic, "function", "nil")

	local errorMessage = "No callback was provided for the current game version."

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		if type(callbacks.mainline) == "function" then
			return callbacks.mainline()
		else
			error(errorMessage)
		end
	elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		if type(callbacks.classic) == "function" then
			return callbacks.classic()
		else
			error(errorMessage)
		end
	elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
		if type(callbacks.cataclysmClassic) == "function" then
			return callbacks.cataclysmClassic()
		else
			error(errorMessage)
		end
	else
		error("Unexpected game version encountered.")
	end
end

function Utilities:AddAceGuiLabelSpacer(container, fontHeight)
	local AceGUI = LibStub("AceGUI-3.0")
	local spacer = AceGUI:Create("Label")
	spacer:SetFullWidth(true)
	spacer:SetText(" ")
	spacer:SetFont("Fonts\\FRIZQT__.TTF", fontHeight, "")
	container:AddChild(spacer)
	return spacer
end

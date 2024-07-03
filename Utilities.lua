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
			error("Invalid expected type `" .. expectedType .. "` received.")
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

function Utilities:CheckNumberIsWithinBounds(number, min, max)
	self:CheckType(number, "number")
	self:CheckType(min, "number", "nil")
	self:CheckType(max, "number", "nil")

	if (min and number < min) or (max and number > max) then
		error(
			"Number was not within bounds."
				.. " Number: "
				.. tostring(number)
				.. ", Minimum: "
				.. tostring(min)
				.. ", Maximum: "
				.. tostring(max)
		)
	end
end

function Utilities:ClampNumber(number, min, max)
	self:CheckType(number, "number")
	self:CheckType(min, "number", "nil")
	self:CheckType(max, "number", "nil")

	local result = number

	if min and (number < min) then
		result = min
	elseif max and (number > max) then
		number = max
	end

	return result
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

function Utilities:RoundNumberDecimal(number, numberOfPlaces, roundUpHalves)
	self:CheckType(number, "number")
	self:CheckType(numberOfPlaces, "number")
	self:CheckType(roundUpHalves, "boolean", "nil")

	if numberOfPlaces < 1 then
		error("`numberOfPlaces` must be `1` or greater.")
	end

	local numberAsString = tostring(number)
	local decimalPosition = string.find(numberAsString, "%.")
	local numberOfPlacesNotExceeded = (#numberAsString - decimalPosition) < numberOfPlaces

	if decimalPosition == nil or numberOfPlacesNotExceeded then
		return number
	end

	-- An excess decimal has a place that is higher than the maximum allowed (determined by `numberOfPlaces`).
	local excessDecimals = string.sub(numberAsString, decimalPosition + 1 + numberOfPlaces, nil)

	local roundUp = nil

	-- Determines whether rounding up is necessary, by looping over the excess decimals characters.
	for character in excessDecimals:gmatch(".") do
		-- If the character isn't "5", rounding up is temporarily assumed, in case it is the last character.
		if character == "5" then
			-- If `roundUpHalves` isn't passed, `roundUp` will be set to `true`.
			if roundUpHalves ~= nil then
				roundUp = roundUpHalves
			else
				roundUp = true
			end
		-- If the charcter isn't "5", it can be used to determine if rounding up is necessary.
		-- The loop is broken, as there is no need to continue.
		else
			roundUp = tonumber(character) > 5
			break
		end
	end

	local stringPreceedingFinalDigit = string.sub(numberAsString, 1, decimalPosition + numberOfPlaces - 1)
	local finalDigit = string.sub(numberAsString, decimalPosition + numberOfPlaces, decimalPosition + numberOfPlaces)

	-- Round up the last digit if necessary.
	if roundUp then
		finalDigit = tostring(tonumber(finalDigit) + 1)
	end

	-- Join the part of the string preceeding the final digit with the final digit.
	local result = tonumber(stringPreceedingFinalDigit .. finalDigit)

	return result
end

function Utilities:TableContainsValue(table, value)
	for _, tableValue in pairs(table) do
		if tableValue == value then
			return true
		end
	end

	return false
end

function Utilities:GetTableLength(input)
	Utilities:CheckType(input, "table")

	local count = 0

	for _ in pairs(input) do
		count = count + 1
	end

	return count
end

function Utilities:GetTableKeys(input)
	Utilities:CheckType(input, "table")

	local keys = {}

	for key, _ in pairs(input) do
		table.insert(keys, tostring(key))
	end

	return unpack(keys)
end

function Utilities:PrintMetaTableKeys(input, sorted)
	Utilities:CheckType(input, "table")

	local metatable = getmetatable(input)

	if Utilities:GetTableLength(metatable) > 0 then
		Utilities:PrintTableKeys(metatable, sorted, false)
	else
		print("The metatable has no keys.")
	end
end

function Utilities:PrintTableKeys(input, sorted, printMetatable)
	Utilities:CheckType(input, "table")

	if Utilities:GetTableLength(input) > 0 then
		local keys = { Utilities:GetTableKeys(input) }

		if sorted ~= false then
			table.sort(keys)
		end

		for _, value in pairs(keys) do
			print(value)
		end
	else
		print("The table has no keys.")
	end

	if printMetatable ~= false then
		print("-----")
		Utilities:PrintMetaTableKeys(input, sorted)
	end
end

function Utilities:CreateInterfaceOptionsCheckButton(label, parent, onClick)
	local checkButton = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
	checkButton:SetFrameStrata("MEDIUM")

	checkButton:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		onClick(self, checked and true or false)
		if checked then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		end
	end)

	checkButton.Text:SetText(label)
	checkButton.Text:SetPoint("LEFT", checkButton, "RIGHT", 4, 0)

	return checkButton
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

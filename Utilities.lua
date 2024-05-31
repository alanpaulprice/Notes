local addonName, addon = ...
addon.Utilities = {}
local Utilities = addon.Utilities

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
			error("Invalid expected type `" .. expectedType("` received."))
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
			PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		else
			PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
		end
	end)

	checkButton.Text:SetText(label)
	checkButton.Text:SetPoint("LEFT", checkButton, "RIGHT", 4, 0)

	return checkButton
end

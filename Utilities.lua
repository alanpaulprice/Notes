local addonName, addon = ...
addon.Utilities = {}
local Utilities = addon.Utilities

function Utilities:CheckType(input, expectedType)
	if type(input) ~= expectedType then
		error("Expected," .. expectedType .. ", received " .. tostring(input) .. " (type: " .. type(input) .. ").")
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

local addonName, addon = ...
addon.Utilities = {}
local Utilities = addon.Utilities

function Utilities:CheckIsTable(input)
	if type(input) ~= "table" then
		error("Table expected, received " .. tostring(input) .. " (type: " .. type(input) .. ").")
	end
end

function Utilities:GetTableLength(input)
	Utilities:CheckIsTable(input)

	local count = 0

	for _ in pairs(input) do
		count = count + 1
	end

	return count
end

function Utilities:GetTableKeys(input)
	Utilities:CheckIsTable(input)

	local keys = {}

	for key, _ in pairs(input) do
		table.insert(keys, tostring(key))
	end

	return unpack(keys)
end

function Utilities:PrintMetaTableKeys(input, sorted)
	Utilities:CheckIsTable(input)

	local metatable = getmetatable(input)

	if Utilities:GetTableLength(metatable) > 0 then
		Utilities:PrintTableKeys(metatable, sorted, false)
	else
		print("The metatable has no keys.")
	end
end

function Utilities:PrintTableKeys(input, sorted, printMetatable)
	Utilities:CheckIsTable(input)

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

function Utilities:CreateInterfaceOptionsCheckButton(label, description, name, parent, onClick)
	local checkButton = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
	checkButton:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		onClick(self, checked and true or false)
		if checked then
			PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		else
			PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
		end
	end)
	checkButton.label = _G[checkButton:GetName() .. "Text"]
	checkButton.label:SetText(label)
	checkButton.label:SetPoint("LEFT", checkButton, "RIGHT", 4, 0)
	-- checkButton.label:SetPoint("LEFT", 8, 0)
	checkButton.tooltipText = label
	checkButton.tooltipRequirement = description
	return checkButton
end

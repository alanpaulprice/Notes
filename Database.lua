local addonName, addon = ...

addon.Database = {}
local Database = addon.Database

local initialDatabaseState = {
	config = {
		font = "GameFontHighlight",
		minimapButton = {
			hide = false,
		},
		showAtLogin = false,
	},
	note = "",
}

function Database:Initialize()
	if NotesDB == nil then
		NotesDB = initialDatabaseState
	end

	if not NotesLDBIconDB then
		NotesLDBIconDB = { hide = false }
	end
end

function Database:GetFont()
	return NotesDB.config.font
end

function Database:SetFont(input)
	addon.Utilities:CheckType(input, "string")
	NotesDB.config.font = input
end

function Database:GetMinimapButtonHidden()
	return NotesDB.config.minimapButton.hide
end

function Database:SetMinimapButtonHidden(input)
	addon.Utilities:CheckType(input, "boolean")
	NotesDB.config.minimapButton.hide = input
end

function Database:GetShowAtLogin()
	return NotesDB.config.showAtLogin
end

function Database:SetShowAtLogin(input)
	addon.Utilities:CheckType(input, "boolean")
	NotesDB.config.showAtLogin = input
end

function Database:GetNote()
	return NotesDB.note
end

function Database:SetNote(input)
	addon.Utilities:CheckType(input, "string")
	NotesDB.note = input
end

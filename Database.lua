local addonName, addon = ...

addon.Database = {}
local Database = addon.Database

function Database:Initialize()
	if NotesDB == nil then
		NotesDB = {
			config = {},
			note = "note was empty",
		}
	end

	if not NotesLDBIconDB then
		NotesLDBIconDB = { hide = false }
	end
end

function Database:GetNote()
	return NotesDB.note
end

function Database:SetMinimapButtonHidden(input)
	addon.Utilities:CheckType(input, "boolean")
	NotesLDBIconDB.hide = input
end

function Database:GetMinimapButtonHidden()
	return NotesLDBIconDB.hide
end

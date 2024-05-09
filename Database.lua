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
end

function Database:GetNote()
	return NotesDB.note
end

function Database:SetNote(string)
	if type(string) == "string" then
		NotesDB.note = string
	end
end

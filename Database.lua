local addonName, addon = ...

addon.Database = {}
local Database = addon.Database

local initialDatabaseState = {
	config = {
		size = {
			width = 338,
			height = 424,
		},
		point = {
			anchorPoint = "CENTER",
			relativeTo = nil,
			relativePoint = "CENTER",
			xOffset = 0,
			yOffset = 0,
		},
		font = "GameFontHighlight",
		minimapButton = {
			hide = false,
		},
		showAtLogin = false,
	},
	currentNoteId = 1,
	notes = {
		{
			id = 1,
			title = "Getting Started",
			body = "Thank you for installing "
				.. addonName
				.. "."
				.. "\n\n"
				.. "All text entered here will be saved automatically."
				.. "\n\n"
				.. " You can access the 'Manage' view by clicking the 'Manage Notes' button below."
				.. " From there, you can:"
				.. "\n"
				.. "- View all existing notes."
				.. "\n"
				.. "- Create a new note."
				.. "\n"
				.. "- Edit the title of a note."
				.. "\n"
				.. "- Delete a note."
				.. "\n\n"
				.. "You can resize this window using the handles in the bottom corners,"
				.. " and move it by clicking and dragging on the title bar at the top.",
		},
	},
}

local function CheckNoteWithIdExists(id)
	if NotesDB.notes[id] == nil then
		error("A note with an ID of `" .. id .. "` does not exist.")
	end
end

local function GetNoteIds()
	local ids = {}

	for _, note in ipairs(NotesDB.notes) do
		table.insert(ids, note.id)
	end

	return ids
end

local function sortNotesByTitleAscending()
	table.sort(NotesDB.notes, function(a, b)
		return a.title < b.title
	end)
end

function Database:Initialize()
	if NotesDB == nil then
		NotesDB = initialDatabaseState
	end

	if not NotesLDBIconDB then
		NotesLDBIconDB = { hide = false }
	end
end

function Database:GetInitialSize()
	return initialDatabaseState.config.size
end

function Database:GetInitialPoint()
	return initialDatabaseState.config.point
end

function Database:GetSize()
	return NotesDB.config.size
end

function Database:SetSize(size)
	addon.Utilities:CheckType(size, "table")
	addon.Utilities:CheckType(size.width, "number")
	addon.Utilities:CheckType(size.height, "number")

	NotesDB.config.size = {
		width = size.width,
		height = size.height,
	}
end

function Database:GetPoint()
	return NotesDB.config.point
end

function Database:SetPoint(point)
	addon.Utilities:CheckType(point, "table")
	addon.Utilities:CheckType(point.anchorPoint, "string")
	addon.Utilities:CheckType(point.relativeTo, "nil")
	addon.Utilities:CheckType(point.relativePoint, "string")
	addon.Utilities:CheckType(point.xOffset, "number")
	addon.Utilities:CheckType(point.yOffset, "number")

	NotesDB.config.point = {
		anchorPoint = point.anchorPoint,
		relativeTo = point.relativeTo,
		relativePoint = point.relativePoint,
		xOffset = point.xOffset,
		yOffset = point.yOffset,
	}
end

function Database:GetFont()
	return NotesDB.config.font
end

function Database:SetFont(font)
	addon.Utilities:CheckType(font, "string")
	NotesDB.config.font = font
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

function Database:CreateNote(title)
	addon.Utilities:CheckType(title, "string")
	if #title > addon.Constants.NOTE_TITLE_MAX_LENGTH then
		error("A note title must not be longer than " .. addon.Constants.NOTE_TITLE_MAX_LENGTH .. " characters.")
	end

	local noteIds = GetNoteIds()

	local id = 1

	while addon.Utilities:TableContainsValue(noteIds, id) do
		id = id + 1
	end

	local newNote = {
		id = id,
		title = title,
		body = "",
	}

	table.insert(NotesDB.notes, newNote)

	sortNotesByTitleAscending()

	return newNote
end

function Database:GetCurrentNote()
	return NotesDB.notes[NotesDB.currentNoteId]
end

function Database:GetNotes()
	return NotesDB.notes
end

function Database:GetNoteById(noteId)
	addon.Utilities:CheckType(noteId, "number")

	for _, note in ipairs(NotesDB.notes) do
		if note.id == noteId then
			return note
		end
	end

	error("A note with the ID `" .. noteId .. "` does not exist.")
end

function Database:SetCurrentNoteId(noteId)
	addon.Utilities:CheckType(noteId, "number", "nil")

	if noteId ~= nil then
		CheckNoteWithIdExists(noteId)
	end

	NotesDB.currentNoteId = noteId
end

function Database:SetNoteTitle(noteId, newTitle)
	addon.Utilities:CheckType(noteId, "number")
	addon.Utilities:CheckType(newTitle, "string")

	local note = self:GetNoteById(noteId)
	note.title = newTitle

	sortNotesByTitleAscending()
end

function Database:SetNoteBody(noteId, newBody)
	addon.Utilities:CheckType(noteId, "number")
	addon.Utilities:CheckType(newBody, "string")

	local note = self:GetNoteById(noteId)
	note.body = newBody
end

function Database:DeleteNote(noteId)
	addon.Utilities:CheckType(noteId, "number")
	CheckNoteWithIdExists(noteId)

	for index, note in ipairs(NotesDB.notes) do
		if note.id == noteId then
			table.remove(NotesDB.notes, index)
			break
		end
	end
end

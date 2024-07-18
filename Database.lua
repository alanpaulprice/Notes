local addonName, addon = ...

addon.Database = {}
local Database = addon.Database

local initialDatabaseState = {
	options = {
		size = {
			width = addon.Constants.DEFAULT_UI_WIDTH,
			height = addon.Constants.DEFAULT_UI_HEIGHT,
		},
		point = {
			anchorPoint = "CENTER",
			relativeTo = nil,
			relativePoint = "CENTER",
			xOffset = 0,
			yOffset = 0,
		},
		locked = false,
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
			body = " You can navigate to the 'Manage' view via the button below, labeled 'Manage Notes'."
				.. " From there, you can:"
				.. "\n\n"
				.. "- View all notes."
				.. "\n"
				.. "- Create a note."
				.. "\n"
				.. "- Edit the title of a note."
				.. "\n"
				.. "- Delete a note."
				.. "\n\n"
				.. "Right-click a note to open a menu that will enable you to edit it's title or delete it."
				.. "\n\n"
				.. "You can resize this window using the handles in the bottom corners,"
				.. " and move it by clicking and dragging on the title bar at the top.",
		},
	},
}

local function CheckNoteWithIdExists(noteId)
	addon.Utilities:CheckType(noteId, "number")

	for _, note in ipairs(NotesDB.notes) do
		if note.id == noteId then
			return
		end
	end

	error("A note with an ID of `" .. noteId .. "` does not exist.")
end

local function GetNoteIds()
	local ids = {}

	for _, note in ipairs(NotesDB.notes) do
		table.insert(ids, note.id)
	end

	return ids
end

-- Returns the original/reference, only intended for use in 'update' database functions.
local function GetNoteById(noteId)
	addon.Utilities:CheckType(noteId, "number")

	for _, note in ipairs(NotesDB.notes) do
		if note.id == noteId then
			return note
		end
	end

	error("A note with the ID `" .. noteId .. "` does not exist.")
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
end

function Database:GetSize()
	return addon.Utilities:CloneTable(NotesDB.options.size)
end

function Database:GetWidth()
	return NotesDB.options.size.width
end

function Database:SetWidth(width)
	addon.Utilities:CheckNumberIsWithinBounds(width, addon.Constants.MIN_UI_WIDTH, addon.Constants.MAX_UI_WIDTH)
	width = addon.Utilities:RoundNumberDecimal(width, 10, true) -- A frame width has a maximum of 10 decimal places.
	NotesDB.options.size.width = width
end

function Database:GetHeight()
	return NotesDB.options.size.height
end

function Database:SetHeight(height)
	addon.Utilities:CheckNumberIsWithinBounds(height, addon.Constants.MIN_UI_HEIGHT, addon.Constants.MAX_UI_HEIGHT)
	height = addon.Utilities:RoundNumberDecimal(height, 10, true) -- A frame height has a maximum of 10 decimal places.
	NotesDB.options.size.height = height
end

function Database:GetPoint()
	return NotesDB.options.point
end

function Database:SetPoint(point)
	addon.Utilities:CheckType(point, "table")
	addon.Utilities:CheckType(point.anchorPoint, "string")
	addon.Utilities:CheckType(point.relativeTo, "nil")
	addon.Utilities:CheckType(point.relativePoint, "string")
	addon.Utilities:CheckType(point.xOffset, "number")
	addon.Utilities:CheckType(point.yOffset, "number")

	NotesDB.options.point = {
		anchorPoint = point.anchorPoint,
		relativeTo = point.relativeTo,
		relativePoint = point.relativePoint,
		xOffset = addon.Utilities:RoundNumberDecimal(point.xOffset, 12, true), -- Frame point offset values have a
		yOffset = addon.Utilities:RoundNumberDecimal(point.yOffset, 12, true), -- maximum of 12 decimal places.
	}
end

function Database:GetLocked()
	return NotesDB.options.locked
end

function Database:SetLocked(locked)
	addon.Utilities:CheckType(locked, "boolean")
	NotesDB.options.locked = locked
end

-- This is intentionally returning the original/reference, which allows LibDBIcon to manipulate it.
function Database:GetMinimapButtonForLibDBIcon()
	return NotesDB.options.minimapButton
end

function Database:GetFont()
	return NotesDB.options.font
end

function Database:SetFont(font)
	addon.Utilities:CheckType(font, "string")
	NotesDB.options.font = font
end

function Database:GetMinimapButtonHidden()
	return NotesDB.options.minimapButton.hide
end

function Database:SetMinimapButtonHidden(input)
	addon.Utilities:CheckType(input, "boolean")
	NotesDB.options.minimapButton.hide = input
end

function Database:GetShowAtLogin()
	return NotesDB.options.showAtLogin
end

function Database:SetShowAtLogin(input)
	addon.Utilities:CheckType(input, "boolean")
	NotesDB.options.showAtLogin = input
end

function Database:GetCurrentNoteId()
	return NotesDB.currentNoteId
end

function Database:SetCurrentNoteId(noteId)
	addon.Utilities:CheckType(noteId, "number", "nil")

	if noteId ~= nil then
		CheckNoteWithIdExists(noteId)
	end

	NotesDB.currentNoteId = noteId
end

function Database:GetCurrentNote()
	if self:GetCurrentNoteId() ~= nil then
		return addon.Utilities:CloneTable(GetNoteById(self:GetCurrentNoteId()))
	else
		return nil
	end
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

	return addon.Utilities:CloneTable(newNote)
end

function Database:GetNotes()
	return addon.Utilities:CloneTable(NotesDB.notes)
end

function Database:SetNoteTitle(noteId, newTitle)
	addon.Utilities:CheckType(noteId, "number")
	addon.Utilities:CheckType(newTitle, "string")

	local note = GetNoteById(noteId)
	note.title = newTitle

	sortNotesByTitleAscending()
end

function Database:SetNoteBody(noteId, newBody)
	addon.Utilities:CheckType(noteId, "number")
	addon.Utilities:CheckType(newBody, "string")

	local note = GetNoteById(noteId)
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

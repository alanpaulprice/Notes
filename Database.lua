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
	currentNoteId = nil,
	note = "",
	notes = {
		{
			id = 1,
			title = "Lorem Ipsum Dolor",
			body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum accumsan mattis nibh, eget imperdiet odio vulputate sit amet. Maecenas vel elit pharetra nisi vulputate semper non vitae sapien. Nulla facilisi. Curabitur sapien libero, rutrum non justo sit amet, ultricies facilisis purus. Suspendisse commodo diam vitae nulla lobortis, sit amet pharetra libero mollis. Sed dapibus suscipit neque, in ultrices turpis suscipit in. Etiam sodales, risus eget rutrum scelerisque, enim odio gravida ipsum, ut molestie nibh dolor nec purus. Nunc eros ligula, faucibus nec dolor vel, porttitor mollis arcu.",
		},
		{
			id = 2,
			title = "Sit Amet Consectetur",
			body = "In porta ante elementum ipsum volutpat, a auctor risus tempus. Maecenas vel rhoncus dolor. Phasellus odio tellus, finibus nec augue eget, vestibulum euismod felis. Sed consequat leo ut bibendum gravida. Fusce mollis posuere erat, ac mollis sapien malesuada nec. Donec lobortis ante sed interdum ullamcorper. Praesent non ante porta quam imperdiet consequat. Sed in congue nisi, a interdum magna.",
		},
		{
			id = 3,
			title = "Adipiscing Elit Vestibulum",
			body = "Aliquam sagittis interdum lacus vel rhoncus. Sed risus sapien, facilisis sit amet varius vitae, gravida in dolor. Praesent eu nunc at massa sollicitudin condimentum. Nulla non elit eget nisi faucibus mollis vel non nunc. Cras porttitor, dolor non maximus interdum, ex libero malesuada velit, nec luctus nunc nunc at massa. Etiam velit est, cursus ut hendrerit ac, efficitur vitae risus. Donec nulla diam, consequat eu magna ut, gravida pellentesque sem. Donec in imperdiet orci. Suspendisse eget arcu vitae elit luctus rhoncus quis vitae urna. Vestibulum in suscipit justo, non porta ex. Phasellus scelerisque eros et placerat gravida. Aliquam sapien dolor, dignissim in tristique eget, fringilla et justo.",
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

local addonName, addon = ...
addon.Database = {}
local Database = addon.Database

MyAddon = LibStub("AceAddon-3.0"):NewAddon("DBExample")

local defaults = {
	profile = {
		size = {
			width = addon.Constants.DEFAULT_MAIN_UI_WIDTH,
			height = addon.Constants.DEFAULT_MAIN_UI_HEIGHT,
		},
		point = {
			anchorPoint = "CENTER",
			relativeTo = nil,
			relativePoint = "CENTER",
			xOffset = 0,
			yOffset = 0,
		},
		minimapButton = {
			hide = false,
		},
		showAtLogin = false,
		resizeEnabled = true,
		editViewFontSize = 14,
		editViewFont = "Fonts\\ARIALN.TTF",
	},
	char = {
		currentNoteId = 1,
		currentView = addon.Constants.UI_VIEW_ENUM.EDIT,
	},
	global = {
		notes = {
			{
				id = 1,
				title = "Getting Started",
				body = "You can navigate to the 'Manage' view via the button below, labeled 'Manage Notes'."
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
	},
}

local function CheckNoteWithIdExists(noteId)
	addon.Utilities:CheckType(noteId, "number")

	for _, note in ipairs(addon.Database.data.global.notes) do
		if note.id == noteId then
			return
		end
	end

	error("A note with an ID of `" .. noteId .. "` does not exist.")
end

local function GetNoteIds()
	local ids = {}

	for _, note in ipairs(addon.Database.data.global.notes) do
		table.insert(ids, note.id)
	end

	return ids
end

-- Returns the original/reference, only intended for use in 'update' database functions.
local function GetNoteById(noteId)
	addon.Utilities:CheckType(noteId, "number")

	for _, note in ipairs(Database.data.global.notes) do
		if note.id == noteId then
			return note
		end
	end

	error("A note with the ID `" .. noteId .. "` does not exist.")
end

local function sortNotesByTitleAscending()
	table.sort(Database.data.global.notes, function(a, b)
		return a.title < b.title
	end)
end

function Database:Initialize()
	self.data = LibStub("AceDB-3.0"):New("NotesDB", defaults, true)
end

function Database:GetCurrentView()
	return self.data.char.currentView
end

function Database:SetCurrentView(input)
	addon.Utilities:CheckIsEnumMember(input, addon.Constants.UI_VIEW_ENUM)
	self.data.char.currentView = input
end

function Database:GetCurrentNoteId()
	return self.data.char.currentNoteId
end

function Database:SetCurrentNoteId(noteId)
	addon.Utilities:CheckType(noteId, "number", "nil")

	if noteId ~= nil then
		CheckNoteWithIdExists(noteId)
	end

	self.data.char.currentNoteId = noteId
end

function Database:GetNotes()
	return addon.Utilities:CloneTable(self.data.global.notes)
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

	table.insert(addon.Database.data.global.notes, newNote)

	sortNotesByTitleAscending()

	return addon.Utilities:CloneTable(newNote)
end

function Database:DeleteNote(noteId)
	addon.Utilities:CheckType(noteId, "number")
	CheckNoteWithIdExists(noteId)

	for index, note in ipairs(self.data.global.notes) do
		if note.id == noteId then
			table.remove(self.data.global.notes, index)
			break
		end
	end
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

function Database:GetWidth()
	return self.data.profile.size.width
end

function Database:SetWidth(width)
	addon.Utilities:CheckNumberIsWithinBounds(width, addon.Constants.MIN_UI_WIDTH, addon.Constants.MAX_UI_WIDTH)
	self.data.profile.size.width = width
end

function Database:GetHeight()
	return self.data.profile.size.height
end

function Database:SetHeight(height)
	addon.Utilities:CheckNumberIsWithinBounds(height, addon.Constants.MIN_UI_HEIGHT, addon.Constants.MAX_UI_HEIGHT)
	self.data.profile.size.height = height
end

function Database:GetShowAtLogin()
	return self.data.profile.showAtLogin
end

function Database:SetShowAtLogin(input)
	addon.Utilities:CheckType(input, "boolean")
	self.data.profile.showAtLogin = input
end

--* Editing the returned value will affect the value stored in the database.
function Database:GetUnclonedMinimapButton()
	return self.data.profile.minimapButton
end

function Database:GetMinimapButtonHidden()
	return self.data.profile.minimapButton.hide
end

function Database:SetMinimapButtonHidden(input)
	addon.Utilities:CheckType(input, "boolean")
	self.data.profile.minimapButton.hide = input
end

function Database:GetResizeEnabled()
	return self.data.profile.resizeEnabled
end

function Database:SetResizeEnabled(input)
	addon.Utilities:CheckType(input, "boolean")
	self.data.profile.resizeEnabled = input
end

function Database:GetEditViewFont()
	return self.data.profile.editViewFont
end

function Database:SetEditViewFont(input)
	addon.Utilities:CheckType(input, "string")
	self.data.profile.editViewFont = input
end

function Database:SetEditViewFontSize(input)
	addon.Utilities:CheckType(input, "number")
	self.data.profile.editViewFontSize = input
end

function Database:GetEditViewFontSize()
	return self.data.profile.editViewFontSize
end

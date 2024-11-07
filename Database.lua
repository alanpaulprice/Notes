local addonName, addon = ...
addon.Database = {}
local Database = addon.Database

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
	self.data = LibStub("AceDB-3.0"):New(addonName .. "DB", addon.Constants.DEFAULT_DATABASE_DEFAULTS, true)
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

--* Editing the returned value will affect the value stored in the database.
function Database:GetUnclonedMainUiStatus()
	return self.data.profile.mainUiStatus
end

function Database:GetWidth()
	return self.data.profile.mainUiStatus.width
end

function Database:SetWidth(width)
	width = addon.Utilities:ClampNumber(width, addon.Constants.MIN_UI_WIDTH, nil)
	self.data.profile.mainUiStatus.width = width
end

function Database:GetHeight()
	return self.data.profile.mainUiStatus.height
end

function Database:SetHeight(height)
	height = addon.Utilities:ClampNumber(height, addon.Constants.MIN_UI_HEIGHT, nil)
	self.data.profile.mainUiStatus.height = height
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

function Database:GetClampedToScreen()
	return self.data.profile.clampedToScreen
end

function Database:SetClampedToScreen(input)
	addon.Utilities:CheckType(input, "boolean")
	self.data.profile.clampedToScreen = input
end

function Database:GetEditViewFontSize()
	return self.data.profile.editViewFontSize
end

function Database:SetEditViewFontSize(input)
	addon.Utilities:CheckType(input, "number")
	self.data.profile.editViewFontSize = input
end

function Database:GetEditViewFont()
	return self.data.profile.editViewFont
end

function Database:SetEditViewFont(input)
	addon.Utilities:CheckType(input, "string")
	self.data.profile.editViewFont = input
end

function Database:GetListViewFontSize()
	return self.data.profile.listViewFontSize
end

function Database:SetListViewFontSize(input)
	addon.Utilities:CheckType(input, "number")
	self.data.profile.listViewFontSize = input
end

function Database:GetListViewFont()
	return self.data.profile.listViewFont
end

function Database:SetListViewFont(input)
	addon.Utilities:CheckType(input, "string")
	self.data.profile.listViewFont = input
end

function Database:SetListViewSpacing(input)
	addon.Utilities:CheckType(input, "number")
	self.data.profile.listViewSpacing = input
end

function Database:GetListViewSpacing()
	return self.data.profile.listViewSpacing
end

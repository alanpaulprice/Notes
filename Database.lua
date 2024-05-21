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
			x = 0,
			y = 0,
		},
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

function Database:GetSize()
	return NotesDB.config.size
end

function Database:SetSize(input)
	addon.Utilities:CheckType(input, "table")
	addon.Utilities:CheckType(input.width, "number")
	addon.Utilities:CheckType(input.height, "number")

	NotesDB.config.size = {
		width = input.width,
		height = input.height,
	}
end

function Database:GetPoint()
	return NotesDB.config.point
end

function Database:SetPoint(input)
	addon.Utilities:CheckType(input, "table")
	addon.Utilities:CheckType(input.anchorPoint, "string")
	addon.Utilities:CheckType(input.relativeTo, "nil")
	addon.Utilities:CheckType(input.relativePoint, "string")
	addon.Utilities:CheckType(input.xOffset, "number")
	addon.Utilities:CheckType(input.yOffset, "number")

	NotesDB.config.point = {
		anchorPoint = input.anchorPoint,
		relativeTo = input.relativeTo,
		relativePoint = input.relativePoint,
		xOffset = input.xOffset,
		yOffset = input.yOffset,
	}
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

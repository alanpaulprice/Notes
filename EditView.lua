local addonName, addon = ...
addon.EditView = {}
local EditView = addon.EditView

local function UpdateText()
	local note = addon.Database:GetCurrentNote()
	EditView.Frame.ScrollingEditBox.ScrollBox.EditBox:SetText(note.body)
end

local function CreateRootFrame()
	EditView.Frame = CreateFrame("Frame", addonName .. "_EditView", addon.UI.Frame.ViewContainer, nil)
	EditView.Frame:SetAllPoints(addon.UI.Frame.ViewContainer)

	if addon.Database:GetCurrentNoteId() == nil then
		EditView.Frame:Hide()
	end
end

local function CreateScrollingEditBox()
	EditView.Frame.ScrollingEditBox = CreateFrame("Frame", nil, EditView.Frame, "ScrollingEditBoxTemplate")
	EditView.Frame.ScrollingEditBox:SetPoint("TOPLEFT", EditView.Frame, "TOPLEFT", 0, 0)
	EditView.Frame.ScrollingEditBox:SetPoint("BOTTOMRIGHT", EditView.Frame, "BOTTOMRIGHT", -17, 0)
	EditView.Frame.ScrollingEditBox.ScrollBox.EditBox:SetFontObject(addon.Database:GetFont())
	EditView.Frame.ScrollingEditBox.ScrollBox.EditBox:SetTextInsets(8, 8, 8, 8)

	local currentNote = addon.Database:GetCurrentNote()

	if currentNote ~= nil then
		UpdateText(currentNote.body)
	end

	local function OnTextChange(owner, editBox, userChanged)
		addon.Database:SetNoteBody(addon.Database:GetCurrentNoteId(), editBox:GetInputText())
	end
	EditView.Frame.ScrollingEditBox:RegisterCallback("OnTextChanged", OnTextChange, self)
end

local function CreateScrollBar()
	EditView.Frame.ScrollBar = CreateFrame("EventFrame", nil, EditView.Frame, "MinimalScrollBar")
	EditView.Frame.ScrollBar:SetPoint("TOPLEFT", EditView.Frame.ScrollingEditBox, "TOPRIGHT", 0, -4)
	EditView.Frame.ScrollBar:SetPoint("BOTTOMLEFT", EditView.Frame.ScrollingEditBox, "BOTTOMRIGHT", 0, 4)

	ScrollUtil.RegisterScrollBoxWithScrollBar(EditView.Frame.ScrollingEditBox.ScrollBox, EditView.Frame.ScrollBar)
end

function EditView:Initialize()
	CreateRootFrame()
	CreateScrollingEditBox()
	CreateScrollBar()
end

function EditView:Show()
	UpdateText()
	EditView.Frame:Show()
end

function EditView:Hide()
	EditView.Frame:Hide()
end

function EditView:SetFont(font)
	EditView.Frame.ScrollingEditBox.ScrollBox.EditBox:SetFontObject(font)
end

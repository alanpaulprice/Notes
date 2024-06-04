local addonName, addon = ...
addon.EditView = {}
local EditView = addon.EditView

local function SetText(text)
	EditView.Frame.ScrollingEditBox.ScrollBox.EditBox:SetText(text)
end

local function CreateRootFrame()
	EditView.Frame = CreateFrame("Frame", addonName .. "_EditView", addon.UI.Frame.ViewContainer, nil)
	EditView.Frame:SetAllPoints(addon.UI.Frame.ViewContainer)

	if addon.Database:GetCurrentNote() == nil then
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
		SetText(currentNote.body)
	end

	local function OnTextChange(owner, editBox, userChanged)
		addon.Database:SetNoteBody(addon.Database:GetCurrentNote().id, editBox:GetInputText())
	end
	-- EditView.Frame.ScrollingEditBox:RegisterCallback("OnTextChanged", OnTextChange, self)
	EditView.Frame.ScrollingEditBox:RegisterCallback("OnTextChanged", OnTextChange, EditView.ScrollingEditBox)
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
	local note = addon.Database.GetCurrentNote()
	SetText(note.body)
	EditView.Frame:Show()
end

function EditView:Hide()
	EditView.Frame:Hide()
end

local addonName, addon = ...
addon.EditView = {}
local EditView = addon.EditView

local AceGUI = LibStub("AceGUI-3.0")

local function UpdateEditBoxText()
	local note = addon.Database:GetCurrentNote()
	EditView.EditBox:SetText(note.body)
end

function EditView:Build(container)
	EditView.EditBox = AceGUI:Create("MultiLineEditBox")
	EditView.EditBox:SetLabel("")
	EditView.EditBox:DisableButton(true)
	EditView.EditBox:SetFullHeight(true)
	EditView.EditBox:SetFullWidth(true)
	EditView.EditBox.editBox:SetTextInsets(8, 8, 8, 8)
	local _, _, fontFlags = EditView.EditBox.editBox:GetFontObject():GetFont()
	EditView.EditBox.editBox:SetFont(
		AceGUIWidgetLSMlists.font[addon.Database:GetEditViewFont()],
		addon.Database:GetEditViewFontSize(),
		fontFlags
	)
	EditView.EditBox:SetCallback("OnTextChanged", function(_, _, text)
		addon.Database:SetNoteBody(addon.Database:GetCurrentNoteId(), text)
	end)
	UpdateEditBoxText()
	container:AddChild(EditView.EditBox)
end

function EditView:UpdateFontSize(fontSize)
	addon.Database:SetEditViewFontSize(fontSize)

	if self.EditBox and self.EditBox:IsShown() then
		local fontName, _, fontFlags = EditView.EditBox.editBox:GetFontObject():GetFont()
		EditView.EditBox.editBox:SetFont(fontName, fontSize, fontFlags)
	end
end

function EditView:UpdateFont(font)
	addon.Database:SetEditViewFont(font)

	if self.EditBox and self.EditBox:IsShown() then
		local _, fontSize, fontFlags = EditView.EditBox.editBox:GetFontObject():GetFont()
		EditView.EditBox.editBox:SetFont(AceGUIWidgetLSMlists.font[font], fontSize, fontFlags)
	end
end

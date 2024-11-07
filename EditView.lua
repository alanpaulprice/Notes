local addonName, addon = ...
addon.EditView = {}
local EditView = addon.EditView

local AceGUI = LibStub("AceGUI-3.0")

local function UpdateEditBoxText()
	local note = addon.Database:GetCurrentNote()
	EditView.editBox:SetText(note.body)
end

function EditView:Build(container)
	EditView.editBox = AceGUI:Create("MultiLineEditBox")
	EditView.editBox:SetLabel("")
	EditView.editBox:DisableButton(true)
	EditView.editBox:SetFullHeight(true)
	EditView.editBox:SetFullWidth(true)
	EditView.editBox.editBox:SetTextInsets(8, 8, 8, 8)
	local _, _, fontFlags = EditView.editBox.editBox:GetFontObject():GetFont()
	EditView.editBox.editBox:SetFont(
		AceGUIWidgetLSMlists.font[addon.Database:GetEditViewFont()],
		addon.Database:GetEditViewFontSize(),
		fontFlags
	)
	EditView.editBox:SetCallback("OnTextChanged", function(_, _, text)
		addon.Database:SetNoteBody(addon.Database:GetCurrentNoteId(), text)
	end)
	UpdateEditBoxText()
	container:AddChild(EditView.editBox)
end

function EditView:UpdateFontSize(fontSize)
	addon.Database:SetEditViewFontSize(fontSize)

	if self.editBox and self.editBox:IsShown() then
		local fontName, _, fontFlags = self.editBox.editBox:GetFontObject():GetFont()
		self.editBox.editBox:SetFont(fontName, fontSize, fontFlags)
	end

	AceConfigRegistry:NotifyChange(addonName)
end

function EditView:UpdateFont(font)
	addon.Database:SetEditViewFont(font)

	if self.editBox and self.editBox:IsShown() then
		local _, fontSize, fontFlags = self.editBox.editBox:GetFontObject():GetFont()
		self.editBox.editBox:SetFont(AceGUIWidgetLSMlists.font[font], fontSize, fontFlags)
	end
end

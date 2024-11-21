local addonName, addon = ...
addon.EditView = {}
local EditView = addon.EditView

local AceGUI = LibStub("AceGUI-3.0")

local editBox = nil

function EditView:Build(container)
	editBox = AceGUI:Create("MultiLineEditBox")
	editBox:SetLabel("")
	editBox:DisableButton(true)
	editBox:SetFullHeight(true)
	editBox:SetFullWidth(true)
	editBox:SetText(addon.Database:GetCurrentNote().body)
	editBox.editBox:SetTextInsets(8, 8, 8, 8)
	local _, _, fontFlags = editBox.editBox:GetFontObject():GetFont()
	editBox.editBox:SetFont(
		AceGUIWidgetLSMlists.font[addon.Database:GetEditViewFont()],
		addon.Database:GetEditViewFontSize(),
		fontFlags
	)
	editBox:SetCallback("OnTextChanged", function(_, _, text)
		addon.Database:SetNoteBody(addon.Database:GetCurrentNoteId(), text)
	end)
	container:AddChild(editBox)
end

function EditView:UpdateFontSize(fontSize)
	addon.Database:SetEditViewFontSize(fontSize)

	if editBox and editBox:IsShown() then
		local fontName, _, fontFlags = editBox.editBox:GetFontObject():GetFont()
		editBox.editBox:SetFont(fontName, fontSize, fontFlags)
	end
end

function EditView:UpdateFont(font)
	addon.Database:SetEditViewFont(font)

	if editBox and editBox:IsShown() then
		local _, fontSize, fontFlags = editBox.editBox:GetFontObject():GetFont()
		editBox.editBox:SetFont(AceGUIWidgetLSMlists.font[font], fontSize, fontFlags)
	end
end

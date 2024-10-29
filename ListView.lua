local addonName, addon = ...
addon.ListView = {}
local ListView = addon.ListView

local AceGUI = LibStub("AceGUI-3.0")

local function BuildEmptyMessage(container)
	addon.Utilities:AddAceGuiLabelSpacer(container, 16)

	local label = AceGUI:Create("Label")
	label:SetFullWidth(true)
	label:SetJustifyH("CENTER")
	label:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	label:SetText("You do not have any notes.\n\nCreate one via the 'Manage' tab.")
	container:AddChild(label)
end

local function BuildList(container, notes)
	local currentNoteId = addon.Database:GetCurrentNoteId()

	local simpleGroup = AceGUI:Create("SimpleGroup")
	simpleGroup:SetFullWidth(true)
	simpleGroup:SetFullHeight(true)
	simpleGroup:SetLayout("Fill")
	container:AddChild(simpleGroup)

	local scrollFrame = AceGUI:Create("ScrollFrame")
	scrollFrame:SetLayout("List")
	simpleGroup:AddChild(scrollFrame)

	for _, note in ipairs(notes) do
		addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, 12)

		local iLabel = AceGUI:Create("InteractiveLabel")
		iLabel:SetFullWidth(true)
		local fontName, fontHeight, fontFlags = iLabel.label:GetFontObject():GetFont()
		iLabel:SetFont(fontName, 14, fontFlags)

		if note.id == currentNoteId then
			iLabel:SetColor(GameFontNormalLarge:GetTextColor())
		end

		iLabel:SetText(note.title)
		-- iLabel:SetHighlight("interface\\buttons\\ui-listbox-highlight2.blp") -- "interface\\buttons\\ui-listbox-highlight.blp"
		iLabel:SetHighlight("interface\\buttons\\ui-listbox-highlight.blp") -- "interface\\buttons\\ui-listbox-highlight2.blp"
		scrollFrame:AddChild(iLabel)

		iLabel:SetCallback("OnClick", function(widget, event, button)
			addon.Database:SetCurrentNoteId(note.id)
			addon.MainUi:UpdateTabs()
			addon.MainUi:UpdateStatusText()
			addon.MainUi:ChangeView(addon.Constants.UI_VIEW_ENUM.EDIT)
		end)
	end

	addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, 12)
end

function ListView:Build(container)
	local notes = addon.Database:GetNotes()

	if #notes == 0 then
		BuildEmptyMessage(container)
	else
		BuildList(container, notes)
	end
end

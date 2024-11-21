local addonName, addon = ...
addon.ListView = {}
local ListView = addon.ListView

local AceGUI = LibStub("AceGUI-3.0")

local scrollFrame = nil

local function BuildEmptyMessage(container)
	addon.Utilities:AddAceGuiLabelSpacer(container, 16)

	local label = AceGUI:Create("Label")
	label:SetFullWidth(true)
	label:SetJustifyH("CENTER")
	local font, _, fontFlags = label.label:GetFontObject():GetFont()
	label:SetFont(font, 16, fontFlags)
	label:SetText("You do not have any notes.\n\nCreate one via the 'Manage' tab.")
	container:AddChild(label)
end

local function BuildListItems()
	local notes = addon.Database:GetNotes()
	local currentNoteId = addon.Database:GetCurrentNoteId()
	local spacing = addon.Database:GetListViewSpacing()

	if spacing > 0 then
		addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, spacing / 2)
	end

	for index, note in ipairs(notes) do
		if index > 1 and spacing > 0 then
			addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, spacing)
		end

		local iLabel = AceGUI:Create("InteractiveLabel")
		iLabel:SetFullWidth(true)
		local _, _, fontFlags = iLabel.label:GetFontObject():GetFont()
		iLabel:SetFont(
			AceGUIWidgetLSMlists.font[addon.Database:GetListViewFont()],
			addon.Database:GetListViewFontSize(),
			fontFlags
		)

		if note.id == currentNoteId then
			iLabel:SetColor(GameFontNormalLarge:GetTextColor())
		end

		iLabel:SetText(note.title)
		iLabel:SetHighlight("interface\\buttons\\ui-listbox-highlight.blp") -- "interface\\buttons\\ui-listbox-highlight2.blp"
		scrollFrame:AddChild(iLabel)

		iLabel:SetCallback("OnClick", function()
			addon.Database:SetCurrentNoteId(note.id)
			addon.MainUi:UpdateTabs()
			addon.MainUi:UpdateStatusText()
			addon.MainUi:ChangeView(addon.Constants.UI_VIEW_ENUM.EDIT)
		end)
	end

	if spacing > 0 then
		addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, spacing / 2)
	end
end

local function RebuildListItems()
	if scrollFrame and scrollFrame:IsShown() then
		scrollFrame:ReleaseChildren()
		BuildListItems()
	end
end

local function BuildList(container)
	local simpleGroup = AceGUI:Create("SimpleGroup")
	simpleGroup:SetFullWidth(true)
	simpleGroup:SetFullHeight(true)
	simpleGroup:SetLayout("Fill")
	container:AddChild(simpleGroup)

	scrollFrame = AceGUI:Create("ScrollFrame")
	scrollFrame:SetLayout("List")
	simpleGroup:AddChild(scrollFrame)

	BuildListItems()
end

function ListView:Build(container)
	local notes = addon.Database:GetNotes()

	if #notes == 0 then
		BuildEmptyMessage(container)
	else
		BuildList(container)
	end
end

function ListView:UpdateFontSize(fontSize)
	addon.Database:SetListViewFontSize(fontSize)
	RebuildListItems()
end

function ListView:UpdateFont(font)
	addon.Database:SetListViewFont(font)
	RebuildListItems()
end

function ListView:UpdateSpacing(spacing)
	addon.Database:SetListViewSpacing(spacing)
	RebuildListItems()
end

local addonName, addon = ...
addon.ManageView = {}
local ManageView = addon.ManageView

local AceGUI = LibStub("AceGUI-3.0")

local function UpdateDropdownLists()
	local dropdownList = {}
	local notes = addon.Database:GetNotes()

	for _, note in ipairs(notes) do
		dropdownList[note] = note.title
	end

	ManageView.RenameDropdown:SetList(dropdownList)
	ManageView.DeleteDropdown:SetList(dropdownList)
end

local function CreateNote()
	local note = addon.Database:CreateNote(ManageView.CreateEditBox:GetText())
	addon.Database:SetCurrentNoteId(note.id)
	addon.MainUi:UpdateStatusText()
	addon.MainUi:ChangeView(addon.Constants.UI_VIEW_ENUM.EDIT)
end

local function BuildCreateControl(container)
	ManageView.CreateGroup = AceGUI:Create("SimpleGroup")
	ManageView.CreateGroup:SetLayout("List")
	ManageView.CreateGroup:SetFullWidth(true)
	container:AddChild(ManageView.CreateGroup)

	ManageView.CreateEditBox = AceGUI:Create("EditBox")
	ManageView.CreateEditBox:SetRelativeWidth(1)
	ManageView.CreateEditBox:SetLabel("Create a note")
	ManageView.CreateEditBox:DisableButton(true)
	ManageView.CreateEditBox:SetCallback("OnEnterPressed", CreateNote)
	ManageView.CreateEditBox:SetMaxLetters(addon.Constants.NOTE_TITLE_MAX_LENGTH)
	ManageView.CreateGroup:AddChild(ManageView.CreateEditBox)

	addon.Utilities:AddAceGuiLabelSpacer(ManageView.CreateGroup, 2)

	ManageView.CreateButton = AceGUI:Create("Button")
	ManageView.CreateButton:SetAutoWidth(true)
	ManageView.CreateButton:SetText("Create")
	ManageView.CreateButton:SetCallback("OnClick", CreateNote)
	ManageView.CreateGroup:AddChild(ManageView.CreateButton)
end

local function BuildRenameControl(container)
	local function RenameDropdownCallback(widget, event, note)
		StaticPopup_ShowCustomGenericInputBox({
			text = "Rename '" .. note.title .. "'",
			callback = function(newNoteTitle)
				addon.Database:SetNoteTitle(note.id, newNoteTitle)
				UpdateDropdownLists()
				addon.MainUi:UpdateStatusText()
			end,
			acceptText = "Save",
			maxLetters = addon.Constants.NOTE_TITLE_MAX_LENGTH,
			countInvisibleLetters = true,
		})

		widget:SetValue(nil)
	end

	ManageView.RenameDropdown = AceGUI:Create("Dropdown")
	ManageView.RenameDropdown:SetLabel("Rename a note")
	ManageView.RenameDropdown:SetCallback("OnValueChanged", RenameDropdownCallback)
	container:AddChild(ManageView.RenameDropdown)
end

local function BuildDeleteControl(container)
	local function DeleteDropdownCallback(widget, event, note)
		StaticPopup_ShowCustomGenericConfirmation({
			text = "Confirm deletion of '" .. note.title .. "'",
			callback = function()
				local currentNoteId = addon.Database:GetCurrentNoteId()

				addon.Database:DeleteNote(note.id)

				if note.id == currentNoteId then
					addon.Database:SetCurrentNoteId(nil)
					addon.MainUi:UpdateTabs()
				end

				UpdateDropdownLists()
				addon.MainUi:UpdateStatusText()
			end,
			acceptText = "Delete",
			cancelText = "Cancel",
		})

		widget:SetValue(nil)
	end

	ManageView.DeleteDropdown = AceGUI:Create("Dropdown")
	ManageView.DeleteDropdown:SetLabel("Delete a note")
	ManageView.DeleteDropdown:SetCallback("OnValueChanged", DeleteDropdownCallback)
	container:AddChild(ManageView.DeleteDropdown)
end

function ManageView:Build(container)
	BuildCreateControl(container)
	addon.Utilities:AddAceGuiLabelSpacer(container, 8)
	BuildRenameControl(container)
	addon.Utilities:AddAceGuiLabelSpacer(container, 8)
	BuildDeleteControl(container)
	UpdateDropdownLists()
end

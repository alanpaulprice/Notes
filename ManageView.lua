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
		local text = "Rename '" .. note.title .. "'"

		local function handleRename(newNoteTitle)
			addon.Database:SetNoteTitle(note.id, newNoteTitle)
			UpdateDropdownLists()
			addon.MainUi:UpdateStatusText()
		end

		addon.Utilities:RunCallbackForGameVersion({
			mainline = function()
				StaticPopup_ShowCustomGenericInputBox({
					text = text,
					callback = handleRename,
					acceptText = _G.SAVE,
					maxLetters = addon.Constants.NOTE_TITLE_MAX_LENGTH,
					countInvisibleLetters = true,
				})
			end,
			classic = function()
				local renameDialogName = string.upper(addonName) .. "_RENAME"

				StaticPopupDialogs[renameDialogName] = {
					text = text,
					button1 = _G.SAVE,
					button2 = _G.CANCEL,
					hasEditBox = 1,
					maxLetters = addon.Constants.NOTE_TITLE_MAX_LENGTH,
					OnAccept = function(self)
						local newNoteTitle = self.editBox:GetText()
						handleRename(newNoteTitle)
					end,
					EditBoxOnEnterPressed = function(self)
						local newNoteTitle = self:GetParent().editBox:GetText()
						handleRename(newNoteTitle)
						self:GetParent():Hide()
					end,
					EditBoxOnEscapePressed = function(self)
						self:GetParent():Hide()
					end,
					timeout = 0,
					whileDead = 1,
					hideOnEscape = 1,
				}

				StaticPopup_Show(renameDialogName)
			end,
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
		local text = "Are you sure you want to delete '" .. note.title .. "'?"

		local function handleDelete()
			print("handleDelete ran")
			local currentNoteId = addon.Database:GetCurrentNoteId()

			addon.Database:DeleteNote(note.id)

			if note.id == currentNoteId then
				addon.Database:SetCurrentNoteId(nil)
				addon.MainUi:UpdateTabs()
			end

			UpdateDropdownLists()
			addon.MainUi:UpdateStatusText()
		end

		addon.Utilities:RunCallbackForGameVersion({
			mainline = function()
				StaticPopup_ShowCustomGenericConfirmation({
					text = text,
					callback = handleDelete,
					acceptText = _G.DELETE,
					cancelText = _G.CANCEL,
				})
			end,
			classic = function()
				local deleteDialogName = string.upper(addonName) .. "_DELETE"

				StaticPopupDialogs[deleteDialogName] = {
					text = text,
					button1 = _G.DELETE,
					button2 = _G.CANCEL,
					OnAccept = handleDelete,
					timeout = 0,
					exclusive = 1,
					whileDead = 1,
					hideOnEscape = 1,
					showAlert = 1,
				}

				StaticPopup_Show(deleteDialogName)
			end,
		})

		widget:SetValue(nil)
	end

	ManageView.DeleteDropdown = AceGUI:Create("Dropdown")
	ManageView.DeleteDropdown:SetLabel("Delete a note")
	ManageView.DeleteDropdown:SetCallback("OnValueChanged", DeleteDropdownCallback)
	container:AddChild(ManageView.DeleteDropdown)
end

function ManageView:Build(container)
	local simpleGroup = AceGUI:Create("SimpleGroup")
	simpleGroup:SetFullWidth(true)
	simpleGroup:SetFullHeight(true)
	simpleGroup:SetLayout("Fill")
	container:AddChild(simpleGroup)

	local scrollFrame = AceGUI:Create("ScrollFrame")
	scrollFrame:SetLayout("List")
	simpleGroup:AddChild(scrollFrame)

	BuildCreateControl(scrollFrame)
	addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, 8)
	BuildRenameControl(scrollFrame)
	addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, 8)
	BuildDeleteControl(scrollFrame)
	addon.Utilities:AddAceGuiLabelSpacer(scrollFrame, 8)
	UpdateDropdownLists()
end

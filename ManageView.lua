local addonName, addon = ...
addon.ManageView = {}
local ManageView = addon.ManageView

local AceGUI = LibStub("AceGUI-3.0")

local renameDropdown = nil
local deleteDropdown = nil

local function UpdateDropdownLists()
	local dropdownList = {}
	local notes = addon.Database:GetNotes()

	for _, note in ipairs(notes) do
		dropdownList[note] = note.title
	end

	if renameDropdown then
		renameDropdown:SetList(dropdownList)
	end

	if deleteDropdown then
		deleteDropdown:SetList(dropdownList)
	end
end

local function BuildCreateControl(container)
	local function handleCreate(newNoteTitle)
		local note = addon.Database:CreateNote(newNoteTitle)
		addon.Database:SetCurrentNoteId(note.id)
		addon.MainUi:UpdateStatusText()
		addon.MainUi:UpdateTabs()
		addon.MainUi:ChangeView(addon.Constants.UI_VIEW_ENUM.EDIT)
	end

	local simpleGroup = AceGUI:Create("SimpleGroup")
	simpleGroup:SetLayout("List")
	simpleGroup:SetFullWidth(true)
	container:AddChild(simpleGroup)

	local createEditBox = AceGUI:Create("EditBox")
	createEditBox:SetRelativeWidth(1)
	createEditBox:SetLabel("Create a note")
	createEditBox:DisableButton(true)
	createEditBox:SetCallback("OnEnterPressed", function(self)
		handleCreate(self:GetText())
	end)
	createEditBox:SetMaxLetters(addon.Constants.NOTE_TITLE_MAX_LENGTH)
	simpleGroup:AddChild(createEditBox)

	addon.Utilities:AddAceGuiLabelSpacer(simpleGroup, 2)

	local createButton = AceGUI:Create("Button")
	createButton:SetAutoWidth(true)
	createButton:SetText("Create")
	createButton:SetCallback("OnClick", function()
		handleCreate(createEditBox:GetText())
	end)
	simpleGroup:AddChild(createButton)
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

	renameDropdown = AceGUI:Create("Dropdown")
	renameDropdown:SetLabel("Rename a note")
	renameDropdown:SetCallback("OnValueChanged", RenameDropdownCallback)
	container:AddChild(renameDropdown)
end

local function BuildDeleteControl(container)
	local function DeleteDropdownCallback(widget, event, note)
		local text = "Are you sure you want to delete '" .. note.title .. "'?"

		local function handleDelete()
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

	deleteDropdown = AceGUI:Create("Dropdown")
	deleteDropdown:SetLabel("Delete a note")
	deleteDropdown:SetCallback("OnValueChanged", DeleteDropdownCallback)
	container:AddChild(deleteDropdown)
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

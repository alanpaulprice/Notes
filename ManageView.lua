local addonName, addon = ...
addon.ManageView = {}
local ManageView = addon.ManageView

local dropDownMenuTarget = nil

local function UpdateScrollBoxList()
	local dataProvider = CreateDataProvider()
	local notes = addon.Database:GetNotes()

	for _, note in ipairs(notes) do
		dataProvider:Insert({ id = note.id, title = note.title })
	end

	ManageView.Frame.ScrollBoxList:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition)
end

local function CreateRootFrame()
	ManageView.Frame = CreateFrame("Frame", addonName .. "_ManageView", addon.UI.Frame.ViewContainer, nil)
	ManageView.Frame:SetAllPoints(addon.UI.Frame.ViewContainer)

	if addon.Database.GetCurrentNoteId() ~= nil then
		ManageView.Frame:Hide()
	end
end

local function CreateScrollBoxList()
	ManageView.Frame.ScrollBoxList = CreateFrame("Frame", nil, ManageView.Frame, "WowScrollBoxList")
	ManageView.Frame.ScrollBoxList:SetPoint("TOPLEFT", ManageView.Frame, "TOPLEFT", 0, 0)
	ManageView.Frame.ScrollBoxList:SetPoint("BOTTOMRIGHT", ManageView.Frame, "BOTTOMRIGHT", -17, 0)
end

local function CreateScrollBar()
	ManageView.Frame.ScrollBar = CreateFrame("EventFrame", nil, ManageView.Frame, "MinimalScrollBar")
	ManageView.Frame.ScrollBar:SetPoint("TOPLEFT", ManageView.Frame.ScrollBoxList, "TOPRIGHT", 0, -4)
	ManageView.Frame.ScrollBar:SetPoint("BOTTOMLEFT", ManageView.Frame.ScrollBoxList, "BOTTOMRIGHT", 0, 4)
end

local function CreateDropDownMenu()
	local function Initialize()
		local titleButtonInfo = UIDropDownMenu_CreateInfo()
		titleButtonInfo.isTitle = 1
		titleButtonInfo.notCheckable = 1
		if dropDownMenuTarget then
			titleButtonInfo.text = dropDownMenuTarget.title
		end
		UIDropDownMenu_AddButton(titleButtonInfo)

		local renameButtonInfo = UIDropDownMenu_CreateInfo()
		renameButtonInfo.text = "Rename"
		renameButtonInfo.notCheckable = 1
		renameButtonInfo.arg1 = dropDownMenuTarget
		renameButtonInfo.func = function(_, target)
			StaticPopup_ShowCustomGenericInputBox({
				text = "Rename '" .. target.title .. "'",
				callback = function(newNoteTitle)
					addon.Database:SetNoteTitle(target.id, newNoteTitle)
					UpdateScrollBoxList()
				end,
				acceptText = "Save",
				maxLetters = addon.Constants.NOTE_TITLE_MAX_LENGTH,
				countInvisibleLetters = true,
			})
		end
		UIDropDownMenu_AddButton(renameButtonInfo)

		local deleteButtonInfo = UIDropDownMenu_CreateInfo()
		deleteButtonInfo.text = "Delete"
		deleteButtonInfo.notCheckable = 1
		deleteButtonInfo.arg1 = dropDownMenuTarget
		deleteButtonInfo.func = function(_, target)
			StaticPopup_ShowCustomGenericConfirmation({
				text = "Confirm deletion of '" .. target.title .. "'",
				callback = function()
					addon.Database:DeleteNote(target.id)
					UpdateScrollBoxList()
				end,
				acceptText = "Delete",
				cancelText = "Cancel",
			})
		end
		UIDropDownMenu_AddButton(deleteButtonInfo)
	end

	ManageView.Frame.DropDownMenu = CreateFrame("Frame", nil, ManageView.Frame, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(ManageView.Frame.DropDownMenu, Initialize, "MENU")
	ManageView.Frame.DropDownMenu.noResize = true
end

local function ConfigureScrollBoxList()
	local function Initializer(button, elementData)
		button.name:SetText(elementData.title)
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		button:SetScript("OnClick", function(_, clickedButton)
			if clickedButton == "LeftButton" then
				addon.UI:ChangeView(addon.Constants.UI_VIEW_ENUM.EDIT, elementData.id)
			elseif clickedButton == "RightButton" then
				dropDownMenuTarget = { id = elementData.id, title = elementData.title }
				ToggleDropDownMenu(1, nil, ManageView.Frame.DropDownMenu, "cursor", 0, 0)
			end
		end)
	end

	local top, bottom, left, right, spacing = 2, 2, 0, 0, 0
	local view = CreateScrollBoxListLinearView(top, bottom, left, right, spacing)
	view:SetElementInitializer("IgnoreListButtonTemplate", Initializer)

	ScrollUtil.InitScrollBoxListWithScrollBar(ManageView.Frame.ScrollBoxList, ManageView.Frame.ScrollBar, view)
	UpdateScrollBoxList()
end

function ManageView:Initialize()
	CreateRootFrame()
	CreateScrollBoxList()
	CreateScrollBar()
	CreateDropDownMenu()
	ConfigureScrollBoxList()
end

function ManageView:Show()
	UpdateScrollBoxList()
	ManageView.Frame:Show()
end

function ManageView:Hide()
	ManageView.Frame:Hide()
end

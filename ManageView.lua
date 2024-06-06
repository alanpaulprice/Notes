local addonName, addon = ...
addon.ManageView = {}
local ManageView = addon.ManageView

local function UpdateScrollBoxList()
	local dataProvider = CreateDataProvider()
	local notes = addon.Database:GetNotes()

	--TODO - would need to insert an item with header or w/e here to add 'create new' button

	for _, note in ipairs(notes) do
		dataProvider:Insert({ id = note.id, title = note.title })
	end

	ManageView.Frame.ScrollBoxList:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition)
end

local function CreateRootFrame()
	ManageView.Frame = CreateFrame("Frame", addonName .. "_ManageView", addon.UI.Frame.ViewContainer, nil)
	ManageView.Frame:SetAllPoints(addon.UI.Frame.ViewContainer)

	if addon.Database.GetCurrentNote() ~= nil then
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

local function ConfigureScrollBoxList()
	local function InitButton(button, elementData)
		button.name:SetText(elementData.title)
		button:SetScript("OnClick", function()
			addon.UI:ChangeView(addon.Constants.UI_VIEW_ENUM.EDIT, elementData.id)
		end)
	end

	local view = CreateScrollBoxListLinearView()
	view:SetElementFactory(function(factory, elementData)
		if elementData.header then
			factory(elementData.header) --TODO - could modify for 'create new' button?
		else
			factory("IgnoreListButtonTemplate", InitButton)
			-- factory(nil, InitButton) --TODO - replace above line, create custom frame inside initbutton
		end
	end)

	ScrollUtil.InitScrollBoxListWithScrollBar(ManageView.Frame.ScrollBoxList, ManageView.Frame.ScrollBar, view)
	UpdateScrollBoxList()
end

function ManageView:Initialize()
	CreateRootFrame()
	CreateScrollBoxList()
	CreateScrollBar()
	ConfigureScrollBoxList()
end

function ManageView:Show()
	UpdateScrollBoxList()
	ManageView.Frame:Show()
end

function ManageView:Hide()
	ManageView.Frame:Hide()
end

local addonName, addon = ...
addon.ManageView = {}
local ManageView = addon.ManageView

local function CreateRootFrame()
	ManageView.Frame = CreateFrame("Frame", addonName .. "_ManageView", addon.UI.Frame.ViewContainer, nil)
	ManageView.Frame:SetAllPoints(addon.UI.Frame.ViewContainer)

	if addon.Database.GetCurrentNote() ~= nil then
		ManageView.Frame:Hide()
	end
end

local function CreateScrollBoxList()
	-- Create the scroll box list.
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
	end

	local function Update()
		local dataProvider = CreateDataProvider()
		local notes = addon.Database:GetNotes()

		for id, note in pairs(notes) do
			dataProvider:Insert({ id = id, title = note.title })
		end

		ManageView.Frame.ScrollBoxList:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition)
	end

	local view = CreateScrollBoxListLinearView()
	view:SetElementFactory(function(factory, elementData)
		if elementData.header then
			factory(elementData.header) --TODO - could modify for 'create new' button?
		else
			factory("IgnoreListButtonTemplate", InitButton)
		end
	end)

	ScrollUtil.InitScrollBoxListWithScrollBar(ManageView.Frame.ScrollBoxList, ManageView.Frame.ScrollBar, view)
	Update()
end

function ManageView:Initialize()
	CreateRootFrame()
	CreateScrollBoxList()
	CreateScrollBar()
	ConfigureScrollBoxList()
end

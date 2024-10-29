local addonName, addon = ...
addon.MainUi = {}
local MainUi = addon.MainUi

local AceGUI = LibStub("AceGUI-3.0")

local function BuildTabGroup()
	local function SelectGroup(container, event, group)
		addon.Database:SetCurrentView(group)
		container:ReleaseChildren()

		if group == addon.Constants.UI_VIEW_ENUM.EDIT then
			addon.EditView:Build(container)
		elseif group == addon.Constants.UI_VIEW_ENUM.LIST then
			addon.ListView:Build(container)
		elseif group == addon.Constants.UI_VIEW_ENUM.MANAGE then
			addon.ManageView:Build(container)
		end
	end

	MainUi.tabGroup = AceGUI:Create("TabGroup")
	MainUi.tabGroup:SetLayout("Flow")
	MainUi:UpdateTabs()
	MainUi.tabGroup:SetCallback("OnGroupSelected", SelectGroup)
	MainUi.tabGroup:SelectTab(addon.Database:GetCurrentView())
	MainUi.frame:AddChild(MainUi.tabGroup)
end

local function BuildFrame()
	MainUi.frame = AceGUI:Create("Frame")
	MainUi.frame:SetHeight(400)
	MainUi.frame:SetWidth(400)
	MainUi.frame:EnableResize(addon.Database:GetResizeEnabled())
	MainUi.frame:SetTitle(addonName)
	MainUi:UpdateStatusText()
	MainUi.frame:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
	MainUi.frame:SetLayout("Fill")
	BuildTabGroup()
end

function MainUi:Initialize()
	if addon.Database:GetShowAtLogin() then
		BuildFrame()
	end
end

function MainUi:Toggle()
	if self.frame and self.frame:IsShown() then
		AceGUI:Release(self.frame)
	else
		BuildFrame()
	end
end

function MainUi:ChangeView(tab)
	addon.Utilities:CheckIsEnumMember(tab, addon.Constants.UI_VIEW_ENUM)
	addon.Database:SetCurrentView(tab)
	MainUi.tabGroup:SelectTab(tab)
end

function MainUi:UpdateTabs()
	local currentNoteId = addon.Database:GetCurrentNoteId()
	local editTabDisabled = currentNoteId == nil

	MainUi.tabGroup:SetTabs({
		{ text = "   Edit   ", value = addon.Constants.UI_VIEW_ENUM.EDIT, disabled = editTabDisabled },
		{ text = "   List   ", value = addon.Constants.UI_VIEW_ENUM.LIST },
		{ text = "   Manage   ", value = addon.Constants.UI_VIEW_ENUM.MANAGE },
	})
end

function MainUi:UpdateStatusText()
	local currentNote = addon.Database:GetCurrentNote()
	local statusText = ""

	if currentNote then
		statusText = string.format("Current: |cFFFFFFFF%s|r", currentNote.title)
	end

	MainUi.frame:SetStatusText(statusText)
end

function MainUi:UpdateResizeEnabled(input)
	addon.Database:SetResizeEnabled(input)

	if self.frame and self.frame:IsShown() then
		self.frame:EnableResize(input)
	end
end

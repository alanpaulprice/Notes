local addonName, addon = ...
addon.MainUi = {}
local MainUi = addon.MainUi

local AceGUI = LibStub("AceGUI-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

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

local function ConfigureFrameResize()
	local roundedScreenWidth = addon.Utilities:RoundNumber(GetScreenWidth(), 0)
	local roundedScreenHeight = addon.Utilities:RoundNumber(GetScreenHeight(), 0)

	MainUi.frame:EnableResize(addon.Database:GetResizeEnabled())
	MainUi.frame.frame:SetResizeBounds(
		addon.Constants.MIN_UI_WIDTH,
		addon.Constants.MIN_UI_HEIGHT,
		roundedScreenWidth,
		roundedScreenHeight
	)
end

local function ConfigureFrameSizerScripts()
	local function onMoverSizerMouseUp()
		addon.Database:SetWidth(MainUi.frame.status.width)
		addon.Database:SetHeight(MainUi.frame.status.height)
		AceConfigRegistry:NotifyChange(addonName)
	end

	MainUi.frame.sizer_se:HookScript("OnMouseUp", onMoverSizerMouseUp)
	MainUi.frame.sizer_s:HookScript("OnMouseUp", onMoverSizerMouseUp)
	MainUi.frame.sizer_e:HookScript("OnMouseUp", onMoverSizerMouseUp)
	MainUi.frame.titlebg:HookScript("OnMouseUp", onMoverSizerMouseUp)
end

local function ConfigureFrameOnCloseScript()
	MainUi.frame:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
end

local function BuildFrame()
	MainUi.frame = AceGUI:Create("Frame")
	MainUi.frame:Hide()
	MainUi.frame:SetLayout("Fill")
	MainUi.frame:SetStatusTable(addon.Database:GetUnclonedMainUiStatus())
	MainUi.frame:SetWidth(addon.Database:GetWidth())
	MainUi.frame:SetHeight(addon.Database:GetHeight())
	MainUi.frame.frame:SetClampedToScreen(addon.Database:GetClampedToScreen())
	MainUi.frame:SetTitle(addonName)
	MainUi:UpdateStatusText()
	ConfigureFrameResize()
	ConfigureFrameSizerScripts()
	BuildTabGroup()
	ConfigureFrameOnCloseScript()
	MainUi.frame:Show()
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
		-- The spaces either side of the `text` values are there to make the tabs wider.
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

function MainUi:UpdateClampedToScreen(input)
	addon.Database:SetClampedToScreen(input)

	if self.frame and self.frame:IsShown() then
		self.frame.frame:SetClampedToScreen(input)
	end
end

function MainUi:UpdateWidth(width)
	addon.Database:SetWidth(width)

	if self.frame and self.frame:IsShown() then
		self.frame:SetWidth(width)
	end
end

function MainUi:UpdateHeight(height)
	addon.Database:SetHeight(height)

	if self.frame and self.frame:IsShown() then
		self.frame:SetHeight(height)
	end
end

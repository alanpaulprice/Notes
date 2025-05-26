local addonName, addon = ...
addon.MainUi = {}
local MainUi = addon.MainUi

local AceGUI = LibStub("AceGUI-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local frame = nil
local tabGroup = nil

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

	tabGroup = AceGUI:Create("TabGroup")
	tabGroup:SetLayout("Flow")
	MainUi:UpdateTabs()
	tabGroup:SetCallback("OnGroupSelected", SelectGroup)
	tabGroup:SelectTab(addon.Database:GetCurrentView())
	frame:AddChild(tabGroup)
end

local function ConfigureFrameResize()
	local roundedScreenWidth = addon.Utilities:RoundNumber(GetScreenWidth(), 0)
	local roundedScreenHeight = addon.Utilities:RoundNumber(GetScreenHeight(), 0)

	frame:EnableResize(addon.Database:GetResizeEnabled())
	frame.frame:SetResizeBounds(
		addon.Constants.MIN_UI_WIDTH,
		addon.Constants.MIN_UI_HEIGHT,
		roundedScreenWidth,
		roundedScreenHeight
	)
end

local function ConfigureFrameSizerScripts()
	local function onMoverSizerMouseUp()
		addon.Database:SetWidth(frame.status.width)
		addon.Database:SetHeight(frame.status.height)
		AceConfigRegistry:NotifyChange(addonName)
	end

	frame.sizer_se:HookScript("OnMouseUp", onMoverSizerMouseUp)
	frame.sizer_s:HookScript("OnMouseUp", onMoverSizerMouseUp)
	frame.sizer_e:HookScript("OnMouseUp", onMoverSizerMouseUp)
	frame.titlebg:HookScript("OnMouseUp", onMoverSizerMouseUp)
end

local function ConfigureFrameOnCloseScript()
	frame:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
end

local function BuildFrame()
	frame = AceGUI:Create("Frame")
	frame:Hide()
	frame:SetLayout("Fill")
	frame.frame:SetFrameStrata("MEDIUM")
	frame:SetStatusTable(addon.Database:GetUnclonedMainUiStatus())
	frame:SetWidth(addon.Database:GetWidth())
	frame:SetHeight(addon.Database:GetHeight())
	frame.frame:SetClampedToScreen(addon.Database:GetClampedToScreen())
	frame:SetTitle(addonName)
	MainUi:UpdateStatusText()
	ConfigureFrameResize()
	ConfigureFrameSizerScripts()
	BuildTabGroup()
	ConfigureFrameOnCloseScript()
	frame:Show()
end

function MainUi:Initialize()
	if addon.Database:GetShowAtLogin() then
		BuildFrame()
	end
end

function MainUi:Toggle()
	if frame and frame:IsShown() then
		AceGUI:Release(frame)
	else
		BuildFrame()
	end
end

function MainUi:ChangeView(tab)
	addon.Utilities:CheckIsEnumMember(tab, addon.Constants.UI_VIEW_ENUM)
	addon.Database:SetCurrentView(tab)
	tabGroup:SelectTab(tab)
end

function MainUi:UpdateTabs()
	local currentNoteId = addon.Database:GetCurrentNoteId()
	local editTabDisabled = currentNoteId == nil

	tabGroup:SetTabs({
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

	frame:SetStatusText(statusText)
end

function MainUi:UpdateResizeEnabled(input)
	addon.Database:SetResizeEnabled(input)

	if frame and frame:IsShown() then
		frame:EnableResize(input)
	end
end

function MainUi:UpdateClampedToScreen(input)
	addon.Database:SetClampedToScreen(input)

	if frame and frame:IsShown() then
		frame.frame:SetClampedToScreen(input)
	end
end

function MainUi:UpdateWidth(width)
	addon.Database:SetWidth(width)

	if frame and frame:IsShown() then
		frame:SetWidth(width)
	end
end

function MainUi:UpdateHeight(height)
	addon.Database:SetHeight(height)

	if frame and frame:IsShown() then
		frame:SetHeight(height)
	end
end

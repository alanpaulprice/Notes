-------------------------------------------------------------------------------------------------------------- UTILITIES

local function printKeys(tbl)
	for key, _ in pairs(tbl) do
		print(key)
	end
end

------------------------------------------------------------------------------------------------------------------------

local addonName, core = ...
local Notes = {}

------------------------------------------------------------------------------------------------------------- MAIN FRAME

Notes.MainFrame = CreateFrame("Frame", "Notes_MainFrame", UIParent, "BasicFrameTemplate")
Notes.MainFrame:Hide()
Notes.MainFrame:SetSize(338, 424)
Notes.MainFrame:SetPoint("CENTER", UIParent, "CENTER")
-- Notes_MainFrame.Bg:SetTexture("Interface\\MailFrame\\UI-MailFrameBG")
Notes.MainFrame:SetMovable(true)
Notes.MainFrame:SetClipsChildren(true)

Notes.MainFrame.TitleText:SetText("Notes")
Notes.MainFrame.TitleText:ClearAllPoints()
Notes.MainFrame.TitleText:SetPoint("TOPLEFT", Notes.MainFrame.TopBorder, "TOPLEFT", 0, 0)
Notes.MainFrame.TitleText:SetPoint("BOTTOMRIGHT", Notes.MainFrame.TopBorder, "BOTTOMRIGHT", 0, 3)
Notes.MainFrame.TitleText:SetTextColor(1, 1, 1)

--------------------------------------------------------------------------------------------- MOVING

Notes.MainFrame:SetMovable(true)
-- Notes.MainFrame:EnableMouse(true)

Notes.MainFrame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		self:StartMoving()
	end
end)

Notes.MainFrame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" then
		self:StopMovingOrSizing()
	end
end)

----------------------------------------------------------------------------------------------------- SCROLLING EDIT BOX

Notes.ScrollingEditBox = CreateFrame("Frame", "Notes_ScrollingEditBox", Notes.MainFrame, "ScrollingEditBoxTemplate")
Notes.ScrollingEditBox:SetPoint("TOPLEFT", Notes.MainFrame.Bg, "TOPLEFT", 4, -2)
Notes.ScrollingEditBox:SetPoint("BOTTOMRIGHT", Notes.MainFrame.Bg, "BOTTOMRIGHT", -26, 2)

------------------------------------------------------------------------------------------------------------- SCROLL BAR

Notes.ScrollingEditBox.ScrollBar =
	CreateFrame("EventFrame", "Notes_ScrollingEditBox_ScrollBar", Notes.MainFrame, "WowTrimScrollBar")
Notes.ScrollingEditBox.ScrollBar:SetPoint("TOPLEFT", Notes.MainFrame.Bg, "TOPRIGHT", -24, 0)
Notes.ScrollingEditBox.ScrollBar:SetPoint("BOTTOMRIGHT", Notes.MainFrame.Bg, "BOTTOMRIGHT", 0, 0)
ScrollUtil.RegisterScrollBoxWithScrollBar(Notes.ScrollingEditBox.ScrollBox, Notes.ScrollingEditBox.ScrollBar)

--------------------------------------------------------------------------------------------------- TEXT CHANGE HANDLING

function Notes:OnScrollingEditBoxTextChange(editBox)
	if Notes_DB ~= nil then
		Notes_DB.note = editBox:GetInputText()
	end
end

Notes.ScrollingEditBox:RegisterCallback("OnTextChanged", Notes.OnScrollingEditBoxTextChange, self)

function Notes.MainFrame:Toggle()
	Notes.MainFrame:SetShown(not Notes.MainFrame:IsShown())
end

SLASH_TOGGLENOTES1 = "/notes"
SlashCmdList.TOGGLENOTES = function()
	Notes.MainFrame:Toggle()
end

function Notes:Init()
	if Notes_DB == nil then
		Notes_DB = {
			config = {},
			note = "",
		}
	end

	Notes.ScrollingEditBox.ScrollBox.EditBox:SetText(Notes_DB.note)
end

function Notes:OnAddonLoaded(self, name)
	if name == addonName then
		Notes:Init()
		print(addonName .. " has loaded.")
	end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", Notes.OnAddonLoaded)

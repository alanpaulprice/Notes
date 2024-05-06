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

------------------------------------------------------------------------------------------- RESIZING

Notes.MainFrame:SetResizable(true)

------------------------------------------------------------------------ BORDERS

Notes.MainFrame.RightBorder:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StartSizing("RIGHT")
	end
end)

Notes.MainFrame.RightBorder:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StopMovingOrSizing()
	end
end)

Notes.MainFrame.BottomBorder:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StartSizing("BOTTOM")
	end
end)

Notes.MainFrame.BottomBorder:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StopMovingOrSizing()
	end
end)

Notes.MainFrame.LeftBorder:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StartSizing("LEFT")
	end
end)

Notes.MainFrame.LeftBorder:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StopMovingOrSizing()
	end
end)

------------------------------------------------------------------------ CORNERS

Notes.MainFrame.BotRightCorner:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StartSizing("BOTTOMRIGHT")
	end
end)

Notes.MainFrame.BotRightCorner:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StopMovingOrSizing()
	end
end)

Notes.MainFrame.BotLeftCorner:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StartSizing("BOTTOMLEFT")
	end
end)

Notes.MainFrame.BotLeftCorner:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StopMovingOrSizing()
	end
end)

----------------------------------------------------------- ENFORCE MINIMUM SIZE

function Notes.MainFrame:EnforceMinimumSize()
	local minimumWidth, minimumHeight, currentWidth, currentHeight = 100, 100, self:GetWidth(), self:GetHeight()

	if currentWidth < minimumWidth then
		self:SetWidth(minimumWidth)
	end

	if currentHeight < minimumHeight then
		self:SetHeight(minimumHeight)
	end
end

Notes.MainFrame:SetScript("OnSizeChanged", Notes.MainFrame.EnforceMinimumSize)

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

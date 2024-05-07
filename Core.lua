-------------------------------------------------------------------------------------------------------------- UTILITIES

local function printKeys(tbl)
	for key, _ in pairs(tbl) do
		print(key)
	end
end

------------------------------------------------------------------------------------------------------------------------

local addonName, core = ...
local Notes = {
	MinimapButton = {},
}

------------------------------------------------------------------------------------------------------------- MAIN FRAME

Notes.MainFrame = CreateFrame("Frame", "Notes_MainFrame", UIParent, "BasicFrameTemplate")
Notes.MainFrame:Hide()
Notes.MainFrame:SetSize(338, 424)
Notes.MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
Notes.MainFrame:SetClipsChildren(true)

---------------------------------------------------------------------------------------------- TITLE

Notes.MainFrame.TitleText:SetText("Notes")
Notes.MainFrame.TitleText:ClearAllPoints()
Notes.MainFrame.TitleText:SetPoint("TOPLEFT", Notes.MainFrame.TopBorder, "TOPLEFT", 0, 0)
Notes.MainFrame.TitleText:SetPoint("BOTTOMRIGHT", Notes.MainFrame.TopBorder, "BOTTOMRIGHT", 0, 3)
Notes.MainFrame.TitleText:SetTextColor(1, 1, 1)

--------------------------------------------------------------------------------------------- MOVING

Notes.MainFrame:SetMovable(true)

Notes.MainFrame.TitleBg:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StartMoving()
	end
end)

Notes.MainFrame.TitleBg:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		Notes.MainFrame:StopMovingOrSizing()
	end
end)

------------------------------------------------------------------------- CURSOR

Notes.MainFrame.TitleBg:SetScript("OnEnter", function()
	SetCursor("Interface\\CURSOR\\OPENHAND.blp")
end)

Notes.MainFrame.TitleBg:SetScript("OnLeave", ResetCursor)

------------------------------------------------------------------------------------------- RESIZING

Notes.MainFrame:SetResizable(true)
Notes.MainFrame:SetResizeBounds(100, 100)

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

------------------------------------------------------------------------- CURSOR

function Notes:SetSizeCursor()
	SetCursor("Interface\\CURSOR\\UI-Cursor-Size.blp")
end

Notes.MainFrame.RightBorder:SetScript("OnEnter", Notes.SetSizeCursor)
Notes.MainFrame.RightBorder:SetScript("OnLeave", ResetCursor)

Notes.MainFrame.BottomBorder:SetScript("OnEnter", Notes.SetSizeCursor)
Notes.MainFrame.BottomBorder:SetScript("OnLeave", ResetCursor)

Notes.MainFrame.LeftBorder:SetScript("OnEnter", Notes.SetSizeCursor)
Notes.MainFrame.LeftBorder:SetScript("OnLeave", ResetCursor)

Notes.MainFrame.BotRightCorner:SetScript("OnEnter", Notes.SetSizeCursor)
Notes.MainFrame.BotRightCorner:SetScript("OnLeave", ResetCursor)

Notes.MainFrame.BotLeftCorner:SetScript("OnEnter", Notes.SetSizeCursor)
Notes.MainFrame.BotLeftCorner:SetScript("OnLeave", ResetCursor)

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
	local previousShown = self:IsShown()

	self:SetShown(not previousShown)

	if previousShown then
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	else
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
	end
end

---------------------------------------------------------------------------------------------------- RESET SIZE/POSITION

function Notes.MainFrame:ResetSizeAndPosition()
	self:SetSize(338, 424)
	self:ClearAllPoints()
	self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

SLASH_NOTES1 = "/notes"
SlashCmdList.NOTES = function(message)
	if message == "" then
		Notes.MainFrame:Toggle()
	elseif message == "reset" then
		Notes.MainFrame:ResetSizeAndPosition()
	else
		print(addonName .. ": Unknown argument '" .. message .. "' received.")
	end
end

---------------------------------------------------------------------------------------------------- MINIMAP BUTTON INIT

function Notes.MinimapButton:Init()
	local minimapButton = LibStub("LibDataBroker-1.1"):NewDataObject("Notes", {
		type = "data source",
		text = "Notes",
		icon = "Interface\\ICONS\\INV_Misc_PaperBundle02a.blp", -- "Interface\\ICONS\\INV_Misc_Note_04.blp"
		OnClick = function()
			Notes.MainFrame:Toggle()
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end

			tooltip:AddLine("Notes")
		end,
	})

	local icon = LibStub("LibDBIcon-1.0", true)
	icon:Register("Notes", minimapButton, Notes_DB)
end

------------------------------------------------------------------------------------------------------------------- INIT

function Notes:Init()
	if Notes_DB == nil then
		Notes_DB = {
			config = {},
			note = "",
		}
	end

	Notes.ScrollingEditBox.ScrollBox.EditBox:SetText(Notes_DB.note)

	Notes.MinimapButton:Init()
end

------------------------------------------------------------------------------------------------------- ON ADD ON LOADED

function Notes:OnAddonLoaded(_, name)
	if name == addonName then
		Notes:Init()
	end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", Notes.OnAddonLoaded)

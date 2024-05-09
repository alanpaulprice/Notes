-------------------------------------------------------------------------------------------------------------- UTILITIES

local function printKeys(tbl)
	for key, _ in pairs(tbl) do
		print(key)
	end
end

------------------------------------------------------------------------------------------------------------------------

local addonName, addon = ...

------------------------------------------------------------------------------------------------------------- MAIN FRAME

addon.MainFrame = CreateFrame("Frame", addonName .. "_MainFrame", UIParent, "BasicFrameTemplate")
addon.MainFrame:Hide()
addon.MainFrame:SetSize(338, 424)
addon.MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
addon.MainFrame:SetClipsChildren(true)

---------------------------------------------------------------------------------------------- TITLE

addon.MainFrame.TitleText:SetText(addonName)
addon.MainFrame.TitleText:ClearAllPoints()
addon.MainFrame.TitleText:SetPoint("TOPLEFT", addon.MainFrame.TopBorder, "TOPLEFT", 0, 0)
addon.MainFrame.TitleText:SetPoint("BOTTOMRIGHT", addon.MainFrame.TopBorder, "BOTTOMRIGHT", 0, 3)
addon.MainFrame.TitleText:SetTextColor(1, 1, 1)

--------------------------------------------------------------------------------------------- MOVING

addon.MainFrame:SetMovable(true)

addon.MainFrame.TitleBg:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StartMoving()
	end
end)

addon.MainFrame.TitleBg:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StopMovingOrSizing()
	end
end)

------------------------------------------------------------------------- CURSOR

addon.MainFrame.TitleBg:SetScript("OnEnter", function()
	SetCursor("Interface\\CURSOR\\OPENHAND.blp")
end)

addon.MainFrame.TitleBg:SetScript("OnLeave", ResetCursor)

------------------------------------------------------------------------------------------- RESIZING

addon.MainFrame:SetResizable(true)
addon.MainFrame:SetResizeBounds(100, 100)

------------------------------------------------------------------------ BORDERS

addon.MainFrame.RightBorder:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StartSizing("RIGHT")
	end
end)

addon.MainFrame.RightBorder:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StopMovingOrSizing()
	end
end)

addon.MainFrame.BottomBorder:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StartSizing("BOTTOM")
	end
end)

addon.MainFrame.BottomBorder:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StopMovingOrSizing()
	end
end)

addon.MainFrame.LeftBorder:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StartSizing("LEFT")
	end
end)

addon.MainFrame.LeftBorder:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StopMovingOrSizing()
	end
end)

------------------------------------------------------------------------ CORNERS

addon.MainFrame.BotRightCorner:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StartSizing("BOTTOMRIGHT")
	end
end)

addon.MainFrame.BotRightCorner:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StopMovingOrSizing()
	end
end)

addon.MainFrame.BotLeftCorner:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StartSizing("BOTTOMLEFT")
	end
end)

addon.MainFrame.BotLeftCorner:SetScript("OnMouseUp", function(_, button)
	if button == "LeftButton" then
		addon.MainFrame:StopMovingOrSizing()
	end
end)

------------------------------------------------------------------------- CURSOR

function addon:SetSizeCursor()
	SetCursor("Interface\\CURSOR\\UI-Cursor-Size.blp")
end

addon.MainFrame.RightBorder:SetScript("OnEnter", addon.SetSizeCursor)
addon.MainFrame.RightBorder:SetScript("OnLeave", ResetCursor)

addon.MainFrame.BottomBorder:SetScript("OnEnter", addon.SetSizeCursor)
addon.MainFrame.BottomBorder:SetScript("OnLeave", ResetCursor)

addon.MainFrame.LeftBorder:SetScript("OnEnter", addon.SetSizeCursor)
addon.MainFrame.LeftBorder:SetScript("OnLeave", ResetCursor)

addon.MainFrame.BotRightCorner:SetScript("OnEnter", addon.SetSizeCursor)
addon.MainFrame.BotRightCorner:SetScript("OnLeave", ResetCursor)

addon.MainFrame.BotLeftCorner:SetScript("OnEnter", addon.SetSizeCursor)
addon.MainFrame.BotLeftCorner:SetScript("OnLeave", ResetCursor)

----------------------------------------------------------------------------------------------------- SCROLLING EDIT BOX

addon.MainFrame.ScrollingEditBox =
	CreateFrame("Frame", addonName .. "_ScrollingEditBox", addon.MainFrame, "ScrollingEditBoxTemplate")
addon.MainFrame.ScrollingEditBox:SetPoint("TOPLEFT", addon.MainFrame.Bg, "TOPLEFT", 4, -2)
addon.MainFrame.ScrollingEditBox:SetPoint("BOTTOMRIGHT", addon.MainFrame.Bg, "BOTTOMRIGHT", -26, 2)

------------------------------------------------------------------------------------------------------------- SCROLL BAR

addon.MainFrame.ScrollingEditBox.ScrollBar =
	CreateFrame("EventFrame", addonName .. "_ScrollingEditBox_ScrollBar", addon.MainFrame, "WowTrimScrollBar")
addon.MainFrame.ScrollingEditBox.ScrollBar:SetPoint("TOPLEFT", addon.MainFrame.Bg, "TOPRIGHT", -24, 0)
addon.MainFrame.ScrollingEditBox.ScrollBar:SetPoint("BOTTOMRIGHT", addon.MainFrame.Bg, "BOTTOMRIGHT", 0, 0)
ScrollUtil.RegisterScrollBoxWithScrollBar(
	addon.MainFrame.ScrollingEditBox.ScrollBox,
	addon.MainFrame.ScrollingEditBox.ScrollBar
)

--------------------------------------------------------------------------------------------------- TEXT CHANGE HANDLING

function addon.MainFrame:OnScrollingEditBoxTextChange(editBox)
	if Notes_DB ~= nil then
		Notes_DB.note = editBox:GetInputText()
	end
end

addon.MainFrame.ScrollingEditBox:RegisterCallback("OnTextChanged", addon.MainFrame.OnScrollingEditBoxTextChange, self)

------------------------------------------------------------------------------------------------------ MAIN FRAME TOGGLE

function addon.MainFrame:Toggle()
	local previousShown = self:IsShown()

	self:SetShown(not previousShown)

	if previousShown then
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	else
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
	end
end

---------------------------------------------------------------------------------------------------- RESET SIZE/POSITION

function addon.MainFrame:ResetSizeAndPosition()
	self:SetSize(338, 424)
	self:ClearAllPoints()
	self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

SLASH_NOTES1 = "/" .. string.lower(addonName)
SlashCmdList.NOTES = function(message)
	if message == "" then
		addon.MainFrame:Toggle()
	elseif message == "reset" then
		addon.MainFrame:ResetSizeAndPosition()
	else
		print(addonName .. ": Unknown argument '" .. message .. "' received.")
	end
end

--------------------------------------------------------------------------------------------------------- MINIMAP BUTTON

addon.MinimapButton = {}

----------------------------------------------------------------------------------------------- INIT

function addon.MinimapButton:Init()
	local minimapButton = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
		type = "data source",
		text = addonName,
		icon = "Interface\\ICONS\\INV_Misc_PaperBundle02a.blp", -- "Interface\\ICONS\\INV_Misc_Note_04.blp"
		OnClick = function(_, button)
			if button == "LeftButton" then
				addon.MainFrame:Toggle()
			elseif button == "RightButton" then
				--TODO: OPEN CONFIG
			end
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end

			tooltip:AddLine(addonName)
		end,
	})

	local icon = LibStub("LibDBIcon-1.0", true)
	icon:Register(addonName, minimapButton, Notes_DB)
end

------------------------------------------------------------------------------------------------------------------- INIT

function addon:Init()
	if Notes_DB == nil then
		Notes_DB = {
			config = {},
			note = "",
		}
	end

	addon.MainFrame.ScrollingEditBox.ScrollBox.EditBox:SetText(Notes_DB.note)

	addon.MinimapButton:Init()
end

------------------------------------------------------------------------------------------------------- ON ADD ON LOADED

function addon:OnAddonLoaded(_, name)
	if name == addonName then
		addon:Init()
	end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", addon.OnAddonLoaded)

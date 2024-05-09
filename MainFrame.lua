local addonName, addon = ...
addon.MainFrame = {}
local MainFrame = addon.MainFrame

------------------------------------------------------------------------------------------------------------------------

function MainFrame:Initialize()
	MainFrame = CreateFrame("Frame", addonName .. "_MainFrame", UIParent, "BasicFrameTemplate")
	MainFrame:Hide()
	MainFrame:SetSize(338, 424)
	MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	MainFrame:SetClipsChildren(true)

	---------------------------------------------------------------------------------------------- TITLE

	MainFrame.TitleText:SetText(addonName)
	MainFrame.TitleText:ClearAllPoints()
	MainFrame.TitleText:SetPoint("TOPLEFT", MainFrame.TopBorder, "TOPLEFT", 0, 0)
	MainFrame.TitleText:SetPoint("BOTTOMRIGHT", MainFrame.TopBorder, "BOTTOMRIGHT", 0, 3)
	MainFrame.TitleText:SetTextColor(1, 1, 1)

	--------------------------------------------------------------------------------------------- MOVING

	MainFrame:SetMovable(true)

	MainFrame.TitleBg:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			MainFrame:StartMoving()
		end
	end)

	MainFrame.TitleBg:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end)

	------------------------------------------------------------------------- CURSOR

	MainFrame.TitleBg:SetScript("OnEnter", function()
		SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	end)

	MainFrame.TitleBg:SetScript("OnLeave", ResetCursor)

	------------------------------------------------------------------------------------------- RESIZING

	MainFrame:SetResizable(true)
	MainFrame:SetResizeBounds(100, 100)

	------------------------------------------------------------------------ BORDERS

	MainFrame.RightBorder:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			MainFrame:StartSizing("RIGHT")
		end
	end)

	MainFrame.RightBorder:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end)

	MainFrame.BottomBorder:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			MainFrame:StartSizing("BOTTOM")
		end
	end)

	MainFrame.BottomBorder:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end)

	MainFrame.LeftBorder:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			MainFrame:StartSizing("LEFT")
		end
	end)

	MainFrame.LeftBorder:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end)

	------------------------------------------------------------------------ CORNERS

	MainFrame.BotRightCorner:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			MainFrame:StartSizing("BOTTOMRIGHT")
		end
	end)

	MainFrame.BotRightCorner:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end)

	MainFrame.BotLeftCorner:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			MainFrame:StartSizing("BOTTOMLEFT")
		end
	end)

	MainFrame.BotLeftCorner:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end)

	------------------------------------------------------------------------- CURSOR

	function addon:SetSizeCursor()
		SetCursor("Interface\\CURSOR\\UI-Cursor-Size.blp")
	end

	MainFrame.RightBorder:SetScript("OnEnter", SetSizeCursor)
	MainFrame.RightBorder:SetScript("OnLeave", ResetCursor)

	MainFrame.BottomBorder:SetScript("OnEnter", SetSizeCursor)
	MainFrame.BottomBorder:SetScript("OnLeave", ResetCursor)

	MainFrame.LeftBorder:SetScript("OnEnter", SetSizeCursor)
	MainFrame.LeftBorder:SetScript("OnLeave", ResetCursor)

	MainFrame.BotRightCorner:SetScript("OnEnter", SetSizeCursor)
	MainFrame.BotRightCorner:SetScript("OnLeave", ResetCursor)

	MainFrame.BotLeftCorner:SetScript("OnEnter", SetSizeCursor)
	MainFrame.BotLeftCorner:SetScript("OnLeave", ResetCursor)

	----------------------------------------------------------------------------------------------------- SCROLLING EDIT BOX

	MainFrame.ScrollingEditBox =
		CreateFrame("Frame", addonName .. "_ScrollingEditBox", MainFrame, "ScrollingEditBoxTemplate")
	MainFrame.ScrollingEditBox:SetPoint("TOPLEFT", MainFrame.Bg, "TOPLEFT", 4, -2)
	MainFrame.ScrollingEditBox:SetPoint("BOTTOMRIGHT", MainFrame.Bg, "BOTTOMRIGHT", -26, 2)
	MainFrame.ScrollingEditBox.ScrollBox.EditBox:SetText(addon.Database:GetNote())

	------------------------------------------------------------------------------------------------------------- SCROLL BAR

	MainFrame.ScrollingEditBox.ScrollBar =
		CreateFrame("EventFrame", addonName .. "_ScrollingEditBox_ScrollBar", MainFrame, "WowTrimScrollBar")
	MainFrame.ScrollingEditBox.ScrollBar:SetPoint("TOPLEFT", MainFrame.Bg, "TOPRIGHT", -24, 0)
	MainFrame.ScrollingEditBox.ScrollBar:SetPoint("BOTTOMRIGHT", MainFrame.Bg, "BOTTOMRIGHT", 0, 0)
	ScrollUtil.RegisterScrollBoxWithScrollBar(
		MainFrame.ScrollingEditBox.ScrollBox,
		MainFrame.ScrollingEditBox.ScrollBar
	)

	--------------------------------------------------------------------------------------------------- TEXT CHANGE HANDLING

	function MainFrame:OnScrollingEditBoxTextChange(editBox)
		addon.Database:SetNote(editBox:GetInputText())
	end

	MainFrame.ScrollingEditBox:RegisterCallback("OnTextChanged", MainFrame.OnScrollingEditBoxTextChange, self)
end

------------------------------------------------------------------------------------------------------ MAIN FRAME TOGGLE

function MainFrame:Toggle()
	local previousShown = MainFrame:IsShown()

	MainFrame:SetShown(not previousShown)

	if previousShown then
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	else
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
	end
end

---------------------------------------------------------------------------------------------------- RESET SIZE/POSITION

function MainFrame:ResetSizeAndPosition()
	MainFrame:SetSize(338, 424)
	MainFrame:ClearAllPoints()
	MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

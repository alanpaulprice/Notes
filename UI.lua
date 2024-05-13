local addonName, addon = ...
addon.UI = {}
local UI = addon.UI

local function CreateRootFrame()
	UI.frame = CreateFrame("Frame", addonName .. "_UI", UIParent, "BasicFrameTemplate")
	UI.frame:SetSize(338, 424)
	UI.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	UI.frame:SetClipsChildren(true)

	UI.frame.TitleText:SetText(addonName)
	UI.frame.TitleText:ClearAllPoints()
	UI.frame.TitleText:SetPoint("TOPLEFT", UI.frame.TopBorder, "TOPLEFT", 0, 0)
	UI.frame.TitleText:SetPoint("BOTTOMRIGHT", UI.frame.TopBorder, "BOTTOMRIGHT", 0, 3)
	UI.frame.TitleText:SetTextColor(1, 1, 1)
end

local function MakeFrameMoveable()
	UI.frame:SetMovable(true)

	UI.frame.TitleBg:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			UI.frame:StartMoving()
		end
	end)

	UI.frame.TitleBg:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			UI.frame:StopMovingOrSizing()
		end
	end)

	UI.frame.TitleBg:SetScript("OnEnter", function()
		SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	end)

	UI.frame.TitleBg:SetScript("OnLeave", ResetCursor)
end

local function MakeFrameResizable()
	UI.frame:SetResizable(true)
	UI.frame:SetResizeBounds(100, 100)

	local function onBorderOrCornerMouseDown(button, framePoint)
		if button == "LeftButton" then
			UI.frame:StartSizing(framePoint)
		end
	end

	local function onBorderOrCornerMouseUp(_, button)
		if button == "LeftButton" then
			UI.frame:StopMovingOrSizing()
		end
	end

	local function SetSizeCursor()
		SetCursor("Interface\\CURSOR\\UI-Cursor-Size.blp")
	end

	UI.frame.RightBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "RIGHT")
	end)
	UI.frame.RightBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.frame.RightBorder:SetScript("OnEnter", SetSizeCursor)
	UI.frame.RightBorder:SetScript("OnLeave", ResetCursor)

	UI.frame.BotRightCorner:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOMRIGHT")
	end)
	UI.frame.BotRightCorner:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.frame.BotRightCorner:SetScript("OnEnter", SetSizeCursor)
	UI.frame.BotRightCorner:SetScript("OnLeave", ResetCursor)

	UI.frame.BottomBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOM")
	end)
	UI.frame.BottomBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.frame.BottomBorder:SetScript("OnEnter", SetSizeCursor)
	UI.frame.BottomBorder:SetScript("OnLeave", ResetCursor)

	UI.frame.BotLeftCorner:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOMLEFT")
	end)
	UI.frame.BotLeftCorner:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.frame.BotLeftCorner:SetScript("OnEnter", SetSizeCursor)
	UI.frame.BotLeftCorner:SetScript("OnLeave", ResetCursor)

	UI.frame.LeftBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "LEFT")
	end)
	UI.frame.LeftBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.frame.LeftBorder:SetScript("OnEnter", SetSizeCursor)
	UI.frame.LeftBorder:SetScript("OnLeave", ResetCursor)
end

local function CreateScrollingEditBox()
	UI.frame.ScrollingEditBox =
		CreateFrame("Frame", addonName .. "_ScrollingEditBox", UI.frame, "ScrollingEditBoxTemplate")
	UI.frame.ScrollingEditBox:SetPoint("TOPLEFT", UI.frame.Bg, "TOPLEFT", 4, -2)
	UI.frame.ScrollingEditBox:SetPoint("BOTTOMRIGHT", UI.frame.Bg, "BOTTOMRIGHT", -26, 2)
	UI.frame.ScrollingEditBox.ScrollBox.EditBox:SetText(addon.Database:GetNote())
end

local function CreateScrollBar()
	UI.frame.ScrollingEditBox.ScrollBar =
		CreateFrame("EventFrame", addonName .. "_ScrollingEditBox_ScrollBar", UI.frame, "WowTrimScrollBar")
	UI.frame.ScrollingEditBox.ScrollBar:SetPoint("TOPLEFT", UI.frame.Bg, "TOPRIGHT", -24, 0)
	UI.frame.ScrollingEditBox.ScrollBar:SetPoint("BOTTOMRIGHT", UI.frame.Bg, "BOTTOMRIGHT", 0, 0)
	ScrollUtil.RegisterScrollBoxWithScrollBar(UI.frame.ScrollingEditBox.ScrollBox, UI.frame.ScrollingEditBox.ScrollBar)
end

local function ConfigureOnTextChangeHandling()
	local function OnTextChange(owner, editBox, userChanged)
		addon.Database:SetNote(editBox:GetInputText())
	end

	UI.frame.ScrollingEditBox:RegisterCallback("OnTextChanged", OnTextChange, self)
end

function UI:Initialize()
	CreateRootFrame()
	MakeFrameMoveable()
	MakeFrameResizable()
	CreateScrollingEditBox()
	CreateScrollBar()
	ConfigureOnTextChangeHandling()
end

function UI:Toggle()
	if UI.frame == nil then
		self:Initialize()
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	else
		UI.frame:Hide()
		UI.frame = nil
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
	end
end

function UI:ResetSizeAndPosition()
	UI.frame:SetSize(338, 424)
	UI.frame:ClearAllPoints()
	UI.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

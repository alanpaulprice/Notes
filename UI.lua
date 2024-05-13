local addonName, addon = ...
addon.UI = {}
local UI = addon.UI

local function CreateRootFrame()
	UI.Frame = CreateFrame("Frame", addonName .. "_UI", UIParent, "BasicFrameTemplate")
	UI.Frame:SetSize(338, 424)
	UI.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	UI.Frame:SetClipsChildren(true)

	UI.Frame.TitleText:SetText(addonName)
	UI.Frame.TitleText:ClearAllPoints()
	UI.Frame.TitleText:SetPoint("TOPLEFT", UI.Frame.TopBorder, "TOPLEFT", 0, 0)
	UI.Frame.TitleText:SetPoint("BOTTOMRIGHT", UI.Frame.TopBorder, "BOTTOMRIGHT", 0, 3)
	UI.Frame.TitleText:SetTextColor(1, 1, 1)
end

local function MakeFrameMoveable()
	UI.Frame:SetMovable(true)

	UI.Frame.TitleBg:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			UI.Frame:StartMoving()
		end
	end)

	UI.Frame.TitleBg:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			UI.Frame:StopMovingOrSizing()
		end
	end)

	UI.Frame.TitleBg:SetScript("OnEnter", function()
		SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	end)

	UI.Frame.TitleBg:SetScript("OnLeave", ResetCursor)
end

local function MakeFrameResizable()
	UI.Frame:SetResizable(true)
	UI.Frame:SetResizeBounds(100, 100)

	local function onBorderOrCornerMouseDown(button, framePoint)
		if button == "LeftButton" then
			UI.Frame:StartSizing(framePoint)
		end
	end

	local function onBorderOrCornerMouseUp(_, button)
		if button == "LeftButton" then
			UI.Frame:StopMovingOrSizing()
		end
	end

	local function SetSizeCursor()
		SetCursor("Interface\\CURSOR\\UI-Cursor-Size.blp")
	end

	UI.Frame.RightBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "RIGHT")
	end)
	UI.Frame.RightBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.Frame.RightBorder:SetScript("OnEnter", SetSizeCursor)
	UI.Frame.RightBorder:SetScript("OnLeave", ResetCursor)

	UI.Frame.BotRightCorner:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOMRIGHT")
	end)
	UI.Frame.BotRightCorner:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.Frame.BotRightCorner:SetScript("OnEnter", SetSizeCursor)
	UI.Frame.BotRightCorner:SetScript("OnLeave", ResetCursor)

	UI.Frame.BottomBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOM")
	end)
	UI.Frame.BottomBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.Frame.BottomBorder:SetScript("OnEnter", SetSizeCursor)
	UI.Frame.BottomBorder:SetScript("OnLeave", ResetCursor)

	UI.Frame.BotLeftCorner:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOMLEFT")
	end)
	UI.Frame.BotLeftCorner:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.Frame.BotLeftCorner:SetScript("OnEnter", SetSizeCursor)
	UI.Frame.BotLeftCorner:SetScript("OnLeave", ResetCursor)

	UI.Frame.LeftBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "LEFT")
	end)
	UI.Frame.LeftBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	UI.Frame.LeftBorder:SetScript("OnEnter", SetSizeCursor)
	UI.Frame.LeftBorder:SetScript("OnLeave", ResetCursor)
end

local function CreateScrollingEditBox()
	UI.Frame.ScrollingEditBox =
		CreateFrame("Frame", addonName .. "_ScrollingEditBox", UI.Frame, "ScrollingEditBoxTemplate")
	UI.Frame.ScrollingEditBox:SetPoint("TOPLEFT", UI.Frame.Bg, "TOPLEFT", 4, -2)
	UI.Frame.ScrollingEditBox:SetPoint("BOTTOMRIGHT", UI.Frame.Bg, "BOTTOMRIGHT", -26, 2)
	UI.Frame.ScrollingEditBox.ScrollBox.EditBox:SetText(addon.Database:GetNote())
end

local function CreateScrollBar()
	UI.Frame.ScrollingEditBox.ScrollBar =
		CreateFrame("EventFrame", addonName .. "_ScrollingEditBox_ScrollBar", UI.Frame, "WowTrimScrollBar")
	UI.Frame.ScrollingEditBox.ScrollBar:SetPoint("TOPLEFT", UI.Frame.Bg, "TOPRIGHT", -24, 0)
	UI.Frame.ScrollingEditBox.ScrollBar:SetPoint("BOTTOMRIGHT", UI.Frame.Bg, "BOTTOMRIGHT", 0, 0)
	ScrollUtil.RegisterScrollBoxWithScrollBar(UI.Frame.ScrollingEditBox.ScrollBox, UI.Frame.ScrollingEditBox.ScrollBar)
end

local function ConfigureOnTextChangeHandling()
	local function OnTextChange(owner, editBox, userChanged)
		addon.Database:SetNote(editBox:GetInputText())
	end

	UI.Frame.ScrollingEditBox:RegisterCallback("OnTextChanged", OnTextChange, self)
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
	if UI.Frame == nil then
		self:Initialize()
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	else
		UI.Frame:Hide()
		UI.Frame = nil
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
	end
end

function UI:ResetSizeAndPosition()
	UI.Frame:SetSize(338, 424)
	UI.Frame:ClearAllPoints()
	UI.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

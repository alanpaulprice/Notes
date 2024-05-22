local addonName, addon = ...
addon.UI = {}
local UI = addon.UI

local function CreateRootFrame()
	UI.Frame = CreateFrame("Frame", addonName .. "_UI.Frame", UIParent, "BasicFrameTemplate")
	local size = addon.Database:GetSize()
	UI.Frame:SetSize(size.width, size.height)
	local point = addon.Database:GetPoint()
	UI.Frame:SetPoint(point.anchorPoint, point.relativeTo, point.relativePoint, point.xOffset, point.yOffset)
	UI.Frame:SetClipsChildren(true)
	UI.Frame:EnableMouse(true)

	UI.Frame.TitleText:SetText(addonName)
	UI.Frame.TitleText:SetPoint("TOPLEFT", UI.Frame.TopBorder, "TOPLEFT", 0, 0)
	UI.Frame.TitleText:SetPoint("BOTTOMRIGHT", UI.Frame.TopBorder, "BOTTOMRIGHT", 0, 3)
	UI.Frame.TitleText:SetTextColor(1, 1, 1)
end

local function UpdateSavedSize()
	addon.Database:SetSize({
		width = UI.Frame:GetWidth(),
		height = UI.Frame:GetHeight(),
	})
end

local function UpdateSavedPoint()
	local anchorPoint, relativeTo, relativePoint, xOffset, yOffset = UI.Frame:GetPoint()
	addon.Database:SetPoint({
		anchorPoint = anchorPoint,
		relativeTo = relativeTo,
		relativePoint = relativePoint,
		xOffset = xOffset,
		yOffset = yOffset,
	})
end

local function MakeFrameMoveable()
	local isMoving = false
	UI.Frame:SetMovable(true)

	UI.Frame.TitleBg:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			UI.Frame:StartMoving()
			isMoving = true
		end
	end)

	UI.Frame.TitleBg:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" and isMoving then
			UI.Frame:StopMovingOrSizing()
			UpdateSavedPoint()
			isMoving = false
		end
	end)

	UI.Frame.TitleBg:SetScript("OnEnter", function()
		SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	end)

	UI.Frame.TitleBg:SetScript("OnLeave", ResetCursor)
end

local function MakeFrameResizable()
	local isSizing = false
	UI.Frame:SetResizable(true)
	UI.Frame:SetResizeBounds(100, 100)

	local function onBorderOrCornerMouseDown(button, framePoint)
		if button == "LeftButton" then
			UI.Frame:StartSizing(framePoint)
			isSizing = true
		end
	end

	local function onBorderOrCornerMouseUp(_, button)
		if button == "LeftButton" and isSizing then
			UI.Frame:StopMovingOrSizing()
			UpdateSavedSize()
			UpdateSavedPoint()
			isSizing = false
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
	UI.Frame.ScrollingEditBox.ScrollBox.EditBox:SetFontObject(addon.Database:GetFont())
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

function UI:ResetSize()
	local size = addon.Database:GetInitialSize()
	UI.Frame:SetSize(size.width, size.height)
	UpdateSavedSize()
	UpdateSavedPoint()
end

function UI:ResetPosition()
	local point = addon.Database:GetInitialPoint()
	UI.Frame:ClearAllPoints()
	UI.Frame:SetPoint(point.anchorPoint, point.relativeTo, point.relativePoint, point.xOffset, point.yOffset)
	UpdateSavedPoint()
end

function UI:SetFont(font)
	UI.Frame.ScrollingEditBox.ScrollBox.EditBox:SetFontObject(font)
end

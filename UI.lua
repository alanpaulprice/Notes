local addonName, addon = ...
addon.UI = {}
local UI = addon.UI

local isSizing = false

local function UpdateTitleText()
	local currentNote = addon.Database:GetCurrentNote()
	local prefix = addonName .. " - "
	if currentNote == nil then
		UI.Frame.TitleContainer.TitleText:SetText(prefix .. "Manage")
	else
		UI.Frame.TitleContainer.TitleText:SetText(prefix .. currentNote.title)
	end
end

local function CreateRootFrame()
	UI.Frame = CreateFrame("Frame", addonName .. "_UI", UIParent, "ButtonFrameTemplate")

	local size = addon.Database:GetSize()
	UI.Frame:SetSize(size.width, size.height)
	local point = addon.Database:GetPoint()
	UI.Frame:SetPoint(point.anchorPoint, point.relativeTo, point.relativePoint, point.xOffset, point.yOffset)
	UI.Frame:EnableMouse(true)

	ButtonFrameTemplate_HidePortrait(UI.Frame)
	UI.Frame.TopTileStreaks:Hide()
	UI.Frame.Inset:SetPoint("TOPLEFT", UI.Frame, "TOPLEFT", 9, -26)

	UpdateTitleText()

	UI.Frame.ManageButton = CreateFrame("Button", nil, UI.Frame, "UIPanelButtonTemplate")
	UI.Frame.ManageButton:SetPoint("BOTTOM", UI.Frame, "BOTTOM", 0, 4)
	UI.Frame.ManageButton:SetText("Manage Notes")
	UI.Frame.ManageButton:FitToText()
	UI.Frame.ManageButton:SetScript("OnClick", function()
		UI:ChangeView(addon.Constants.UI_VIEW_ENUM.MANAGE)
	end)
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

	UI.Frame.TitleContainer:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			UI.Frame:StartMoving()
			isMoving = true
		end
	end)

	UI.Frame.TitleContainer:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" and isMoving then
			UI.Frame:StopMovingOrSizing()
			UpdateSavedPoint()
			isMoving = false
		end
	end)

	-- UI.Frame.TitleContainer:SetScript("OnEnter", function()
	-- 	SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	-- end)

	-- UI.Frame.TitleContainer:SetScript("OnLeave", ResetCursor)
end

local function StartSizing(self, button)
	if button == "LeftButton" then
		UI.Frame:StartSizing(self.sizingDirection)
		isSizing = true
	end
end

local function StopSizing(_, button)
	if button == "LeftButton" and isSizing then
		UI.Frame:StopMovingOrSizing()
		UpdateSavedSize()
		UpdateSavedPoint()
		isSizing = false
	end
end

local function CreateResizeHandleBottomLeft()
	UI.Frame.ResizeHandleBottomLeft = CreateFrame("Button", nil, UI.Frame)
	UI.Frame.ResizeHandleBottomLeft:SetSize(16, 16)
	UI.Frame.ResizeHandleBottomLeft:SetPoint("BOTTOMLEFT", UI.Frame, "BOTTOMLEFT", 7, 4)

	local resizeHandleBottomLeftUpTexture = UI.Frame.ResizeHandleBottomLeft:CreateTexture()
	resizeHandleBottomLeftUpTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	resizeHandleBottomLeftUpTexture:SetTexCoord(1, 0, 0, 1)
	resizeHandleBottomLeftUpTexture:SetAllPoints(UI.Frame.ResizeHandleBottomLeft)
	UI.Frame.ResizeHandleBottomLeft:SetNormalTexture(resizeHandleBottomLeftUpTexture)

	local resizeHandleBottomLeftHighlightTexture = UI.Frame.ResizeHandleBottomLeft:CreateTexture()
	resizeHandleBottomLeftHighlightTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	resizeHandleBottomLeftHighlightTexture:SetTexCoord(1, 0, 0, 1)
	resizeHandleBottomLeftHighlightTexture:SetAllPoints(UI.Frame.ResizeHandleBottomLeft)
	UI.Frame.ResizeHandleBottomLeft:SetHighlightTexture(resizeHandleBottomLeftHighlightTexture)

	local resizeHandleBottomLeftDownTexture = UI.Frame.ResizeHandleBottomLeft:CreateTexture()
	resizeHandleBottomLeftDownTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	resizeHandleBottomLeftDownTexture:SetTexCoord(1, 0, 0, 1)
	resizeHandleBottomLeftDownTexture:SetAllPoints(UI.Frame.ResizeHandleBottomLeft)
	UI.Frame.ResizeHandleBottomLeft:SetPushedTexture(resizeHandleBottomLeftDownTexture)

	UI.Frame.ResizeHandleBottomLeft.sizingDirection = "BOTTOMLEFT"
	UI.Frame.ResizeHandleBottomLeft:SetScript("OnMouseDown", StartSizing)
	UI.Frame.ResizeHandleBottomLeft:SetScript("OnMouseUp", StopSizing)
end

local function CreateResizeHandleBottomRight()
	UI.Frame.ResizeHandleBottomRight = CreateFrame("Button", nil, UI.Frame)
	UI.Frame.ResizeHandleBottomRight:SetSize(16, 16)
	UI.Frame.ResizeHandleBottomRight:SetPoint("BOTTOMRIGHT", UI.Frame, "BOTTOMRIGHT", -4, 4)
	UI.Frame.ResizeHandleBottomRight:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	UI.Frame.ResizeHandleBottomRight:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	UI.Frame.ResizeHandleBottomRight:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	UI.Frame.ResizeHandleBottomRight.sizingDirection = "BOTTOMRIGHT"
	UI.Frame.ResizeHandleBottomRight:SetScript("OnMouseDown", StartSizing)
	UI.Frame.ResizeHandleBottomRight:SetScript("OnMouseUp", StopSizing)
end

local function MakeFrameResizable()
	UI.Frame:SetResizable(true)
	UI.Frame:SetResizeBounds(200, 200)
	CreateResizeHandleBottomLeft()
	CreateResizeHandleBottomRight()
end

local function CreateViewContainer()
	UI.Frame.ViewContainer = CreateFrame("Frame", nil, UI.Frame, nil)
	UI.Frame.ViewContainer:SetPoint("TOPLEFT", UI.Frame.Inset, "TOPLEFT", 2, -2)
	UI.Frame.ViewContainer:SetPoint("BOTTOMRIGHT", UI.Frame.Inset, "BOTTOMRIGHT", -2, 2)
end

function UI:ShowManageView()
	addon.Database.SetCurrentNote(nil)
	UI.Frame.ViewContainer.EditView:Hide()
	UI.Frame.ViewContainer.ManageView:Show()
end

function UI:Initialize()
	CreateRootFrame()
	MakeFrameMoveable()
	MakeFrameResizable()
	CreateViewContainer()
	addon.EditView:Initialize()
	addon.ManageView:Initialize()
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

function UI:ChangeView(newView, noteId)
	addon.Utilities:CheckIsEnumMember(newView, addon.Constants.UI_VIEW_ENUM)

	if newView == addon.Constants.UI_VIEW_ENUM.EDIT then
		addon.Utilities:CheckType(noteId, "number")
		addon.Database:SetCurrentNoteId(noteId)
		addon.ManageView:Hide()
		addon.EditView:Show()
	end

	if newView == addon.Constants.UI_VIEW_ENUM.MANAGE then
		addon.Database:SetCurrentNoteId(nil)
		addon.EditView:Hide()
		addon.ManageView:Show()
	end

	UpdateTitleText()
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

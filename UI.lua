local addonName, addon = ...
addon.UI = {}
local UI = addon.UI

local isSizing = false

local function UpdateTitleText()
	local currentNote = addon.Database:GetCurrentNote()

	if currentNote == nil then
		UI.Frame.TitleContainer.TitleText:SetText(addonName)
	else
		UI.Frame.TitleContainer.TitleText:SetText(currentNote.title)
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

	UI.Frame.TitleContainer:ClearAllPoints()
	UI.Frame.TitleContainer:SetPoint("TOPLEFT", UI.Frame, "TOPLEFT", 11, 0)
	UI.Frame.TitleContainer:SetPoint("BOTTOMRIGHT", UI.Frame.CloseButton, "BOTTOMLEFT", -4, 0)

	UI.Frame.CloseButton:SetScript("OnClick", UI.Toggle)

	UpdateTitleText()
end

local function UpdateSavedWidth(width)
	addon.Database:SetWidth(width)
end

local function UpdateSavedHeight(height)
	addon.Database:SetHeight(height)
end

local function UpdateSavedPoint(point)
	addon.Database:SetPoint({
		anchorPoint = point.anchorPoint,
		relativeTo = point.relativeTo,
		relativePoint = point.relativePoint,
		xOffset = point.xOffset,
		yOffset = point.yOffset,
	})
end

local function MakeFrameMoveable()
	local isMoving = false
	UI.Frame:SetMovable(true)

	local moveHandle = addon.Utilities:RunCallbackForGameVersion({
		mainline = function()
			return UI.Frame.TitleContainer
		end,
		classic = function()
			return UI.Frame.TitleBg
		end,
	})

	moveHandle:SetScript("OnMouseDown", function(_, button)
		local locked = addon.Database:GetLocked()

		if button == "LeftButton" and locked == false then
			UI.Frame:StartMoving()
			isMoving = true
		end
	end)

	moveHandle:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" and isMoving then
			UI.Frame:StopMovingOrSizing()
			local anchorPoint, relativeTo, relativePoint, xOffset, yOffset = UI.Frame:GetPoint()
			UpdateSavedPoint({
				anchorPoint = anchorPoint,
				relativeTo = relativeTo,
				relativePoint = relativePoint,
				xOffset = xOffset,
				yOffset = yOffset,
			})
			addon.Options:UpdatePointControls()
			isMoving = false
		end
	end)

	-- UI.Frame.TitleContainer:SetScript("OnEnter", function()
	-- 	SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	-- end)

	-- UI.Frame.TitleContainer:SetScript("OnLeave", ResetCursor)
end

local function StartSizing(self, button)
	local locked = addon.Database:GetLocked()

	if button == "LeftButton" and locked == false then
		UI.Frame:StartSizing(self.sizingDirection)
		isSizing = true
	end
end

local function StopSizing(_, button)
	if button == "LeftButton" and isSizing then
		UI.Frame:StopMovingOrSizing()
		UpdateSavedWidth(UI.Frame:GetWidth())
		UpdateSavedHeight(UI.Frame:GetHeight())
		addon.Options:UpdateSizeControls()
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
	UI.Frame:SetResizeBounds(
		addon.Constants.MIN_UI_WIDTH,
		addon.Constants.MIN_UI_HEIGHT,
		addon.Constants.MAX_UI_WIDTH,
		addon.Constants.MAX_UI_HEIGHT
	)
	CreateResizeHandleBottomLeft()
	CreateResizeHandleBottomRight()
end

local function CreateViewContainer()
	UI.Frame.ViewContainer = CreateFrame("Frame", nil, UI.Frame, nil)
	UI.Frame.ViewContainer:SetPoint("TOPLEFT", UI.Frame.Inset, "TOPLEFT", 2, -2)
	UI.Frame.ViewContainer:SetPoint("BOTTOMRIGHT", UI.Frame.Inset, "BOTTOMRIGHT", -2, 2)
end

local function CreateManageButton()
	UI.Frame.ManageButton = CreateFrame("Button", nil, UI.Frame, "UIPanelButtonTemplate")

	if addon.Database:GetCurrentNoteId() == nil then
		UI.Frame.ManageButton:Hide()
	end

	UI.Frame.ManageButton:SetPoint("BOTTOM", UI.Frame, "BOTTOM", 0, 4)
	UI.Frame.ManageButton:SetText("Manage Notes")
	UI.Frame.ManageButton:FitToText()
	UI.Frame.ManageButton:SetScript("OnClick", function()
		UI:ChangeView(addon.Constants.UI_VIEW_ENUM.MANAGE)
	end)
end

local function CreateCreateButton()
	UI.Frame.CreateButton = CreateFrame("Button", nil, UI.Frame, "UIPanelButtonTemplate")

	if addon.Database:GetCurrentNoteId() ~= nil then
		UI.Frame.CreateButton:Hide()
	end

	UI.Frame.CreateButton:SetPoint("BOTTOM", UI.Frame, "BOTTOM", 0, 4)
	UI.Frame.CreateButton:SetText("Create Note")
	UI.Frame.CreateButton:FitToText()
	UI.Frame.CreateButton:SetScript("OnClick", function()
		StaticPopup_ShowCustomGenericInputBox({
			text = "Note Title",
			callback = function(noteTitle)
				local newNote = addon.Database:CreateNote(noteTitle)
				UI:ChangeView(addon.Constants.UI_VIEW_ENUM.EDIT, newNote.id)
			end,
			acceptText = "Create",
			maxLetters = addon.Constants.NOTE_TITLE_MAX_LENGTH,
			countInvisibleLetters = true,
		})
	end)
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
	CreateManageButton()
	CreateCreateButton()
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
		UI.Frame.CreateButton:Hide()
		addon.EditView:Show()
		UI.Frame.ManageButton:Show()
	end

	if newView == addon.Constants.UI_VIEW_ENUM.MANAGE then
		addon.Database:SetCurrentNoteId(nil)
		addon.EditView:Hide()
		UI.Frame.ManageButton:Hide()
		addon.ManageView:Show()
		UI.Frame.CreateButton:Show()
	end

	UpdateTitleText()
end

function UI:SetWidth(width)
	if UI.Frame then
		UI.Frame:SetWidth(width)
	end

	UpdateSavedWidth(width)
end

function UI:SetHeight(height)
	if UI.Frame then
		UI.Frame:SetHeight(height)
	end

	UpdateSavedHeight(height)
	addon.Options:UpdateSizeControls()
end

function UI:ResetSize()
	if UI.Frame then
		UI.Frame:SetSize(addon.Constants.DEFAULT_UI_WIDTH, addon.Constants.DEFAULT_UI_HEIGHT)
	end

	UpdateSavedWidth(addon.Constants.DEFAULT_UI_WIDTH)
	UpdateSavedHeight(addon.Constants.DEFAULT_UI_HEIGHT)
end

function UI:SetPoint(point)
	if UI.Frame then
		UI.Frame:ClearAllPoints()
		UI.Frame:SetPoint(point.anchorPoint, point.relativeTo, point.relativePoint, point.xOffset, point.yOffset)
	end

	UpdateSavedPoint(point)
	addon.Options:UpdatePointControls()
end

function UI:ResetPoint()
	self:SetPoint({
		anchorPoint = "CENTER",
		relativeTo = nil,
		relativePoint = "CENTER",
		xOffset = 0,
		yOffset = 0,
	})
end

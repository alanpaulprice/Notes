local addonName, addon = ...
addon.UI = {}
local UI = addon.UI

local isSizing = false

local function CreateRootFrame()
	UI.Frame = CreateFrame("Frame", nil, UIParent, "ButtonFrameTemplate")

	local size = addon.Database:GetSize()
	UI.Frame:SetSize(size.width, size.height)
	local point = addon.Database:GetPoint()
	UI.Frame:SetPoint(point.anchorPoint, point.relativeTo, point.relativePoint, point.xOffset, point.yOffset)
	UI.Frame:EnableMouse(true)

	ButtonFrameTemplate_HidePortrait(UI.Frame)
	UI.Frame.TopTileStreaks:Hide()
	UI.Frame.Inset:SetPoint("TOPLEFT", UI.Frame, "TOPLEFT", 9, -26)

	UI.Frame.TitleContainer.TitleText:SetText(addonName .. " - Lorem Ipsum Dolor Sit")

	UI.Frame.ManageButton = CreateFrame("Button", nil, UI.Frame, "UIPanelButtonTemplate")
	UI.Frame.ManageButton:SetPoint("BOTTOM", UI.Frame, "BOTTOM", 0, 4)
	UI.Frame.ManageButton:SetText("Manage Notes")
	UI.Frame.ManageButton:FitToText()
	UI.Frame.ManageButton:SetScript("OnClick", UI.ToggleView)
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

local function CreateEditView()
	local currentNote = addon.Database.GetCurrentNote()

	-- Create the parent frame.
	UI.Frame.ViewContainer.EditView = CreateFrame("Frame", nil, UI.Frame.ViewContainer, nil)
	UI.Frame.ViewContainer.EditView:SetAllPoints(UI.Frame.ViewContainer)

	if currentNote == nil then
		UI.Frame.ViewContainer.EditView:Hide()
	end

	local EditView = UI.Frame.ViewContainer.EditView

	-- Create the scrolling edit box.
	EditView.ScrollingEditBox = CreateFrame("Frame", nil, EditView, "ScrollingEditBoxTemplate")
	EditView.ScrollingEditBox:SetPoint("TOPLEFT", EditView, "TOPLEFT", 0, 0)
	EditView.ScrollingEditBox:SetPoint("BOTTOMRIGHT", EditView, "BOTTOMRIGHT", -17, 0)
	EditView.ScrollingEditBox.ScrollBox.EditBox:SetFontObject(addon.Database:GetFont())
	EditView.ScrollingEditBox.ScrollBox.EditBox:SetTextInsets(8, 8, 8, 8)

	if currentNote ~= nil then
		EditView.ScrollingEditBox.ScrollBox.EditBox:SetText(currentNote.body)
	end

	-- Configure handling of text changes for the scrolling edit box.
	local function OnTextChange(owner, editBox, userChanged)
		addon.Database:SetNote(editBox:GetInputText())
	end
	EditView.ScrollingEditBox:RegisterCallback("OnTextChanged", OnTextChange, self)

	-- Create and configure the scroll bar.
	EditView.ScrollBar = CreateFrame("EventFrame", nil, EditView, "MinimalScrollBar")
	EditView.ScrollBar:SetPoint("TOPLEFT", EditView.ScrollingEditBox, "TOPRIGHT", 0, -4)
	EditView.ScrollBar:SetPoint("BOTTOMLEFT", EditView.ScrollingEditBox, "BOTTOMRIGHT", 0, 4)

	ScrollUtil.RegisterScrollBoxWithScrollBar(EditView.ScrollingEditBox.ScrollBox, EditView.ScrollBar)
end

local function CreateManageView()
	-- Create the parent frame.
	UI.Frame.ViewContainer.ManageView = CreateFrame("Frame", nil, UI.Frame.ViewContainer, nil)
	UI.Frame.ViewContainer.ManageView:SetAllPoints(UI.Frame.ViewContainer)

	if addon.Database.GetCurrentNote() ~= nil then
		UI.Frame.ViewContainer.ManageView:Hide()
	end

	local ManageView = UI.Frame.ViewContainer.ManageView

	-- Create the scroll box.
	ManageView.ScrollBox = CreateFrame("Frame", nil, ManageView, "WowScrollBoxList")
	ManageView.ScrollBox:SetPoint("TOPLEFT", ManageView, "TOPLEFT", 0, 0)
	ManageView.ScrollBox:SetPoint("BOTTOMRIGHT", ManageView, "BOTTOMRIGHT", -17, 0)

	-- Create and configure the scroll bar.
	ManageView.ScrollBar = CreateFrame("EventFrame", nil, ManageView, "MinimalScrollBar")
	ManageView.ScrollBar:SetPoint("TOPLEFT", ManageView.ScrollBox, "TOPRIGHT", 0, -4)
	ManageView.ScrollBar:SetPoint("BOTTOMLEFT", ManageView.ScrollBox, "BOTTOMRIGHT", 0, 4)

	--TODO
	-- view:SetElementInitializer("FriendsFriendsButtonTemplate", function(button, elementData)
	-- 	FriendsFriends_InitButton(button, elementData)
	-- end)

	local function InitButton(button, elementData)
		-- print(addon.Utilities:PrintTableKeys(elementData.title))
		-- print(addon.Utilities:PrintTableKeys(elementData))`
		button.name:SetText(elementData.title)

		----------------------------------------------------------------------------------------------------------------
		-- button.index = elementData.index

		-- if elementData.squelchType == SQUELCH_TYPE_IGNORE then
		-- 	local name = C_FriendList.GetIgnoreName(button.index)
		-- 	if not name then
		-- 		button.name:SetText(UNKNOWN)
		-- 	else
		-- 		button.name:SetText(name)
		-- 		button.type = SQUELCH_TYPE_IGNORE
		-- 	end
		-- elseif elementData.squelchType == SQUELCH_TYPE_BLOCK_INVITE then
		-- 	local blockID, blockName = BNGetBlockedInfo(button.index)
		-- 	button.name:SetText(blockName)
		-- 	button.type = SQUELCH_TYPE_BLOCK_INVITE
		-- end

		-- local selectedSquelchType, selectedSquelchIndex = IgnoreList_GetSelected()
		-- local selected = (selectedSquelchType == button.type) and (selectedSquelchIndex == button.index)
		-- IgnoreList_SetButtonSelected(button, selected)
	end

	local function Update()
		local dataProvider = CreateDataProvider()
		local notes = addon.Database:GetNotes()

		for id, note in pairs(notes) do
			dataProvider:Insert({ id = id, title = note.title })
		end

		ManageView.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition)
	end

	local view = CreateScrollBoxListLinearView()
	view:SetElementFactory(function(factory, elementData)
		if elementData.header then
			factory(elementData.header)
		else
			factory("IgnoreListButtonTemplate", InitButton)
		end
	end)

	ScrollUtil.InitScrollBoxListWithScrollBar(ManageView.ScrollBox, ManageView.ScrollBar, view)
	Update()
end

function UI:Initialize()
	CreateRootFrame()
	MakeFrameMoveable()
	MakeFrameResizable()
	CreateViewContainer()
	CreateEditView()
	CreateManageView()
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

function UI:ShowManageView()
	addon.Database.SetCurrentNote(nil)
	UI.Frame.ViewContainer.EditView:Hide()
	UI.Frame.ViewContainer.ManageView:Show()
end

function UI:ShowEditView(noteId)
	local note = addon.Database.GetNote(noteId)
	--TODO
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

local addonName, addon = ...
addon.Options = {}
local Options = addon.Options

local fontOptions = {
	{
		text = "Small",
		value = "GameFontHighlightSmall",
	},
	{
		text = "Medium",
		value = "GameFontHighlight",
	},
	{
		text = "Large",
		value = "GameFontHighlightMedium",
	},
	{
		text = "Extra Large",
		value = "GameFontHighlightLarge",
	},
}

local pointOptions = {
	{
		text = "Top",
		value = "TOP",
	},
	{
		text = "Top Right",
		value = "TOPRIGHT",
	},
	{
		text = "Right",
		value = "RIGHT",
	},
	{
		text = "Bottom Right",
		value = "BOTTOMRIGHT",
	},
	{
		text = "Bottom",
		value = "BOTTOM",
	},
	{
		text = "Bottom Left",
		value = "BOTTOMLEFT",
	},
	{
		text = "Left",
		value = "LEFT",
	},
	{
		text = "Top Left",
		value = "TOPLEFT",
	},
	{
		text = "Center",
		value = "CENTER",
	},
}

local function CreateRootFrame()
	Options.Frame = CreateFrame("Frame", nil, nil, nil)
	Options.Frame:Hide()
	Options.Frame.name = addonName
	InterfaceOptions_AddCategory(Options.Frame)

	Options.Frame.Title = Options.Frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	Options.Frame.Title:SetPoint("TOPLEFT", 16, -16)
	Options.Frame.Title:SetText(addonName)
end

local function CreateShowAtLoginButtonCheckbox()
	local function onClick(_, checked)
		addon.Database:SetShowAtLogin(checked)
	end

	Options.Frame.ShowAtLoginCheckButton =
		addon.Utilities:CreateInterfaceOptionsCheckButton("Show at Login", Options.Frame, onClick)
	Options.Frame.ShowAtLoginCheckButton:SetPoint("TOPLEFT", Options.Frame.Title, "BOTTOMLEFT", -2, -16)
	Options.Frame.ShowAtLoginCheckButton:SetChecked(addon.Database:GetShowAtLogin())
end

local function CreateShowMinimapButtonCheckbox()
	local function onClick(_, checked)
		if checked then
			addon.MinimapButton:Show()
		else
			addon.MinimapButton:Hide()
		end
	end

	Options.Frame.ShowMinimapCheckButton =
		addon.Utilities:CreateInterfaceOptionsCheckButton("Minimap Button", Options.Frame, onClick)
	Options.Frame.ShowMinimapCheckButton:SetPoint("TOPLEFT", Options.Frame.ShowAtLoginCheckButton, "BOTTOMLEFT", 0, -16)
	Options.Frame.ShowMinimapCheckButton:SetChecked(not addon.Database:GetMinimapButtonHidden())
end

local function CreateFontSizeDropDownMenu()
	Options.Frame.FontSizeLabel = Options.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Options.Frame.FontSizeLabel:SetPoint("TOPLEFT", Options.Frame.ShowMinimapCheckButton, "BOTTOMLEFT", 2.5, -16)
	Options.Frame.FontSizeLabel:SetText("Font Size")

	Options.Frame.FontSizeDropDownMenu = CreateFrame("Frame", nil, Options.Frame, "UIDropDownMenuTemplate")
	Options.Frame.FontSizeDropDownMenu:SetPoint("TOPLEFT", Options.Frame.FontSizeLabel, "BOTTOMLEFT", -18, -4)

	local function OnDropdownMenuOptionClick(self)
		UIDropDownMenu_SetSelectedID(Options.Frame.FontSizeDropDownMenu, self:GetID())
		local font = fontOptions[Options.Frame.FontSizeDropDownMenu.selectedID].value
		addon.Database:SetFont(font)
		addon.EditView:SetFont(font)
	end

	local selectedOptionId = nil

	local function Initialize()
		local info = UIDropDownMenu_CreateInfo()
		local currentFont = addon.Database:GetFont()

		for index, option in ipairs(fontOptions) do
			info.text = option.text
			info.func = OnDropdownMenuOptionClick
			info.checked = nil
			UIDropDownMenu_AddButton(info)

			if option.value == currentFont then
				selectedOptionId = index
			end
		end
	end

	UIDropDownMenu_Initialize(Options.Frame.FontSizeDropDownMenu, Initialize)
	UIDropDownMenu_SetSelectedID(Options.Frame.FontSizeDropDownMenu, selectedOptionId)
	UIDropDownMenu_JustifyText(Options.Frame.FontSizeDropDownMenu, "LEFT")
end

local function CreateSizeControls()
	local size = addon.Database:GetSize()

	Options.Frame.WidthLabel = Options.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Options.Frame.WidthLabel:SetPoint("TOPLEFT", Options.Frame.FontSizeDropDownMenu, "BOTTOMLEFT", 18.5, -16)
	Options.Frame.WidthLabel:SetText("Width")

	Options.Frame.WidthInput = CreateFrame("EditBox", nil, Options.Frame, "InputBoxTemplate")
	Options.Frame.WidthInput:SetPoint("TOPLEFT", Options.Frame.WidthLabel, "BOTTOMLEFT", 4.5, -8)
	Options.Frame.WidthInput:SetSize(112, 16)
	Options.Frame.WidthInput:SetAutoFocus(false)
	Options.Frame.WidthInput:SetText(size.width)
	Options.Frame.WidthInput:SetScript("OnEnterPressed", function(self)
		local currentWidth = addon.Database:GetWidth()
		local width = tonumber(self:GetText())

		if width == nil then
			self:SetText(currentWidth)
		else
			width = addon.Utilities:RoundNumberDecimal(width, 10, true)
			width = addon.Utilities:ClampNumber(width, addon.Constants.MIN_UI_WIDTH, addon.Constants.MAX_UI_WIDTH)
			addon.UI:SetWidth(width)
			self:SetText(width)
		end

		EditBox_HighlightText(self)
	end)

	Options.Frame.HeightLabel = Options.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Options.Frame.HeightLabel:SetPoint("BOTTOMLEFT", Options.Frame.WidthInput, "TOPRIGHT", 20.5, 8)
	Options.Frame.HeightLabel:SetText("Height")

	Options.Frame.HeightInput = CreateFrame("EditBox", nil, Options.Frame, "InputBoxTemplate")
	Options.Frame.HeightInput:SetPoint("TOPLEFT", Options.Frame.HeightLabel, "BOTTOMLEFT", 4.5, -8)
	Options.Frame.HeightInput:SetSize(112, 16)
	Options.Frame.HeightInput:SetAutoFocus(false)
	Options.Frame.HeightInput:SetText(size.height)
	Options.Frame.HeightInput:SetScript("OnEnterPressed", function(self)
		local currentHeight = addon.Database:GetHeight()
		local height = tonumber(self:GetText())

		if height == nil then
			self:SetText(currentHeight)
		else
			height = addon.Utilities:RoundNumberDecimal(height, 10, true)
			height = addon.Utilities:ClampNumber(height, addon.Constants.MIN_UI_HEIGHT, addon.Constants.MAX_UI_HEIGHT)
			addon.UI:SetHeight(height)
			self:SetText(height)
		end

		EditBox_HighlightText(self)
	end)

	Options.Frame.ResetSizeButton = CreateFrame("Button", nil, Options.Frame, "UIPanelButtonTemplate")
	Options.Frame.ResetSizeButton:SetPoint("BOTTOMLEFT", Options.Frame.HeightInput, "BOTTOMRIGHT", 16, 0)
	Options.Frame.ResetSizeButton:SetText("Reset Size")
	Options.Frame.ResetSizeButton:FitToText()
	Options.Frame.ResetSizeButton:SetScript("OnClick", function()
		addon.UI.ResetSize()
	end)
end

local function CreatePointControls()
	local point = addon.Database:GetPoint()

	Options.Frame.AnchorPointLabel = Options.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Options.Frame.AnchorPointLabel:SetPoint("TOPLEFT", Options.Frame.WidthInput, "BOTTOMLEFT", -4.5, -16)
	Options.Frame.AnchorPointLabel:SetText("Anchor Point")

	Options.Frame.AnchorPointDropDownMenu = CreateFrame("Frame", nil, Options.Frame, "UIDropDownMenuTemplate")
	Options.Frame.AnchorPointDropDownMenu:SetPoint("TOPLEFT", Options.Frame.AnchorPointLabel, "BOTTOMLEFT", -18, -4)

	local function OnDropdownMenuOptionClick(self)
		UIDropDownMenu_SetSelectedID(Options.Frame.AnchorPointDropDownMenu, self:GetID())
		local anchorPoint = pointOptions[Options.Frame.AnchorPointDropDownMenu.selectedID].value
		local currentPoint = addon.Database:GetPoint()
		addon.UI:SetPoint({
			anchorPoint = anchorPoint,
			relativeTo = currentPoint.relativeTo,
			relativePoint = anchorPoint,
			xOffset = currentPoint.xOffset,
			yOffset = currentPoint.yOffset,
		})
	end

	local selectedOptionId = nil

	local function Initialize()
		local info = UIDropDownMenu_CreateInfo()
		local currentAnchorPoint = addon.Database:GetPoint().anchorPoint

		for index, option in ipairs(pointOptions) do
			info.text = option.text
			info.func = OnDropdownMenuOptionClick
			info.checked = nil
			UIDropDownMenu_AddButton(info)

			if option.value == currentAnchorPoint then
				selectedOptionId = index
			end
		end
	end

	UIDropDownMenu_Initialize(Options.Frame.AnchorPointDropDownMenu, Initialize)
	UIDropDownMenu_SetSelectedID(Options.Frame.AnchorPointDropDownMenu, selectedOptionId)
	UIDropDownMenu_JustifyText(Options.Frame.AnchorPointDropDownMenu, "LEFT")

	Options.Frame.PointXOffsetLabel = Options.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Options.Frame.PointXOffsetLabel:SetPoint(
		"BOTTOMLEFT",
		Options.Frame.AnchorPointDropDownMenu.Button,
		"TOPRIGHT",
		16,
		4
	)
	Options.Frame.PointXOffsetLabel:SetText("X Offset")

	Options.Frame.PointXOffsetInput = CreateFrame("EditBox", nil, Options.Frame, "InputBoxTemplate")
	Options.Frame.PointXOffsetInput:SetPoint("TOPLEFT", Options.Frame.PointXOffsetLabel, "BOTTOMLEFT", 4.5, -8)
	Options.Frame.PointXOffsetInput:SetSize(128, 16)
	Options.Frame.PointXOffsetInput:SetAutoFocus(false)
	Options.Frame.PointXOffsetInput:SetText(point.xOffset)
	Options.Frame.PointXOffsetInput:SetScript("OnEnterPressed", function(self)
		local currentPoint = addon.Database:GetPoint()
		local xOffset = tonumber(self:GetText())

		if xOffset == nil or xOffset > 9999 or xOffset < -9999 then
			self:SetText(currentPoint.xOffset)
		else
			xOffset = addon.Utilities:RoundNumberDecimal(xOffset, 12, true)
			addon.UI:SetPoint({
				anchorPoint = currentPoint.anchorPoint,
				relativeTo = currentPoint.relativeTo,
				relativePoint = currentPoint.anchorPoint,
				xOffset = xOffset,
				yOffset = currentPoint.yOffset,
			})
			self:SetText(xOffset)
		end

		EditBox_HighlightText(self)
	end)

	Options.Frame.PointYOffsetLabel = Options.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Options.Frame.PointYOffsetLabel:SetPoint("BOTTOMLEFT", Options.Frame.PointXOffsetInput, "TOPRIGHT", 20.5, 8)
	Options.Frame.PointYOffsetLabel:SetText("Y Offset")

	Options.Frame.PointYOffsetInput = CreateFrame("EditBox", nil, Options.Frame, "InputBoxTemplate")
	Options.Frame.PointYOffsetInput:SetPoint("TOPLEFT", Options.Frame.PointYOffsetLabel, "BOTTOMLEFT", 4.5, -8)
	Options.Frame.PointYOffsetInput:SetSize(128, 16)
	Options.Frame.PointYOffsetInput:SetAutoFocus(false)
	Options.Frame.PointYOffsetInput:SetText(point.yOffset)
	Options.Frame.PointYOffsetInput:SetScript("OnEnterPressed", function(self)
		local currentPoint = addon.Database:GetPoint()
		local yOffset = tonumber(self:GetText())

		if yOffset == nil or yOffset > 9999 or yOffset < -9999 then
			self:SetText(currentPoint.yOffset)
		else
			yOffset = addon.Utilities:RoundNumberDecimal(yOffset, 12, true)
			addon.UI:SetPoint({
				anchorPoint = currentPoint.anchorPoint,
				relativeTo = currentPoint.relativeTo,
				relativePoint = currentPoint.anchorPoint,
				xOffset = currentPoint.xOffset,
				yOffset = yOffset,
			})
			self:SetText(yOffset)
		end

		EditBox_HighlightText(self)
	end)

	Options.Frame.ResetPointButton = CreateFrame("Button", nil, Options.Frame, "UIPanelButtonTemplate")
	Options.Frame.ResetPointButton:SetPoint("BOTTOMLEFT", Options.Frame.PointYOffsetInput, "BOTTOMRIGHT", 16, 0)
	Options.Frame.ResetPointButton:SetText("Reset Position")
	Options.Frame.ResetPointButton:FitToText()
	Options.Frame.ResetPointButton:SetScript("OnClick", function()
		addon.UI:ResetPoint()
	end)
end

local function CreateLockedButtonCheckbox()
	local function onClick(_, checked)
		addon.Database:SetLocked(checked)
	end

	Options.Frame.LockedCheckButton = addon.Utilities:CreateInterfaceOptionsCheckButton(
		"Lock Resizing and Repositioning via Dragging",
		Options.Frame,
		onClick
	)
	Options.Frame.LockedCheckButton:SetPoint("TOPLEFT", Options.Frame.AnchorPointDropDownMenu, "BOTTOMLEFT", 18.5, -16)
	Options.Frame.LockedCheckButton:SetChecked(addon.Database:GetLocked())
end

function Options:Initialize()
	CreateRootFrame()
	CreateShowAtLoginButtonCheckbox()
	CreateShowMinimapButtonCheckbox()
	CreateFontSizeDropDownMenu()
	CreateSizeControls()
	CreatePointControls()
	CreateLockedButtonCheckbox()
end

function Options:Open()
	InterfaceOptionsFrame_OpenToCategory(addonName)
end

function Options:UpdateSizeControls()
	if Options.Frame then
		local size = addon.Database:GetSize()
		Options.Frame.WidthInput:SetText(size.width)
		Options.Frame.HeightInput:SetText(size.height)
	end
end

function Options:UpdatePointControls()
	if Options.Frame then
		local point = addon.Database:GetPoint()
		local selectedOptionId = nil
		local currentAnchorPoint = addon.Database:GetPoint().anchorPoint

		for index, option in ipairs(pointOptions) do
			if option.value == currentAnchorPoint then
				selectedOptionId = index
			end
		end

		UIDropDownMenu_SetSelectedID(Options.Frame.AnchorPointDropDownMenu, selectedOptionId)
		UIDropDownMenu_SetText(Options.Frame.AnchorPointDropDownMenu, pointOptions[selectedOptionId].text)
		Options.Frame.PointXOffsetInput:SetText(point.xOffset)
		Options.Frame.PointYOffsetInput:SetText(point.yOffset)
	end
end

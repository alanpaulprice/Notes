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

local function CreateRootFrame()
	Options.Frame = CreateFrame("Frame", nil, nil, nil)
	Options.Frame:Hide()
	Options.Frame.name = addonName
	InterfaceOptions_AddCategory(Options.Frame)

	Options.Frame.Title = Options.Frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	Options.Frame.Title:SetPoint("TOPLEFT", 16, -16)
	Options.Frame.Title:SetText(addonName)
end

local function CreateResetPositionButton()
	Options.Frame.ResetPositionButton = CreateFrame("Button", nil, Options.Frame, "UIPanelButtonTemplate")
	Options.Frame.ResetPositionButton:SetPoint("TOPLEFT", Options.Frame.Title, "BOTTOMLEFT", -2, -16)
	Options.Frame.ResetPositionButton:SetText("Reset Position")
	Options.Frame.ResetPositionButton:FitToText()
	Options.Frame.ResetPositionButton:SetScript("OnClick", function()
		addon.UI.ResetPosition()
	end)
end

local function CreateResetSizeButton()
	Options.Frame.ResetSizeButton = CreateFrame("Button", nil, Options.Frame, "UIPanelButtonTemplate")
	Options.Frame.ResetSizeButton:SetPoint("LEFT", Options.Frame.ResetPositionButton, "RIGHT", 16, 0)
	Options.Frame.ResetSizeButton:SetText("Reset Size")
	Options.Frame.ResetSizeButton:FitToText()
	Options.Frame.ResetSizeButton:SetScript("OnClick", function()
		addon.UI.ResetSize()
	end)
end

local function CreateShowAtLoginButtonCheckbox()
	local function onClick(_, checked)
		addon.Database:SetShowAtLogin(checked)
	end

	Options.Frame.ShowAtLoginCheckButton =
		addon.Utilities:CreateInterfaceOptionsCheckButton("Show the Main Window at Login", Options.Frame, onClick)
	Options.Frame.ShowAtLoginCheckButton:SetPoint("TOPLEFT", Options.Frame.ResetPositionButton, "BOTTOMLEFT", 0, -16)
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
		addon.Utilities:CreateInterfaceOptionsCheckButton("Show the Minimap Button", Options.Frame, onClick)
	Options.Frame.ShowMinimapCheckButton:SetPoint("TOPLEFT", Options.Frame.ShowAtLoginCheckButton, "BOTTOMLEFT", 0, -16)
	Options.Frame.ShowMinimapCheckButton:SetChecked(not addon.Database:GetMinimapButtonHidden())
end

local function CreateFontSizeDropDownMenu()
	Options.Frame.FontSizeLabel = Options.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Options.Frame.FontSizeLabel:SetPoint("TOPLEFT", Options.Frame.ShowMinimapCheckButton, "BOTTOMLEFT", 4, -16)
	Options.Frame.FontSizeLabel:SetText("Font Size")

	Options.Frame.FontSizeDropDownMenu = CreateFrame("Frame", nil, Options.Frame, "UIDropDownMenuTemplate")
	Options.Frame.FontSizeDropDownMenu:SetPoint("TOPLEFT", Options.Frame.FontSizeLabel, "BOTTOMLEFT", -20, -4)

	local function OnDropdownMenuOptionClick(self)
		UIDropDownMenu_SetSelectedID(Options.Frame.FontSizeDropDownMenu, self:GetID())
		local font = fontOptions[Options.Frame.FontSizeDropDownMenu.selectedID].value
		addon.Database:SetFont(font)
		addon.UI:SetFont(font)
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

function Options:Initialize()
	CreateRootFrame()
	CreateResetPositionButton()
	CreateResetSizeButton()
	CreateShowAtLoginButtonCheckbox()
	CreateShowMinimapButtonCheckbox()
	CreateFontSizeDropDownMenu()
end

function Options:Open()
	InterfaceOptionsFrame_OpenToCategory(addonName)
end

local addonName, addon = ...
addon.Config = {}
local Config = addon.Config

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
	Config.Frame = CreateFrame("Frame", nil, nil, nil)
	Config.Frame:Hide()
	Config.Frame.name = addonName
	InterfaceOptions_AddCategory(Config.Frame)

	Config.Frame.Title = Config.Frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	Config.Frame.Title:SetPoint("TOPLEFT", 16, -16)
	Config.Frame.Title:SetText(addonName)
end

local function CreateResetPositionButton()
	Config.Frame.ResetPositionButton = CreateFrame("Button", nil, Config.Frame, "UIPanelButtonTemplate")
	Config.Frame.ResetPositionButton:SetPoint("TOPLEFT", Config.Frame.Title, "BOTTOMLEFT", -2, -16)
	Config.Frame.ResetPositionButton:SetText("Reset Position")
	Config.Frame.ResetPositionButton:FitToText()
	Config.Frame.ResetPositionButton:SetScript("OnClick", function()
		addon.UI.ResetPosition()
	end)
end

local function CreateResetSizeButton()
	Config.Frame.ResetSizeButton = CreateFrame("Button", nil, Config.Frame, "UIPanelButtonTemplate")
	Config.Frame.ResetSizeButton:SetPoint("LEFT", Config.Frame.ResetPositionButton, "RIGHT", 16, 0)
	Config.Frame.ResetSizeButton:SetText("Reset Size")
	Config.Frame.ResetSizeButton:FitToText()
	Config.Frame.ResetSizeButton:SetScript("OnClick", function()
		addon.UI.ResetSize()
	end)
end

local function CreateShowAtLoginButtonCheckbox()
	local function onClick(_, checked)
		addon.Database:SetShowAtLogin(checked)
	end

	Config.Frame.ShowAtLoginCheckButton =
		addon.Utilities:CreateInterfaceOptionsCheckButton("Show at Login", Config.Frame, onClick)
	Config.Frame.ShowAtLoginCheckButton:SetPoint("TOPLEFT", Config.Frame.ResetPositionButton, "BOTTOMLEFT", 0, -16)
	Config.Frame.ShowAtLoginCheckButton:SetChecked(addon.Database:GetShowAtLogin())
end

local function CreateShowMinimapButtonCheckbox()
	local function onClick(_, checked)
		if checked then
			addon.MinimapButton:Show()
		else
			addon.MinimapButton:Hide()
		end
	end

	Config.Frame.ShowMinimapCheckButton =
		addon.Utilities:CreateInterfaceOptionsCheckButton("Show Minimap Button", Config.Frame, onClick)
	Config.Frame.ShowMinimapCheckButton:SetPoint("TOPLEFT", Config.Frame.ShowAtLoginCheckButton, "BOTTOMLEFT", 0, -16)
	Config.Frame.ShowMinimapCheckButton:SetChecked(not addon.Database:GetMinimapButtonHidden())
end

local function CreateFontSizeDropDownMenu()
	Config.Frame.FontSizeLabel = Config.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	Config.Frame.FontSizeLabel:SetPoint("TOPLEFT", Config.Frame.ShowMinimapCheckButton, "BOTTOMLEFT", 4, -16)
	Config.Frame.FontSizeLabel:SetText("Font Size")

	Config.Frame.FontSizeDropDownMenu = CreateFrame("Frame", nil, Config.Frame, "UIDropDownMenuTemplate")
	Config.Frame.FontSizeDropDownMenu:SetPoint("TOPLEFT", Config.Frame.FontSizeLabel, "BOTTOMLEFT", -20, -4)

	local function OnDropdownMenuOptionClick(self)
		UIDropDownMenu_SetSelectedID(Config.Frame.FontSizeDropDownMenu, self:GetID())
		local font = fontOptions[Config.Frame.FontSizeDropDownMenu.selectedID].value
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

	UIDropDownMenu_Initialize(Config.Frame.FontSizeDropDownMenu, Initialize)
	UIDropDownMenu_SetSelectedID(Config.Frame.FontSizeDropDownMenu, selectedOptionId)
	UIDropDownMenu_JustifyText(Config.Frame.FontSizeDropDownMenu, "LEFT")
end

function Config:Initialize()
	CreateRootFrame()
	CreateResetPositionButton()
	CreateResetSizeButton()
	CreateShowAtLoginButtonCheckbox()
	CreateShowMinimapButtonCheckbox()
	CreateFontSizeDropDownMenu()
end

function Config:Open()
	InterfaceOptionsFrame_OpenToCategory(addonName)
end

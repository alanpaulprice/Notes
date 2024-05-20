local addonName, addon = ...
addon.Config = {}
local Config = addon.Config

local function CreateRootFrame()
	Config.Frame = CreateFrame("Frame", addonName .. "_Config.Frame", nil, nil)
	Config.Frame:Hide()
	Config.Frame.name = addonName
	InterfaceOptions_AddCategory(Config.Frame)

	Config.Frame.Title = Config.Frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	Config.Frame.Title:SetPoint("TOPLEFT", 16, -16)
	Config.Frame.Title:SetText(addonName)
end

local function CreateResetPositionButton()
	Config.Frame.ResetPositionButton =
		CreateFrame("Button", addonName .. "_Config.Frame.ResetPositionButton", Config.Frame, "UIPanelButtonTemplate")
	Config.Frame.ResetPositionButton:SetPoint("TOPLEFT", Config.Frame.Title, "BOTTOMLEFT", -2, -16)
	Config.Frame.ResetPositionButton:SetText("Reset Position")
	Config.Frame.ResetPositionButton:FitToText()
	Config.Frame.ResetPositionButton:FitToText()
	Config.Frame.ResetPositionButton:SetScript("OnClick", function()
		addon.UI.ResetPosition()
	end)
end

local function CreateResetSizeButton()
	Config.Frame.ResetSizeButton =
		CreateFrame("Button", addonName .. "_Config.Frame.ResetSizeButton", Config.Frame, "UIPanelButtonTemplate")
	Config.Frame.ResetSizeButton:SetPoint("LEFT", Config.Frame.ResetPositionButton, "RIGHT", 16, 0)
	Config.Frame.ResetSizeButton:SetText("Reset Size")
	Config.Frame.ResetSizeButton:FitToText()
	Config.Frame.ResetSizeButton:SetScript("OnClick", function()
		addon.UI.ResetSize()
	end)
end

--TODO - probably remove, replaced by dropdown
--[[
local function CreateFontSizeControl()
	Config.Frame.FontSizeControl = CreateFrame("frame", addonName .. "_Config.Frame.FontSizeControl", Config.Frame)
	Config.Frame.FontSizeControl:SetPoint("TOP", Config.Frame.ResetSizeButton, "BOTTOM", 0, -10)
	Config.Frame.FontSizeControl:SetPoint("LEFT", Config.Frame.Bg, "LEFT", 10, 0)
	Config.Frame.FontSizeControl:SetPoint("RIGHT", Config.Frame.Bg, "RIGHT", -10, 0)
	Config.Frame.FontSizeControl:SetHeight(52)

	Config.Frame.FontSizeLabel = Config.Frame.FontSizeControl:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	Config.Frame.FontSizeLabel:SetPoint("TOPLEFT", Config.Frame.FontSizeControl, "TOPLEFT", 0, -19)
	Config.Frame.FontSizeLabel:SetText("Font Size")

	Config.Frame.FontSizeSlider = CreateFrame(
		"Frame",
		addonName .. "_Config.Frame.FontSizeSlider",
		Config.Frame.FontSizeControl,
		"MinimalSliderWithSteppersTemplate"
	)
	Config.Frame.FontSizeSlider:SetPoint("CENTER", Config.Frame.FontSizeLabel, "CENTER", 10, 0)
	Config.Frame.FontSizeSlider:SetPoint("LEFT", Config.Frame.FontSizeLabel, "RIGHT", 10, 0)
	Config.Frame.FontSizeSlider:SetPoint("RIGHT", Config.Frame.FontSizeControl, "RIGHT", 0, 0)
	local minFontSize = 10
	local maxFontSize = 20
	local fontSizeStepSize = 1
	local numberOfSteps = (maxFontSize - minFontSize) / fontSizeStepSize
	Config.Frame.FontSizeSlider.formatters = {
		[MinimalSliderWithSteppersMixin.Label.Min] = CreateMinimalSliderFormatter(
			MinimalSliderWithSteppersMixin.Label.Min,
			minFontSize
		),
		[MinimalSliderWithSteppersMixin.Label.Max] = CreateMinimalSliderFormatter(
			MinimalSliderWithSteppersMixin.Label.Max,
			maxFontSize
		),
		[MinimalSliderWithSteppersMixin.Label.Top] = CreateMinimalSliderFormatter(
			MinimalSliderWithSteppersMixin.Label.Top
		),
	}
	Config.Frame.FontSizeSlider:Init(
		12,
		minFontSize,
		maxFontSize,
		numberOfSteps,
		Config.Frame.FontSizeSlider.formatters
	)
end
]]

local function CreateShowAtLoginButtonCheckbox()
	local function onClick(_, checked)
		--TODO - store in db
	end

	Config.Frame.ShowAtLoginCheckButton = addon.Utilities:CreateInterfaceOptionsCheckButton(
		"Show at Login",
		"Determines if the main window is shown at login.",
		addonName .. "_Config.Frame.ShowAtLoginCheckButton",
		Config.Frame,
		onClick
	)
	Config.Frame.ShowAtLoginCheckButton:SetPoint("TOPLEFT", Config.Frame.ResetPositionButton, "BOTTOMLEFT", 0, -16)
	-- Config.Frame.ShowAtLoginCheckButton:SetChecked(not addon.Database:GetMinimapButtonHidden()) -- TODO - pull from db
end

local function CreateShowMinimapButtonCheckbox()
	local function onClick(_, checked)
		if checked then
			addon.MinimapButton:Show()
		else
			addon.MinimapButton:Hide()
		end
	end

	Config.Frame.ShowMinimapCheckButton = addon.Utilities:CreateInterfaceOptionsCheckButton(
		"Show Minimap Button",
		"Specifies whether or not the minimap button should be visible.",
		addonName .. "_Config.Frame.ShowMinimapButtonCheckButton",
		Config.Frame,
		onClick
	)
	Config.Frame.ShowMinimapCheckButton:SetPoint("TOPLEFT", Config.Frame.ShowAtLoginCheckButton, "BOTTOMLEFT", 0, -16)
	Config.Frame.ShowMinimapCheckButton:SetChecked(not addon.Database:GetMinimapButtonHidden())
end

local function CreateFontSizeDropDownMenu()
	Config.Frame.FontSizeLabel =
		Config.Frame:CreateFontString(addonName .. "_Config.Frame.FontSizeLabel", "OVERLAY", "GameFontNormalSmall")
	Config.Frame.FontSizeLabel:SetPoint("TOPLEFT", Config.Frame.ShowMinimapCheckButton, "BOTTOMLEFT", 4, -16)
	Config.Frame.FontSizeLabel:SetText("Size")

	Config.Frame.FontSizeDropDownMenu =
		CreateFrame("Frame", addonName .. "_Config.Frame.FontSizeDropDownMenu", Config.Frame, "UIDropDownMenuTemplate")
	Config.Frame.FontSizeDropDownMenu:SetPoint("TOPLEFT", Config.Frame.FontSizeLabel, "BOTTOMLEFT", -20, -4)

	local options = {
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

	local function OnDropdownMenuOptionClick(self)
		UIDropDownMenu_SetSelectedID(Config.Frame.FontSizeDropDownMenu, self:GetID())
		print("Font Size: " .. options[Config.Frame.FontSizeDropDownMenu.selectedID].value) --TODO - save to db
	end

	local function Initialize()
		local info = UIDropDownMenu_CreateInfo()

		for _, option in ipairs(options) do
			info.text = option.text
			info.func = OnDropdownMenuOptionClick
			info.checked = nil --TODO - if db value = this value then true
			UIDropDownMenu_AddButton(info)
		end
	end

	UIDropDownMenu_Initialize(Config.Frame.FontSizeDropDownMenu, Initialize)
	UIDropDownMenu_SetSelectedID(Config.Frame.FontSizeDropDownMenu, 1) --TODO - pull value from db
	UIDropDownMenu_JustifyText(Config.Frame.FontSizeDropDownMenu, "CENTER")
end

function Config:Initialize()
	CreateRootFrame()
	CreateResetPositionButton()
	CreateResetSizeButton()
	CreateShowAtLoginButtonCheckbox()
	CreateShowMinimapButtonCheckbox()
	-- CreateFontSizeControl()
	CreateFontSizeDropDownMenu()
end

function Config:Open()
	InterfaceOptionsFrame_OpenToCategory(addonName)
end

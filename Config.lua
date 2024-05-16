local addonName, addon = ...
addon.Config = {}
local Config = addon.Config

local function CreateRootFrame()
	Config.Frame = CreateFrame("Frame", addonName .. "_Config", UIParent, "BasicFrameTemplate")
	Config.Frame:SetSize(338, 424)
	Config.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	-- Config.Frame:SetClipsChildren(true)
	Config.Frame:EnableMouse(true)

	Config.Frame.TitleText:SetText(addonName .. " (Configuration)")
	Config.Frame.TitleText:SetPoint("TOPLEFT", Config.Frame.TopBorder, "TOPLEFT", 0, 0)
	Config.Frame.TitleText:SetPoint("BOTTOMRIGHT", Config.Frame.TopBorder, "BOTTOMRIGHT", 0, 3)
	Config.Frame.TitleText:SetTextColor(1, 1, 1)
end

local function MakeFrameMoveable()
	Config.Frame:SetMovable(true)

	Config.Frame.TitleBg:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			Config.Frame:StartMoving()
		end
	end)

	Config.Frame.TitleBg:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			Config.Frame:StopMovingOrSizing()
		end
	end)

	Config.Frame.TitleBg:SetScript("OnEnter", function()
		SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	end)

	Config.Frame.TitleBg:SetScript("OnLeave", ResetCursor)
end

local function CreateResetPositionButton()
	Config.Frame.ResetPositionButton =
		CreateFrame("Button", addonName .. "_Config.Frame.ResetPositionButton", Config.Frame, "UIPanelButtonTemplate")
	Config.Frame.ResetPositionButton:SetPoint("TOP", Config.Frame.Bg, "TOP", 0, -20)
	Config.Frame.ResetPositionButton:SetText("Reset Position")
	Config.Frame.ResetPositionButton:FitToText()
end

local function CreateResetSizeButton()
	Config.Frame.ResetSizeButton =
		CreateFrame("Button", addonName .. "_Config.Frame.ResetSizeButton", Config.Frame, "UIPanelButtonTemplate")
	Config.Frame.ResetSizeButton:SetPoint("TOP", Config.Frame.ResetPositionButton, "BOTTOM", 0, -10)
	Config.Frame.ResetSizeButton:SetText("Reset Size")
	Config.Frame.ResetSizeButton:FitToText()
end

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

local function MakeFrameMoveable()
	Config.Frame:SetMovable(true)

	Config.Frame.TitleBg:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			Config.Frame:StartMoving()
		end
	end)

	Config.Frame.TitleBg:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			Config.Frame:StopMovingOrSizing()
		end
	end)

	Config.Frame.TitleBg:SetScript("OnEnter", function()
		SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	end)

	Config.Frame.TitleBg:SetScript("OnLeave", ResetCursor)
end

function Config:Initialize()
	CreateRootFrame()
	MakeFrameMoveable()
	CreateResetPositionButton()
	CreateResetSizeButton()
	CreateFontSizeControl()
end

function Config:Toggle()
	if Config.Frame == nil then
		self:Initialize()
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	else
		Config.Frame:Hide()
		Config.Frame = nil
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
	end
end

function Config:ResetSizeAndPosition()
	Config.Frame:SetSize(338, 424)
	Config.Frame:ClearAllPoints()
	Config.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

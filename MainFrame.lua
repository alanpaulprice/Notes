local addonName, addon = ...
addon.MainFrame = {}
local MainFrame = addon.MainFrame

local function CreateRootFrame()
	MainFrame = CreateFrame("Frame", addonName .. "_MainFrame", UIParent, "BasicFrameTemplate")
	MainFrame:SetSize(338, 424)
	MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	MainFrame:SetClipsChildren(true)

	MainFrame.TitleText:SetText(addonName)
	MainFrame.TitleText:ClearAllPoints()
	MainFrame.TitleText:SetPoint("TOPLEFT", MainFrame.TopBorder, "TOPLEFT", 0, 0)
	MainFrame.TitleText:SetPoint("BOTTOMRIGHT", MainFrame.TopBorder, "BOTTOMRIGHT", 0, 3)
	MainFrame.TitleText:SetTextColor(1, 1, 1)
end

local function MakeFrameMoveable()
	MainFrame:SetMovable(true)

	MainFrame.TitleBg:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			MainFrame:StartMoving()
		end
	end)

	MainFrame.TitleBg:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end)

	MainFrame.TitleBg:SetScript("OnEnter", function()
		SetCursor("Interface\\CURSOR\\OPENHAND.blp")
	end)

	MainFrame.TitleBg:SetScript("OnLeave", ResetCursor)
end

local function MakeFrameResizable()
	MainFrame:SetResizable(true)
	MainFrame:SetResizeBounds(100, 100)

	local function onBorderOrCornerMouseDown(button, framePoint)
		if button == "LeftButton" then
			MainFrame:StartSizing(framePoint)
		end
	end

	local function onBorderOrCornerMouseUp(_, button)
		if button == "LeftButton" then
			MainFrame:StopMovingOrSizing()
		end
	end

	local function SetSizeCursor()
		SetCursor("Interface\\CURSOR\\UI-Cursor-Size.blp")
	end

	MainFrame.RightBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "RIGHT")
	end)
	MainFrame.RightBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	MainFrame.RightBorder:SetScript("OnEnter", SetSizeCursor)
	MainFrame.RightBorder:SetScript("OnLeave", ResetCursor)

	MainFrame.BotRightCorner:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOMRIGHT")
	end)
	MainFrame.BotRightCorner:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	MainFrame.BotRightCorner:SetScript("OnEnter", SetSizeCursor)
	MainFrame.BotRightCorner:SetScript("OnLeave", ResetCursor)

	MainFrame.BottomBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOM")
	end)
	MainFrame.BottomBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	MainFrame.BottomBorder:SetScript("OnEnter", SetSizeCursor)
	MainFrame.BottomBorder:SetScript("OnLeave", ResetCursor)

	MainFrame.BotLeftCorner:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "BOTTOMLEFT")
	end)
	MainFrame.BotLeftCorner:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	MainFrame.BotLeftCorner:SetScript("OnEnter", SetSizeCursor)
	MainFrame.BotLeftCorner:SetScript("OnLeave", ResetCursor)

	MainFrame.LeftBorder:SetScript("OnMouseDown", function(_, button)
		onBorderOrCornerMouseDown(button, "LEFT")
	end)
	MainFrame.LeftBorder:SetScript("OnMouseUp", onBorderOrCornerMouseUp)
	MainFrame.LeftBorder:SetScript("OnEnter", SetSizeCursor)
	MainFrame.LeftBorder:SetScript("OnLeave", ResetCursor)
end

local function CreateScrollingEditBox()
	MainFrame.ScrollingEditBox =
		CreateFrame("Frame", addonName .. "_ScrollingEditBox", MainFrame, "ScrollingEditBoxTemplate")
	MainFrame.ScrollingEditBox:SetPoint("TOPLEFT", MainFrame.Bg, "TOPLEFT", 4, -2)
	MainFrame.ScrollingEditBox:SetPoint("BOTTOMRIGHT", MainFrame.Bg, "BOTTOMRIGHT", -26, 2)
	MainFrame.ScrollingEditBox.ScrollBox.EditBox:SetText(addon.Database:GetNote())
end

local function CreateScrollBar()
	MainFrame.ScrollingEditBox.ScrollBar =
		CreateFrame("EventFrame", addonName .. "_ScrollingEditBox_ScrollBar", MainFrame, "WowTrimScrollBar")
	MainFrame.ScrollingEditBox.ScrollBar:SetPoint("TOPLEFT", MainFrame.Bg, "TOPRIGHT", -24, 0)
	MainFrame.ScrollingEditBox.ScrollBar:SetPoint("BOTTOMRIGHT", MainFrame.Bg, "BOTTOMRIGHT", 0, 0)
	ScrollUtil.RegisterScrollBoxWithScrollBar(
		MainFrame.ScrollingEditBox.ScrollBox,
		MainFrame.ScrollingEditBox.ScrollBar
	)
end

local function ConfigureOnTextChangeHandling()
	function MainFrame:OnScrollingEditBoxTextChange(editBox)
		addon.Database:SetNote(editBox:GetInputText())
	end

	MainFrame.ScrollingEditBox:RegisterCallback("OnTextChanged", MainFrame.OnScrollingEditBoxTextChange, self)
end

function MainFrame:Initialize()
	CreateRootFrame()
	MakeFrameMoveable()
	MakeFrameResizable()
	CreateScrollingEditBox()
	CreateScrollBar()
	ConfigureOnTextChangeHandling()
end

function MainFrame:Toggle()
	if type(_G[addonName .. "_MainFrame"]) ~= "table" then
		MainFrame:Initialize()
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	else
		local previousShown = MainFrame:IsShown()

		MainFrame:SetShown(not previousShown)

		if previousShown then
			PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
		else
			PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
		end
	end
end

function MainFrame:ResetSizeAndPosition()
	MainFrame:SetSize(338, 424)
	MainFrame:ClearAllPoints()
	MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

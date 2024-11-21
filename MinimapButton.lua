local addonName, addon = ...
addon.MinimapButton = {}
local MinimapButton = addon.MinimapButton

local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local icon = nil

function MinimapButton:SetHidden(hidden)
	addon.Database:SetMinimapButtonHidden(hidden)

	if icon then
		if hidden then
			icon:Hide(addonName)
		else
			icon:Show(addonName)
		end
	end
end

function MinimapButton:Initialize()
	MinimapButton.Button = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
		type = "data source",
		text = addonName,
		icon = "Interface\\AddOns\\" .. addonName .. "\\INV_Misc_PaperBundle02a.blp",
		OnClick = function(_, button)
			if button == "LeftButton" then
				addon.MainUi:Toggle()
			elseif button == "RightButton" then
				AceConfigDialog:Open(addonName)
			end
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end

			tooltip:AddLine(addonName)
			tooltip:AddLine("|CFFFFFFFFLeft-click|r or |CFFFFFFFF/notes|r to toggle the main window.")
			tooltip:AddLine("|CFFFFFFFFRight-click|r or |CFFFFFFFF/notes config|r to configure.")
		end,
	})

	icon = LibStub("LibDBIcon-1.0", true)
	icon:Register(addonName, MinimapButton.Button, addon.Database:GetUnclonedMinimapButton())
end

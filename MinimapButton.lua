local addonName, addon = ...
addon.MinimapButton = {}
local MinimapButton = addon.MinimapButton

function MinimapButton:Show()
	addon.Database:SetMinimapButtonHidden(false)
	MinimapButton.Icon:Show(addonName)
end

function MinimapButton:Hide()
	addon.Database:SetMinimapButtonHidden(true)
	MinimapButton.Icon:Hide(addonName)
end

function MinimapButton:Initialize()
	MinimapButton.Button = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
		type = "data source",
		text = addonName,
		icon = "Interface\\ICONS\\INV_Misc_PaperBundle02a.blp", -- "Interface\\ICONS\\INV_Misc_Note_04.blp"
		OnClick = function(_, button)
			if button == "LeftButton" then
				addon.UI:Toggle()
			elseif button == "RightButton" then
				addon.Options:Open()
			end
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end

			tooltip:AddLine(addonName)
			tooltip:AddLine("|CFFFFFFFFLeft-click|r or |CFFFFFFFF/notes|r to toggle the main window.")
			tooltip:AddLine("|CFFFFFFFFRight-click|r or |CFFFFFFFF/notes options|r to view the options.")
		end,
	})

	MinimapButton.Icon = LibStub("LibDBIcon-1.0", true)
	MinimapButton.Icon:Register(addonName, MinimapButton.Button, addon.Database:GetMinimapButtonForLibDBIcon())
end

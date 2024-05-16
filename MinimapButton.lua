local addonName, addon = ...
addon.MinimapButton = {}
local MinimapButton = addon.MinimapButton

function MinimapButton:Show()
	NotesLDBIconDB.hide = false
	MinimapButton.Icon:Show(addonName)
end

function MinimapButton:Hide()
	NotesLDBIconDB.hide = true
	MinimapButton.Icon:Hide(addonName)
end

function MinimapButton:GetShown()
	return not NotesLDBIconDB.hide
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
				addon.Config:Open()
			end
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end

			tooltip:AddLine(addonName)
		end,
	})

	if not NotesLDBIconDB then
		NotesLDBIconDB = { hide = false }
	end

	MinimapButton.Icon = LibStub("LibDBIcon-1.0", true)
	MinimapButton.Icon:Register(addonName, MinimapButton.Button, NotesLDBIconDB)
end

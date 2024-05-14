local addonName, addon = ...
addon.MinimapButton = {}
local MinimapButton = addon.MinimapButton

function MinimapButton:Initialize()
	local minimapButton = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
		type = "data source",
		text = addonName,
		icon = "Interface\\ICONS\\INV_Misc_PaperBundle02a.blp", -- "Interface\\ICONS\\INV_Misc_Note_04.blp"
		OnClick = function(_, button)
			if button == "LeftButton" then
				addon.UI:Toggle()
			elseif button == "RightButton" then
				addon.Config:Toggle()
			end
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end

			tooltip:AddLine(addonName)
		end,
	})

	local icon = LibStub("LibDBIcon-1.0", true)
	icon:Register(addonName, minimapButton, NotesDB)
end

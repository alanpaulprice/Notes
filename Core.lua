local addonName, addon = ...

addon.MinimapButton = {}

function addon.MinimapButton:Initialize()
	local minimapButton = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
		type = "data source",
		text = addonName,
		icon = "Interface\\ICONS\\INV_Misc_PaperBundle02a.blp", -- "Interface\\ICONS\\INV_Misc_Note_04.blp"
		OnClick = function(_, button)
			if button == "LeftButton" then
				addon.MainFrame:Toggle()
			elseif button == "RightButton" then
				--TODO: OPEN CONFIG
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

function addon:ConfigureSlashCommands()
	SLASH_NOTES1 = "/" .. string.lower(addonName)
	SlashCmdList.NOTES = function(message)
		if message == "" then
			addon.MainFrame:Toggle()
		elseif message == "reset" then
			addon.MainFrame:ResetSizeAndPosition()
		else
			print(addonName .. ": Unknown argument '" .. message .. "' received.")
		end
	end
end

function addon:Initialize()
	addon.Database:Initialize()
	addon.MinimapButton:Initialize()
	addon:ConfigureSlashCommands()
end

function addon:OnAddonLoaded(_, name)
	if name == addonName then
		addon:Initialize()
	end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", addon.OnAddonLoaded)

function addon:PrintKeys(tbl)
	for key, _ in pairs(tbl) do
		print(key)
	end
end

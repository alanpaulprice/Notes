local addonName, addon = ...

function addon:ConfigureSlashCommands()
	SLASH_NOTES1 = "/" .. string.lower(addonName)
	SlashCmdList.NOTES = function(message)
		if message == "" then
			addon.UI:Toggle()
		elseif message == "config" then
			addon.Config:Open()
		elseif message == "resetsize" then
			addon.UI:ResetSize()
		elseif message == "resetposition" then
			addon.UI:ResetPosition()
		else
			print(addonName .. ": Unknown argument '" .. message .. "' received.")
		end
	end
end

function addon:Initialize()
	addon.Database:Initialize()
	addon.MinimapButton:Initialize()
	addon.Config:Initialize()
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

local addonName, addon = ...
LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceConsole-3.0")
addon.DEBUG = false

local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function addon:OnInitialize()
	addon.Database:Initialize()
	addon.MinimapButton:Initialize()
	self.MainUi:Initialize()

	self:RegisterChatCommand(string.lower(addonName), "OnChatCommand")
end

function addon:OnEnable() end

function addon:OnDisable() end

function addon:OnChatCommand(input)
	if not input or input:trim() == "" then
		addon.MainUi:Toggle()
	elseif input:trim() == "config" then
		AceConfigDialog:Open(addonName)
	else
		addon:Print("Unrecognized command argument.")
	end
end

local addonName, addon = ...
local Config = addon:NewModule("Config", "AceEvent-3.0")
addon.Config = Config

local function AddVerticalSpacing(order)
	local verticalSpacing = {
		type = "description",
		name = " ",
		fontSize = "large",
		width = "full",
		order = order,
	}
	return verticalSpacing
end

local function AddHorizontalSpacing(order)
	local horizontalSpacing = {
		type = "description",
		name = " ",
		width = "half",
		order = order,
	}
	return horizontalSpacing
end

local pointOptions = {
	BOTTOM = "Bottom",
	BOTTOMLEFT = "Bottom Left",
	BOTTOMRIGHT = "Bottom Right",
	CENTER = "Center",
	LEFT = "Left",
	RIGHT = "Right",
	TOP = "Top",
	TOPLEFT = "Top Left",
	TOPRIGHT = "Top Right",
}

local pointOptionSortOrder = {
	"BOTTOM",
	"BOTTOMLEFT",
	"BOTTOMRIGHT",
	"CENTER",
	"LEFT",
	"RIGHT",
	"TOP",
	"TOPLEFT",
	"TOPRIGHT",
}

local options = {
	name = addonName,
	handler = addon,
	type = "group",
	args = {
		checkboxGroup = {
			order = 1,
			type = "group",
			inline = true,
			name = "General",
			args = {
				showAtLogin = {
					order = 1,
					type = "toggle",
					name = "Show at login",
					desc = "When checked, " .. addonName .. " will be shown when you log in.",
					get = function()
						return addon.Database:GetShowAtLogin()
					end,
					set = function(_, value)
						addon.Database:SetShowAtLogin(value)
					end,
				},
				showMinimapButton = {
					order = 2,
					type = "toggle",
					name = "Hide minimap button",
					desc = "When checked, the " .. addonName .. " minimap button will be hidden.",
					get = function()
						return addon.Database:GetMinimapButtonHidden()
					end,
					set = function(_, value)
						addon.MinimapButton:SetHidden(value)
					end,
				},
				resizeEnabled = {
					order = 3,
					type = "toggle",
					name = "Resize enabled",
					desc = "When checked, it will be possible to resize the main window.",
					get = function()
						return addon.Database:GetResizeEnabled()
					end,
					set = function(_, value)
						addon.MainUi:UpdateResizeEnabled(value)
					end,
				},
			},
		},
		fontGroup = {
			order = 2,
			type = "group",
			inline = true,
			name = "Edit view font",
			args = {
				fontSize = {
					order = 1,
					type = "range",
					name = "Size",
					min = 4,
					max = 32,
					bigStep = 1,
					get = function()
						return addon.Database:GetEditViewFontSize()
					end,
					set = function(_, value)
						addon.EditView:UpdateFontSize(value)
					end,
				},
				spacer1 = AddHorizontalSpacing(2),
				font = {
					order = 3,
					type = "select",
					name = "Font",
					desc = "Determines the font used for the edit view.",
					dialogControl = "LSM30_Font",
					values = AceGUIWidgetLSMlists.font,
					get = function()
						return addon.Database:GetEditViewFont()
					end,
					set = function(_, value)
						addon.EditView:UpdateFont(value)
					end,
				},
			},
		},
		sizeGroup = {
			order = 3,
			type = "group",
			inline = true,
			name = "Main window size",
			args = {
				row1 = {
					order = 1,
					type = "group",
					inline = true,
					name = "",
					args = {
						height = {
							order = 1,
							type = "range",
							name = "Height",
							min = 200,
							max = 1000,
							step = 1,
						},
						spacer1 = AddHorizontalSpacing(2),
						YOffset = {
							order = 3,
							type = "range",
							name = "Width",
							min = 400,
							max = 1000,
							step = 1,
						},
					},
				},
				row2 = {
					order = 2,
					type = "group",
					inline = true,
					name = "",
					args = {
						spacer1 = AddVerticalSpacing(1),
						resetSize = {
							order = 2,
							type = "execute",
							name = "Reset size",
							func = function() end,
						},
					},
				},
			},
		},
		pointGroup = {
			order = 4,
			type = "group",
			inline = true,
			name = "Main window position",
			args = {
				row1 = {
					order = 1,
					type = "group",
					inline = true,
					name = "",
					args = {
						XOffset = {
							order = 1,
							type = "range",
							name = "Offset (X)",
							min = -1000,
							max = 1000,
							step = 1,
						},
						spacer2 = AddHorizontalSpacing(2),
						YOffset = {
							order = 3,
							type = "range",
							name = "Offset (Y)",
							min = -1000,
							max = 1000,
							step = 1,
						},
					},
				},
				row2 = {
					order = 2,
					type = "group",
					inline = true,
					name = "",
					args = {
						spacer1 = AddVerticalSpacing(1),
						relativePoint = {
							order = 2,
							type = "select",
							name = "Relative point",
							desc = "Determines which side of the screen the " .. addonName .. " frame is anchored to.",
							values = pointOptions,
							sorting = pointOptionSortOrder,
						},
						spacer2 = AddHorizontalSpacing(3),
						resetPosition = {
							order = 4,
							type = "execute",
							name = "Reset position",
							func = function() end,
						},
					},
				},
			},
		},
	},
}

function Config:OnEnable()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
	self.Frame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)
end

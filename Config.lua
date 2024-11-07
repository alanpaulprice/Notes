local addonName, addon = ...
local Config = addon:NewModule("Config")
addon.Config = Config

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

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

local options = {
	name = addonName,
	handler = addon,
	type = "group",
	args = {
		generalGroup = {
			order = 1,
			type = "group",
			inline = true,
			name = "General",
			args = {
				showAtLogin = {
					order = 1,
					type = "toggle",
					name = "Show at login",
					get = function()
						return addon.Database:GetShowAtLogin()
					end,
					set = function(_, value)
						addon.Database:SetShowAtLogin(value)
					end,
				},
				spacer1 = AddHorizontalSpacing(2),
				showMinimapButton = {
					order = 3,
					type = "toggle",
					name = "Hide minimap button",
					get = function()
						return addon.Database:GetMinimapButtonHidden()
					end,
					set = function(_, value)
						addon.MinimapButton:SetHidden(value)
					end,
				},
			},
		},
		spacer1 = AddVerticalSpacing(2),
		mainWindowGroup = {
			order = 3,
			type = "group",
			inline = true,
			name = "Main window",
			args = {
				row1 = {
					order = 1,
					type = "group",
					inline = true,
					name = "",
					args = {
						width = {
							order = 1,
							type = "range",
							name = "Width",
							min = addon.Constants.MIN_UI_WIDTH,
							max = nil, -- Set later via the `InitializeOptions` function
							step = 0.01,
							bigStep = 1,
							get = function()
								return addon.Utilities:RoundNumber(addon.Database:GetWidth(), 2)
							end,
							set = function(_, value)
								addon.MainUi:UpdateWidth(value)
							end,
						},
						spacer1 = AddHorizontalSpacing(2),
						height = {
							order = 3,
							type = "range",
							name = "Height",
							min = addon.Constants.MIN_UI_HEIGHT,
							max = nil, -- Set later via the `InitializeOptions` function
							step = 0.01,
							bigStep = 1,
							get = function()
								return addon.Utilities:RoundNumber(addon.Database:GetHeight(), 2)
							end,
							set = function(_, value)
								addon.MainUi:UpdateHeight(value)
							end,
						},
					},
				},
				spacer1 = AddVerticalSpacing(2),
				row2 = {
					order = 3,
					type = "group",
					inline = true,
					name = "",
					args = {
						resizeEnabled = {
							order = 1,
							type = "toggle",
							name = "Resize via drag enabled",
							get = function()
								return addon.Database:GetResizeEnabled()
							end,
							set = function(_, value)
								addon.MainUi:UpdateResizeEnabled(value)
							end,
						},
						spacer1 = AddHorizontalSpacing(2),
						clampToScreen = {
							order = 3,
							type = "toggle",
							name = "Clamp to screen",
							desc = "When checked, it will not be possible to position the main window off screen, even partially.",
							get = function()
								return addon.Database:GetClampedToScreen()
							end,
							set = function(_, value)
								addon.MainUi:UpdateClampedToScreen(value)
							end,
						},
					},
				},
			},
		},
		spacer3 = AddVerticalSpacing(4),
		editViewGroup = {
			order = 5,
			type = "group",
			inline = true,
			name = "Edit view",
			args = {
				fontSize = {
					order = 1,
					type = "range",
					name = "Font size",
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
		spacer2 = AddVerticalSpacing(6),
		listViewGroup = {
			order = 7,
			type = "group",
			inline = true,
			name = "List view",
			args = {
				row1 = {
					order = 1,
					type = "group",
					inline = true,
					name = "",
					args = {
						fontSize = {
							order = 1,
							type = "range",
							name = "Font size",
							min = 4,
							max = 32,
							bigStep = 1,
							get = function()
								return addon.Database:GetListViewFontSize()
							end,
							set = function(_, value)
								addon.ListView:UpdateFontSize(value)
							end,
						},
						spacer1 = AddHorizontalSpacing(2),
						font = {
							order = 3,
							type = "select",
							name = "Font",
							dialogControl = "LSM30_Font",
							values = AceGUIWidgetLSMlists.font,
							get = function()
								return addon.Database:GetListViewFont()
							end,
							set = function(_, value)
								addon.ListView:UpdateFont(value)
							end,
						},
					},
				},
				spacer3 = AddVerticalSpacing(2),
				row2 = {
					order = 3,
					type = "group",
					inline = true,
					name = "",
					args = {
						spacing = {
							order = 4,
							type = "range",
							name = "Spacing",
							min = 0,
							max = 32,
							bigStep = 1,
							get = function()
								return addon.Database:GetListViewSpacing()
							end,
							set = function(_, value)
								addon.ListView:UpdateSpacing(value)
							end,
						},
					},
				},
			},
		},
	},
}

-- Because the values returned by GetScreenWidth/Height are incorrect when `options` is declared.
local function InitializeOptions()
	local roundedScreenWidth = addon.Utilities:RoundNumber(GetScreenWidth(), 0)
	local roundedScreenHeight = addon.Utilities:RoundNumber(GetScreenHeight(), 0)

	options.args.mainWindowGroup.args.row1.args.width.max = roundedScreenWidth
	options.args.mainWindowGroup.args.row1.args.height.max = roundedScreenHeight
end

function Config:OnEnable()
	InitializeOptions()
	AceConfigRegistry:RegisterOptionsTable(addonName, options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
	self.Frame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)
end

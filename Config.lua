local addonName, addon = ...
local Config = addon:NewModule("Config", "AceEvent-3.0")
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
				clampedToScreen = {
					order = 3,
					type = "toggle",
					name = "Clamped to screen",
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
		spacer1 = AddVerticalSpacing(2),
		editViewfontGroup = {
			order = 3,
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
		spacer2 = AddVerticalSpacing(4),
		listViewFontGroup = {
			order = 5,
			type = "group",
			inline = true,
			name = "List view font",
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
							name = "Size",
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
							desc = "Determines the font used for the list view.",
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
		spacer3 = AddVerticalSpacing(6),
		sizeGroup = {
			order = 7,
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
						width = {
							order = 1,
							type = "range",
							name = "Width",
							desc = "Determines the width of the main window.",
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
							desc = "Determines the height of the main window.",
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
							name = "Resize enabled",
							desc = "When checked, it will be possible to resize the main window by dragging it's bottom border, right border, or bottom right corner.",
							get = function()
								return addon.Database:GetResizeEnabled()
							end,
							set = function(_, value)
								addon.MainUi:UpdateResizeEnabled(value)
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

	options.args.sizeGroup.args.row1.args.width.max = roundedScreenWidth
	options.args.sizeGroup.args.row1.args.height.max = roundedScreenHeight
end

function Config:OnEnable()
	InitializeOptions()
	AceConfigRegistry:RegisterOptionsTable(addonName, options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
	self.Frame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)
end

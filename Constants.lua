local addonName, addon = ...
addon.Constants = {}
local Constants = addon.Constants

Constants.MIN_UI_WIDTH = 400
Constants.MIN_UI_HEIGHT = 200

Constants.NOTE_TITLE_MAX_LENGTH = 32

Constants.UI_VIEW_ENUM = {
	EDIT = 1,
	LIST = 2,
	MANAGE = 3,
}

Constants.DEFAULT_DATABASE_DEFAULTS = {
	profile = {
		mainUiStatus = {
			height = 400,
			top = nil,
			left = nil,
			width = 400,
		},
		minimapButton = {
			hide = false,
		},
		showAtLogin = false,
		resizeEnabled = true,
		clampedToScreen = true,
		editViewFontSize = 14,
		editViewFont = "Arial Narrow",
		listViewFontSize = 14,
		listViewFont = "Friz Quadrata TT",
		listViewSpacing = 12,
	},
	char = {
		currentNoteId = 1,
		currentView = Constants.UI_VIEW_ENUM.EDIT,
	},
	global = {
		notes = {
			{
				id = 1,
				title = "Getting Started",
				body = "Tab Overview:"
					.. "\n"
					.. "- Edit: Edit the currently selected note."
					.. "\n"
					.. "- List: Change the currently selected note."
					.. "\n"
					.. "- Manage: Create, rename, and delete a note."
					.. "\n\n"
					.. "The title of the currently selected note is displayed in the status bar at the bottom of the window."
					.. "\n\n"
					.. "Move the window by clicking and dragging the title at the top."
					.. "\n\n"
					.. "Resize the window by clicking and dragging the right border, bottom border, or bottom right corner.",
			},
		},
	},
}

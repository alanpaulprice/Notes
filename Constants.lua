local addonName, addon = ...
addon.Constants = {}
local Constants = addon.Constants

Constants.DEFAULT_EDIT_VIEW_FONT = "Arial Narrow"

Constants.DEFAULT_MAIN_UI_WIDTH = 400
Constants.DEFAULT_MAIN_UI_HEIGHT = 400

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
			height = addon.Constants.DEFAULT_MAIN_UI_HEIGHT,
			top = nil,
			left = nil,
			width = addon.Constants.DEFAULT_MAIN_UI_WIDTH,
		},
		minimapButton = {
			hide = false,
		},
		showAtLogin = false,
		resizeEnabled = true,
		clampedToScreen = true,
		editViewFontSize = 14,
		editViewFont = addon.Constants.DEFAULT_EDIT_VIEW_FONT,
	},
	char = {
		currentNoteId = 1,
		currentView = addon.Constants.UI_VIEW_ENUM.EDIT,
	},
	global = {
		notes = {
			{
				id = 1,
				title = "Getting Started",
				body = "Edit: View and edit the currently selected note."
					.. "\n\n"
					.. "List: View all notes and change the currently selected note."
					.. "\n\n"
					.. "Manage: Create, rename, and delete a note."
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

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
				body = "You can navigate to the 'Manage' view via the button below, labeled 'Manage Notes'."
					.. " From there, you can:"
					.. "\n\n"
					.. "- View all notes."
					.. "\n"
					.. "- Create a note."
					.. "\n"
					.. "- Edit the title of a note."
					.. "\n"
					.. "- Delete a note."
					.. "\n\n"
					.. "Right-click a note to open a menu that will enable you to edit it's title or delete it."
					.. "\n\n"
					.. "You can resize this window using the handles in the bottom corners,"
					.. " and move it by clicking and dragging on the title bar at the top.",
			},
		},
	},
}

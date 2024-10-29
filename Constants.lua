local addonName, addon = ...
addon.Constants = {}
local Constants = addon.Constants

Constants.DEFAULT_MAIN_UI_WIDTH = 400
Constants.DEFAULT_MAIN_UI_HEIGHT = 400

-- Constants.MIN_UI_WIDTH = 200
-- Constants.MIN_UI_HEIGHT = 200
-- Constants.MAX_UI_WIDTH = nil
-- Constants.MAX_UI_HEIGHT = nil

Constants.NOTE_TITLE_MAX_LENGTH = 32

Constants.UI_VIEW_ENUM = {
	EDIT = 1,
	LIST = 2,
	MANAGE = 3,
}

local gears = require('gears')

-- Loads default-theme.lua for default style and overrides it with
-- custom theme, in this case vortex-theme.lua

local final_theme = {}

-- Default file
local default_theme = require('theme.default-theme')

-- Custom File
local theme = require('theme.vortex-theme')

-- Joins themes/Overrides them
gears.table.crush(final_theme, default_theme.theme)
gears.table.crush(final_theme, theme.theme)

default_theme.awesome_overrides(final_theme)
theme.awesome_overrides(final_theme)

return final_theme

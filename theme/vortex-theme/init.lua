-- Custom theming file, you can change your main system style without
-- changing the main default-theme file.
-- Feel free to change Primary, Accent and Background fields with
-- color values described in mat-colors.
-- use "awesome_overrides" to override precise system styles, such
-- as specific border color, width, foregound when focus, background,
-- etc...

local filesystem = require('gears.filesystem')
local mat_colors = require('theme.mat-colors')
local theme_dir = filesystem.get_configuration_dir() .. '/theme'
local theme = {}

theme.icons = theme_dir .. '/icons/'
theme.font = 'Roboto medium 10'

    -- Primary
theme.primary = mat_colors.Cyan

    -- Accent
theme.accent = mat_colors.Red

    -- Background
theme.background = mat_colors.Gray

    -- Add similar overrides to default-theme.lua
local awesome_overrides = function(theme)
-- theme.bg_normal = theme.background.lighten_100
end

return {
    theme = theme,
    awesome_overrides = awesome_overrides
}

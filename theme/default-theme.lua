local gears      = require('gears')
local dpi        = require('beautiful').xresources.apply_dpi
local filesystem = require('gears.filesystem')
local mat_colors = require('theme.mat-colors')
local theme_dir  = filesystem.get_configuration_dir() .. '/theme'
local theme      = {}

theme.icons = theme_dir .. '/icons/'
theme.font  = 'Roboto medium 10'

-- Color Pallets

    -- Primary
theme.primary    = mat_colors.Cyan

    -- Accent
theme.accent     = mat_colors.Red

    -- Background
theme.background = mat_colors.Gray

local awesome_overrides = function(theme)

    theme.dir        = theme_dir
    theme.icons      = theme.dir .. '/icons/'
    theme.wallpaper  = theme.background.lighten_100
    theme.font       = 'Roboto medium 10'
    theme.title_font = 'Roboto medium 14'

    theme.fg_normal          = theme.background.lighten_70
    theme.fg_focus           = theme.background.lighten_100

    theme.bg_normal          = theme.background.shaden_100
    theme.bg_focus           = theme.background.shaden_30
    theme.bg_primary_subtle  = theme.primary.shaden_95
    theme.bg_primary_blatant = theme.primary.lighten_95

        -- Borders
    theme.border_width     = dpi(2)
    theme.border_normal    = theme.primary.shaden_70
    theme.border_focus     = theme.primary.true_color
    theme.border_secondary = theme.primary.shaden_85
    theme.border_semi      = theme.primary.shaden_40
    theme.check_color      = theme.primary.shaden_20

        -- Menu
    theme.menu_height = 16
    theme.menu_width  = 160

        -- Tooltips
    theme.tooltip_bg           = theme.background.shaden_70
    theme.tooltip_border_color = theme.primary.lighten_70
    theme.tooltip_border_width = dpi(1)
    theme.tooltip_shape        = gears.shape.rectangle

        -- Layout
    theme.layout_max      = theme.icons .. 'layouts/arrow-expand-all.png'
    theme.layout_tile     = theme.icons .. 'layouts/view-quilt.png'
    theme.layout_floating = theme.icons .. 'layouts/floating.png'
    theme.layout_fairh    = theme.icons .. 'layouts/fair-h.png'
    theme.layout_fairv    = theme.icons .. 'layouts/fair-v.png'

        -- Taglist
    theme.taglist_bg_empty    = theme.background.shaden_100
    theme.taglist_bg_occupied = theme.background.shaden_95
    theme.taglist_bg_urgent   =
        'linear:0,0:' ..
            dpi(40) ..
                ',0:0,' ..
                    theme.accent.true_color ..
                        ':0.08,' ..
                            theme.accent.true_color ..
                                ':0.08,' ..
                                    theme.background.shaden_100 ..
                                        ':1,' ..
                                            theme.background.shaden_100
    theme.taglist_bg_focus    =
        'linear:0,0:' ..
            dpi(40) ..
                ',0:0,' ..
                    theme.primary.true_color ..
                        ':0.08,' ..
                            theme.primary.true_color ..
                                ':0.08,' ..
                                    theme.background.shaden_100 ..
                                        ':1,' ..
                                            theme.background.shaden_100

            -- Tasklist
    theme.tasklist_font      = 'Roboto medium 11'
    theme.tasklist_bg_normal = theme.background.shaden_100
    theme.tasklist_bg_focus  = theme.background.shaden_90
    theme.tasklist_bg_urgent = theme.primary.shaden_30
    theme.tasklist_fg_focus  = theme.background.lighten_100
    theme.tasklist_fg_urgent = theme.fg_normal
    theme.tasklist_fg_normal = theme.background.lighten_70
end
return {
    theme = theme,
    awesome_overrides = awesome_overrides
}

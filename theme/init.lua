local gears = require('gears')

local filesystem = require('gears.filesystem')
local colors     = require('theme.colors')
local icon_dir   = require('gears.filesystem').get_configuration_dir() .. '/theme/icons'

local theme = {}
local pallet = {}

theme.system_font = 'Roboto '
theme.font = theme.system_font .. '12'

-- Color Pallets
    -- Primary System Color
pallet.primary    = colors.Cyan

    -- Accent
pallet.accent     = colors.Red

    -- Background
pallet.background = colors.Gray

-- Widgets
theme.bg_color = pallet.background.shaden_100
theme.fg_color = pallet.background.lighten_100
theme.bg_focus = theme.bg_color
theme.fg_focus = theme.fg_color
theme.bg_primary = pallet.primary.true_color
theme.bg_primary_darkened = pallet.primary.shaden_50
theme.bg_primary_lightened = pallet.primary.lighten_50
theme.bg_primary_subtle = pallet.primary.shaden_95
theme.bg_primary_blatant = pallet.primary.lighten_95
theme.bg_neutral = pallet.background.true_color

-- Top Panel
theme.top_panel_height = 30

-- Borders
theme.border_width     = 2
theme.border_width_reduced = math.max(theme.border_width - 1, 1)
theme.border_normal    = pallet.primary.shaden_60
theme.border_focus     = pallet.primary.true_color
theme.border_secondary = pallet.primary.shaden_85

-- Tags
theme.useless_gap         = 4
theme.gap_single_client   = false
theme.master_fill_policy  = "expand"
theme.master_witdh_factor = 0.5
theme.master_count        = 1
theme.column_count        = 1

-- Hotkeys
theme.hotkeys_bg               = theme.bg_color
theme.hotkeys_fg               = theme.fg_color
theme.hotkeys_border_width     = theme.border_width
theme.hotkeys_border_color     = theme.border_focus
theme.hotkeys_modifiers_fg     = theme.border_focus
theme.hotkeys_label_bg         = theme.hotkeys_fg
theme.hotkeys_label_fg         = theme.hotkeys_bg
theme.hotkeys_font             = theme.system_font .. '12'
theme.hotkeys_description_font = theme.system_font .. '8'
theme.hotkeys_group_margin     = 0

-- Layouts
theme.layout_max      = icon_dir .. '/layouts/max.svg'
theme.layout_floating = icon_dir .. '/layouts/float.svg'
theme.layout_fairh    = icon_dir .. '/layouts/fair-h.svg'
theme.layout_fairv    = icon_dir .. '/layouts/fair-v.svg'
theme.layout_tile     = icon_dir .. '/layouts/tile.svg'

-- Menus
theme.menu_submenu_icon = icon_dir .. '/misc/half-arrow-right.svg'
theme.menu_font = theme.system_font .. '10'
theme.menu_height = 20
theme.menu_width = 175
theme.menu_border_color = theme.border_focus
theme.menu_border_width = theme.border_width
theme.menu_fg_focus = theme.fg_color
theme.menu_bg_focus = theme.bg_primary
theme.menu_fg_normal = theme.fg_color
theme.menu_bg_normal = theme.bg_color

-- Titlebars
    -- not implemented yet
-- Wibar
    -- not implemented yet

-- Layoutlist
theme.layoutlist_fg_normal = theme.fg_color
theme.layoutlist_bg_normal = theme.bg_color
theme.layoutlist_fg_selected = theme.fg_color
theme.layoutlist_bg_selected = theme.bg_primary_darkened
theme.layoutlist_font = theme.system_font .. '12'
theme.layoutlist_font_selected = theme.system_font .. 'bold 13'
theme.layoutlist_spacing = 5
theme.layoutlist_shape = gears.shape.rectangle
theme.layoutlist_shape_border_width = theme.border_width_reduced
theme.layoutlist_shape_border_color = theme.border_secondary
theme.layoutlist_shape_selected = gears.shape.rectangle
theme.layoutlist_shape_border_width_selected = theme.border_width
theme.layoutlist_shape_border_color_selected = theme.border_focus

-- Separators
    -- not implemented yet

-- Mouse
theme.snap_bg           = pallet.accent.true_color
theme.snap_border_width = 1
theme.snap_shape        = gears.shape.rectangle
theme.snapper_gap       = 0

-- Prompts
theme.prompt_gg_cursor = theme.fg_color
theme.prompt_fg_cursor = theme.bg_color
theme.prompt_font      = theme.system_font .. 'Mono 10'

-- Tooltips
theme.tooltip_border_color = pallet.primary.lighten_50
theme.tooltip_border_width = 1
theme.tooltip_bg           = pallet.background.shaden_90
theme.tooltip_fg           = theme.fg_color
theme.tooltip_opacity      = 0.75
theme.tooltip_shape        = gears.shape.rectangle

-- Taglist
theme.taglist_bg_focus    = string.format(
    'linear:0,0:%d,0:0,%s:0.08,%s:0.08,%s:1,%s',
    40,
    pallet.primary.true_color,
    pallet.primary.true_color,
    pallet.background.shaden_100,
    pallet.background.shaden_100
)
theme.taglist_bg_urgent   = string.format(
    'linear:0,0:%d,0:0,%s:0.08,%s:0.08,%s:1,%s',
    40,
    pallet.accent.true_color,
    pallet.accent.true_color,
    pallet.background.shaden_100,
    pallet.background.shaden_100
)
theme.taglist_bg_occupied = pallet.background.shaden_95
theme.taglist_bg_empty    = pallet.background.shaden_100

-- Tasklist
theme.tasklist_font        = theme.system_font .. '11'
theme.tasklist_fg_normal   = pallet.background.lighten_15
theme.tasklist_bg_normal   = pallet.background.shaden_100
theme.tasklist_fg_focus    = pallet.background.lighten_100
theme.tasklist_bg_focus    = pallet.primary.shaden_80
theme.tasklist_fg_urgent   = theme.fg_color
theme.tasklist_bg_urgent   = pallet.primary.shaden_30
theme.tasklist_fg_minimize = pallet.background.shaden_50
theme.tasklist_bg_minimize = theme.tasklist_bg_normal
theme.tasklist_shape       = gears.shape.powerline
theme.tasklist_shape_border_width = 1
theme.tasklist_shape_border_color = pallet.primary.true_color
theme.tasklist_shape_border_color_minimized = pallet.primary.shaden_60

-- Arcchart
theme.arcchart_color = pallet.primary.true_color
theme.arcchart_bg    = pallet.background.shaden_85

-- Checkbox
theme.checkbox_bg           = theme.bg_color
theme.checkbox_color        = theme.border_focus
theme.checkbox_check_color  = pallet.primary.shaden_20
theme.checkbox_shape        = gears.shape.circle
theme.checkbox_check_shape        = gears.shape.circle
theme.checkbox_border_width = 1
theme.checkbox_border_color = theme.border_focus
theme.checkbox_paddings     = 2

-- Progressbar
theme.progressbar_bg           = theme.bg_neutral
theme.progressbar_fg           = pallet.primary.true_color
theme.progressbar_shape        = gears.shape.hexagon
theme.progressbar_border_width = 0
theme.progressbar_margins      = 0
theme.progressbar_paddings     = 0

return theme

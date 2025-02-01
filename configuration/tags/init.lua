local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')
local apps  = require('configuration.apps')

local tags = {
    {
        type = 'browser',
        icon = icons.browser,
        default_app = apps.default.browser,
        layout = awful.layout.suit.tile
    },
    {
        type = 'terminal',
        icon = icons.terminal,
        default_app = apps.default.terminal,
        layout = awful.layout.suit.fair.horizontal
    },
    {
        type = 'social',
        icon = icons.social,
        default_app = apps.default.social,
        layout = awful.layout.suit.max
    },
    {
        type = 'game',
        icon = icons.game,
        default_app = apps.default.rofi,
        layout = awful.layout.suit.max
    },
    {
        type = 'files',
        icon = icons.folder,
        default_app = apps.default.files,
        layout = awful.layout.suit.fair
    },
    {
        type = 'coding',
        icon = icons.coding,
        default_app = apps.default.coding,
        layout = awful.layout.suit.tile
    },
    {
        type = 'edit',
        icon = icons.edit,
        default_app = apps.default.edit,
        layout = awful.layout.suit.max
    },
    {
        type = 'music',
        icon = icons.music,
        default_app = apps.default.music,
        layout = awful.layout.suit.max
    },
    {
        type = 'any',
        icon = icons.lab,
        default_app = apps.default.rofi,
        layout = awful.layout.suit.floating
    }
}

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating
}

awful.screen.connect_for_each_screen(
    function(s)
        for i, tag in pairs(tags) do
            awful.tag.add(
                i,
                {
                    icon              = tag.icon,
                    icon_only         = true,
                    layout            = tag.layout,
                    gap_single_client = false,
                    gap               = 4,
                    screen            = s,
                    default_app       = tag.default_app,
                    selected          = i == 1
                }
            )
        end
    end
)

_G.tag.connect_signal(
    'property::layout',
    function(t)
        local currentLayout = awful.tag.getproperty(t, 'layout')
        if (currentLayout == awful.layout.suit.max) then
            t.gap = 0
        else
            t.gap = 4
        end
    end
)

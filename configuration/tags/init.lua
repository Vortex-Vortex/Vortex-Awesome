local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')

local tags = {
    {
        icon = icons.menu,
        layout = awful.layout.suit.tile,
        type = 'none'
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
--                     defaultApp        = tag.defaultApp,
                    selected          = i == 1
                }
            )
        end
    end
)

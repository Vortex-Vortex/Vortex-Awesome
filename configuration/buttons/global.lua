local awful = require('awful')

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

-- Key Bindings
local globalButtons = awful.util.table.join(
    awful.button(
        {'Control', modkey},
        4,
        function()
            awful.spawn('amixer -D pulse sset Master 10%+')
        end,
        {description = 'Volume up', group = 'Hotkeys'}
    ),
    awful.button(
        {'Control', modkey},
        5,
        function()
            awful.spawn('amixer -D pulse sset Master 10%-')
        end,
        {description = 'Volume down', group = 'Hotkeys'}
    )
)


return globalButtons

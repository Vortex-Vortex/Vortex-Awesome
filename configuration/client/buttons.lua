local awful = require('awful')

local modkey = require('configuration.keys.mod').modKey

local clientButtons = awful.util.table.join(
    awful.button(
        {},
        1,
        function(c)
            _G.client.focus = c
            c:raise()
        end
    ),
    awful.button(
        {modkey},
        1,
        awful.mouse.client.move
    ),
    awful.button(
        {modkey},
        3,
        awful.mouse.client.resize
    ),
    awful.button(
        {modkey},
        4,
        function()
            awful.layout.inc(1)
        end
    ),
    awful.button(
        {modkey},
        5,
        function()
            awful.layout.inc(-1)
        end
    ),
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

return clientButtons

local awful = require('awful')
local gears = require('gears')
local modkey = require('configuration.keys.mod').modkey

local client_buttons = gears.table.join(
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
        {'Control', modkey},
        4,
        function()
            _G.update_volume('+5')
        end
    ),
    awful.button(
        {'Control', modkey},
        5,
        function()
            _G.update_volume('-5')
        end
    )
)

return client_buttons

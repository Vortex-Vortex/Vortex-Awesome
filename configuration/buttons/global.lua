local awful = require('awful')
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

-- Key Bindings
local globalButtons = awful.util.table.join(
    awful.button(
        {'Control', modkey},
        4,
        function()
            _G.volume_control('up', 5)
        end,
        nil
    ),
    awful.button(
        {'Control', modkey},
        5,
        function()
            _G.volume_control('down', 5)
        end,
        nil
    )
)


return globalButtons

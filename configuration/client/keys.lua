local awful = require('awful')

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

require('awful.autofocus')

local clientKeys = awful.util.table.join(
    awful.key(
        {modkey},
        'f',
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = 'toggle fullscreen', group = 'Client'}
    ),
    awful.key(
        {modkey},
        'q',
        function(c)
            c:kill()
        end,
        {description = 'close', group = 'Client'}
    )
)

return clientKeys

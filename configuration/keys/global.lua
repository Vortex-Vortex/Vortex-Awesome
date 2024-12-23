local awful = require('awful')
local gears = require('gears')

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local apps = require('configuration.apps')

local global_keys = gears.table.join(
    awful.key(
        {modkey},
        'x',
        function()
            awful.spawn(apps.default.terminal)
        end,
        {description = 'Open Terminal', group = 'Launcher'}
    ),
    awful.key(
        {modkey, 'Control'},
        'r',
        _G.awesome.restart,
        {description = 'Reload Awesome', group = 'Awesome WM'}
    )
)

return global_keys

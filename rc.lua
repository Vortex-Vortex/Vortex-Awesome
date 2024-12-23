local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')

require('awful.autofocus')

beautiful.init(require('theme'))

-- naughty
require('layout')

-- modules

-- Setup configurations
require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))

--
gears.wallpaper.set('#ffffff')
--

gears.timer{
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}

_G.client.connect_signal(
    'manage',
    function(c)
        if not _G.awesome.startup then
            awful.client.setslave(c)
        end

        if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
        end
    end
)

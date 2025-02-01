local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')

require('awful.autofocus')

beautiful.init(require('theme'))

require('module.notifications')
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
        elseif not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
        end
    end
)

_G.client.connect_signal(
    'mouse::enter',
    function(c)
        c:emit_signal(
            'request::activate',
            'mouse_enter',
            {raise = true}
        )
    end
)

_G.client.connect_signal(
  'focus',
  function(c)
    c.border_color = beautiful.border_focus
  end
)
_G.client.connect_signal(
  'unfocus',
  function(c)
    c.border_color = beautiful.border_normal
  end
)

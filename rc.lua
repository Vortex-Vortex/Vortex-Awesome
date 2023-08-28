local gears     = require('gears')
local awful     = require('awful')
local wibox     = require("wibox")
local beautiful = require('beautiful')
require('awful.autofocus')

    -- Theme Loader
beautiful.init(require('theme'))

    -- Layout
require('module.notifications')
require('layout')

    -- Modules
require('module.auto-start')
require('module.decorate-client')
require('module.exit-screen')
require('module.quake-terminal')

    -- Setup Configurations
require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))
_G.root.buttons(require('configuration.buttons.global'))

    -- New Client configurations
_G.client.connect_signal(
    'manage',
    function(c)
        if not _G.awesome.startup then
            awful.client.setslave(c)
        end

            -- Prevents clients from being unreachable on screen change
        if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
        end
    end
)
--[[
_G.client.connect_signal(
  'mouse::enter',
  function(c)
        -- Focus follows mouse
    c:emit_signal('request::activate', 'mouse_enter', {raise = true})
  end
)]]
    -- Glowing border for focused windows
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

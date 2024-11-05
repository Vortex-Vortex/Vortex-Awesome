local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local dpi = beautiful.xresources.apply_dpi

    -- Naughty Presets
naughty.config.padding = dpi(4)
naughty.config.spacing = dpi(4)
function naughty.config.notify_callback(args)
    _G.notification_call(args)
    return args
end

naughty.config.defaults.timeout       = 10
naughty.config.defaults.screen        = 1
naughty.config.defaults.position      = 'bottom_middle'
naughty.config.defaults.margin        = dpi(8)
naughty.config.defaults.ontop         = true
naughty.config.defaults.font          = 'Roboto Regular 8'
naughty.config.defaults.icon          = nil
naughty.config.defaults.icon_size     = dpi(50)
naughty.config.defaults.shape         = gears.shape.rectangle
naughty.config.defaults.border_width  = beautiful.border_width
naughty.config.defaults.border_color  = beautiful.border_focus
naughty.config.defaults.hover_timeout = 0

    -- Error handling
if _G.awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = 'Oops, there were errors during startup!',
            text = _G.awesome.startup_errors
        }
    )
end

do
    local in_error = false
    _G.awesome.connect_signal(
        'debug::error',
        function(err)
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = 'Oops, an error happened!',
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

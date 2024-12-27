local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local naughty = require('naughty')

    -- Naughty Presets
config = {
    padding = 4,
    spacing = 4,
    timeout = 10,
    screen = 1,
    position = 'top_middle',
    margin = 8,
    ontop = true,
    font = beautiful.system_font .. '9',
    icon = nil,
    icon_size = 50,
    bg = beautiful.bg_color,
    fg = beautiful.fg_color,
    shape = gears.shape.rectangle,
    border_width = beautiful.border_width,
    border_color = beautiful.border_focus,
    hover_timeout = 0
}

for property, value in pairs(config) do
    naughty.config.defaults[property] = value
end

    -- Error Handling
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

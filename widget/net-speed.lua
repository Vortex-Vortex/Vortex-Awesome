local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local icons = require('theme.icons')

local function Net_speed()
    local interface = 'eno1'

    local function make_readable(bytes)
        bits = 8 * bytes
        if bits < 1000 then
            speed = bits
            dim = 'b/s'
        elseif bits < 1000000 then
            speed = bits / 1024
            dim = 'Kb/s'
        elseif bits < 1000000000 then
            speed = bits / 1024000
            dim = 'Mb/s'
        else
            speed = bits / 1024000000
            dim = 'Gb/s'
        end
        return math.floor(speed + 0.5) .. dim
    end

    local x_image = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.arrow_up
    }
    local x_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = '0b/s',
        font = beautiful.system_font .. 'bold 10',
        align = 'right',
        forced_width = 60
    }

    local net_speed_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        x_image,
        {
            widget = wibox.container.margin,
            x_textbox,
            right = 10
        }
    }

    local prev_rx = 0
    local prev_tx = 0

    local function update_widget()
        awful.spawn.easy_async_with_shell(
            'cat /sys/class/net/' .. interface .. '/statistics/*_bytes',
            function(stdout)
                local cur_rx, cur_tx = string.match(stdout, '(%d+)\n(%d+)')

                local speed_rx = cur_rx - prev_rx
                local speed_tx = cur_tx - prev_tx

                if speed_rx > speed_tx then
                    x_textbox.text = tostring(make_readable(speed_rx))
                    x_image.image = icons.arrow_down
                else
                    x_textbox.text = tostring(make_readable(speed_tx))
                    x_image.image = icons.arrow_up
                end

                prev_rx = cur_rx
                prev_tx = cur_tx
            end
        )
    end

    if gears.filesystem.dir_readable('/sys/class/net/' .. interface) then
        gears.timer{
            timeout = 1,
            call_now = true,
            autostart = true,
            callback = update_widget
        }
    end

    return net_speed_widget
end

return Net_speed

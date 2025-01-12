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
        elseif bits < 1000000000000 then
            speed = bits / 1024000000
            dim = 'Gb/s'
        end
        return math.floor(speed + 0.5) .. dim
    end

    local rx_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = '0b/s',
        font = beautiful.system_font .. 'bold 10',
        align = 'left',
        forced_width = 55
    }
    local tx_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = '0b/s',
        font = beautiful.system_font .. 'bold 10',
        align = 'left',
        forced_width = 55
    }

    local net_speed_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.widget.imagebox,
            image = icons.arrow_down
        },
        rx_textbox,
        {
            widget = wibox.widget.imagebox,
            image = icons.arrow_up
        },
        tx_textbox
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

                rx_textbox.text = tostring(make_readable(speed_rx))
                tx_textbox.text = tostring(make_readable(speed_tx))

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

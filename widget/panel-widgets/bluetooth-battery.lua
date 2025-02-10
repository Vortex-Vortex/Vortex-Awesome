local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

local icons = require('theme.icons')

local function battery_bar()
    local battery_image = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.bluetooth_battery_icon
    }
    local battery_text_cur = wibox.widget{
        widget = wibox.widget.textbox,
        text = '-',
        font = beautiful.system_font .. '9',
        align = 'center',
        valign = 'center',
        forced_height = 30,
        forced_width = 45
    }
    local battery_text_max = wibox.widget{
        widget = wibox.widget.textbox,
        text = '100%',
        font = beautiful.system_font .. '9',
        align = 'center',
        valign = 'center',
        forced_height = 30,
        forced_width = 45
    }

    local battery_bar = wibox.widget{
        widget = wibox.widget.progressbar,
        max_value = 100,
        value = 0
    }

    local battery_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        forced_height = 30,
        battery_image,
        {
            layout = wibox.layout.align.horizontal,
            battery_text_cur,
            {
                widget = wibox.container.margin,
                battery_bar,
                top = 10,
                bottom = 10
            },
            battery_text_max
        }
    }

    local percentage = 0

    local function update_battery()
        awful.spawn.easy_async_with_shell(
            [[upower -i $(upower -e | grep -i headset) | grep percentage]],
            function(stdout)
                if string.find(stdout, '%w') then
                    percentage = stdout:match('%s(%d+)%%')
                    battery_bar.value = tonumber(percentage)
                    battery_text_cur.text = percentage .. '%'
                else
                    battery_bar.value = 0
                    battery_text_cur.text = 'NaN%'
                end
            end
        )
    end

    local battery_timer = gears.timer{
        timeout = 1,
        call_now = true,
        callback = update_battery
    }

    return battery_widget, battery_timer
end
return battery_bar

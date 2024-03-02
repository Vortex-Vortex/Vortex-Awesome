local awful     = require('awful')
local wibox     = require('wibox')
local icons     = require('theme.icons')
local gears     = require('gears')
local beautiful = require('beautiful')

local function create_slider()

    local bluetooth_battery_icon = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.bluetooth_battery
    }

    local bluetooth_battery_text = wibox.widget{
        widget = wibox.widget.textbox,
        text   = '--',
        font   = 'Roboto medium 9',
        align  = "center",
        valign = "center"
    }

    local slider_bar = wibox.widget{
        widget           = wibox.widget.progressbar,
        max_value        = 100,
        value            = 0,
        forced_height    = 5,
        shape            = gears.shape.rounded_rect,
        background_color = beautiful.bg_focus,
        color            = beautiful.border_focus,
    }

    local function update_slider()
        awful.spawn.easy_async_with_shell(
            [[bash -c "bluetoothctl show | grep Powered | sed 's/.*Powered: \(.*\)/\1/'"]],
            function(stdout)
                if string.find(stdout, "yes") then
                    awful.spawn.easy_async_with_shell(
                        [[bash -c "upower --dump"]],
                        function(stdout)
                            if string.find(stdout, "headset") then
                                percentage = stdout:match('percentage:%s*(%d+)%%')
                            else
                                percentage = "0"
                            end
                            slider_bar.value = tonumber(percentage)
                            bluetooth_battery_text.text = percentage .. '%'
                        end
                    )
                end
            end
        )
    end

    local timer = gears.timer{
        timeout   = 60,
        autostart = true,
        call_now  = true,
        callback  = function()
            update_slider()
        end
    }

    local slider = wibox.widget{
        {
            {
                {
                    bluetooth_battery_icon,
                    widget = wibox.container.place,
                    align  = 'center',
                    valign = 'center'
                },
                widget        = wibox.container.margin,
                forced_height = 30,
                forced_width  = 30,
            },
            {
                bluetooth_battery_text,
                widget        = wibox.container.margin,
                forced_height = 30,
                forced_width  = 90
            },
            {
                slider_bar,
                widget        = wibox.container.margin,
                forced_height = 40,
                top           = 15,
                bottom        = 15,
                left          = 1
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin,
        left = 25 + 8,
        right = 25 + 8
    }

    return slider
end

return create_slider()

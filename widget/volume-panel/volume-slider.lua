local awful     = require('awful')
local wibox     = require('wibox')
local icons     = require('theme.icons')
local gears     = require('gears')
local beautiful = require('beautiful')

local function create_slider()

    local volume_icon = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.volume
    }

    local volume_percent = wibox.widget{
        widget = wibox.widget.textbox,
        text   = '25%',
        font   = 'Roboto medium 9',
        align  = "center",
        valign = "center"
    }

    local slider_handle = wibox.widget {
        widget              = wibox.widget.slider,
        bar_shape           = gears.shape.rounded_rect,
        bar_height          = 0,
        handle_color        = beautiful.fg_focus,
        handle_shape        = gears.shape.circle,
        handle_border_color = beautiful.bg_normal .. '11',
        handle_border_width = beautiful.border_width - 1,
        value               = 25,
        forced_height       = 40
    }

    local slider_bar = wibox.widget{
        widget           = wibox.widget.progressbar,
        max_value        = 100,
        value            = 25,
        forced_height    = 5,
        shape            = gears.shape.rounded_rect,
        background_color = beautiful.bg_focus,
        color            = beautiful.border_focus,
    }

    slider_handle:connect_signal(
        'property::value',
        function()
            slider_bar.value = slider_handle.value
            if slider_handle.value <= 100 then
                awful.spawn('amixer -D pulse sset Master ' .. slider_handle.value .. '%')
            end
            volume_percent.text = slider_handle.value .. '%'
        end
    )

    local function update_slider()
        awful.spawn.easy_async(
            [[bash -c "amixer -D pulse sget Master"]],
            function(stdout)
                local volume = string.match(stdout, '(%d?%d?%d)%%')
                slider_handle.value = tonumber(volume)
                slider_bar.value = tonumber(volume)
                volume_percent.text = volume .. '%'
            end
        )
    end

    local timer = gears.timer{
        timeout   = 1,
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
                    volume_icon,
                    widget = wibox.container.place,
                    align  = 'center',
                    valign = 'center'
                },
                widget        = wibox.container.margin,
                forced_height = 30,
                forced_width  = 30,
            },
            {
                volume_percent,
                widget        = wibox.container.margin,
                forced_height = 30,
                forced_width  = 35,
            },
            {
                layout = wibox.layout.stack,
                {
                    slider_bar,
                    widget        = wibox.container.margin,
                    forced_height = 40,
                    top           = 15,
                    bottom        = 15,
                    left          = 1
                },
                slider_handle
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

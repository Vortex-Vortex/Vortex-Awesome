local awful               = require('awful')
local gears               = require('gears')
local beautiful           = require('beautiful')
local wibox               = require('wibox')
local icons               = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local function volume_widget_call(s)
    local width = s.geometry.width

    local popup = awful.popup{
        ontop   = true,
        visible = false,
        shape   = gears.shape.rectangle,
        x       = width - 85,
        y       = 50,
        maximum_width = 80,
        border_width  = beautiful.border_width,
        border_color  = beautiful.border_focus,
        widget = {}
    }

    local volume_widget = wibox.widget{
        {
            {
                wibox.widget{
                    widget = wibox.widget.imagebox,
                    image = icons.volume
                },
                widget = wibox.container.place,
                align = 'center',
                valign = 'center'
            },
            widget        = wibox.container.margin,
            forced_height = 25,
            forced_width  = 25,
        },
        widget = clickable_container,
        shape = gears.shape.circle
    }

    local volume_text = wibox.widget{
        widget = wibox.widget.textbox,
        text = '--',
        align = 'center',
        valign = 'center',
        forced_height = 20,
        forced_width = 20
    }

    local volume_bar = wibox.widget{
        max_value        = 100,
        value            = 20,
        color            = beautiful.border_focus,
        background_color = beautiful.bg_focus,
        widget           = wibox.widget.progressbar,
    }

    local volume_bar_container = wibox.widget{
        {
            {
                volume_bar,
                forced_height = 120,
                forced_width  = 15,
                direction     = 'east',
                widget        = wibox.container.rotate,
            },
            forced_height = 150,
            forced_width = 35,
            top = 10,
            bottom = 0,
            left = 10,
            right = 10,
            widget = wibox.container.margin
        },
        volume_text,
        layout = wibox.layout.fixed.vertical
    }

    popup.widget = volume_bar_container

    local update_bar = function(new_value)
        value = string.match(new_value, "(%d?%d?%d)%%")
        volume_bar.value = tonumber(value)
        volume_text.text = tostring(value)
    end

    local popup_timer = gears.timer{
        timeout = 2,
        callback = function()
            popup.visible = false
        end,
        single_shot = true
    }

    volume_widget:connect_signal("mouse::enter", function()
        awful.spawn.easy_async_with_shell([[amixer -D pipewire sget Master]], function(stdout)
            update_bar(stdout)
        end)
        popup.visible = true
        popup_timer:stop()
    end)
    volume_widget:connect_signal("mouse::leave", function()
        if popup_timer.started == true then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end)

    volume_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    awful.spawn.easy_async_with_shell([[amixer -D pipewire set Master toggle]], function(stdout)
                        update_bar(stdout)
                    end)
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.spawn.easy_async_with_shell([[amixer -D pipewire sset Master 2%+]], function(stdout)
                        update_bar(stdout)
                    end)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.spawn.easy_async_with_shell([[amixer -D pipewire sset Master 2%-]], function(stdout)
                        update_bar(stdout)
                    end)
                end
            )
        )
    )

    volume_control = function(updown, value)
        if updown == 'up' then
            awful.spawn.easy_async_with_shell('amixer -D pipewire sset Master ' .. value .. '%+', function(stdout)
                update_bar(stdout)
            end)
        else
            awful.spawn.easy_async_with_shell('amixer -D pipewire sset Master ' .. value .. '%-', function(stdout)
                update_bar(stdout)
            end)
        end
        popup.visible = true
        if popup_timer.started == true then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end

    return volume_widget
end

return volume_widget_call

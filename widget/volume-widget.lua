local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

local icons = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local function Volume_widget(s)
    local screen_width = s.geometry.width

    local popup_set_timer

    local popup = awful.popup{
        ontop   = true,
        visible = false,
        shape   = gears.shape.rectangle,
        x       = screen_width - 80,
        y       = 50,
        maximum_width = 30,
        maximum_height = 180,
        border_width  = beautiful.border_width,
        border_color  = beautiful.border_focus,
        widget = {}
    }

    local volume_widget_icon = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.volume_full_icon
    }

    local volume_widget = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                widget = wibox.container.place,
                volume_widget_icon,
                halign = 'center',
                valign ='center'
            },
            forced_height = 25,
            forced_width = 30,
            left = 2,
            right = 2
        }
    )

    local volume_text = wibox.widget{
        widget = wibox.widget.textbox,
        text = '50',
        font = beautiful.system_font .. 'mono bold 10',
        align = 'center',
        valign = 'center',
        forced_height = 20,
        forced_width = 20
    }

    local volume_bar = wibox.widget{
        widget = wibox.widget.progressbar,
        max_value = 100,
        value = 50
    }

    local volume_bar_container = {
        widget = wibox.container.margin,
        {
            widget = wibox.container.rotate,
            volume_bar,
            direction = 'east'
        },
        left = 7,
        right = 7,
        top = 5,
        bottom = 0
    }

    popup:setup(
        {
            layout = wibox.layout.align.vertical,
            nil,
            volume_bar_container,
            volume_text
        }
    )

    local function update_volume_widget(stdout)
        local volume, status = string.match(stdout, '%[(%d+)%%%]%s+%[(%l+)%]')
        if status == 'off' then
            volume_widget_icon.image = icons.volume_muted_icon
            volume_bar.value = 0
            volume_text.text = 'X'
        else
            volume_widget_icon.image = icons.volume_full_icon
            volume_bar.value = tonumber(volume)
            volume_text.text = tostring(volume)
        end
    end

    function update_volume(offset)
        local get_set = offset and 'sset' or 'sget'
        offset = offset or ''

        if string.find(offset, '^[+-]') then
            signal, offset = string.match(offset, '^([%+%-])(%d+)')
        elseif offset ~= '' then
            signal, offset = '', 'toggle'
        end

        local CMD = string.format('amixer -D pipewire %s Master %s%%%s | sed -n "7p"', get_set, offset, signal)

        awful.spawn.easy_async_with_shell(
            CMD,
            function(stdout)
                update_volume_widget(stdout)
            end
        )
        popup_set_timer()
    end

    volume_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    update_volume('toggle')
                end
            ),
            awful.button(
                {},
                4,
                function()
                    update_volume('+2')
                end
            ),
            awful.button(
                {},
                5,
                function()
                    update_volume('-2')
                end
            )
        )
    )


    local popup_timer = gears.timer{
        timeout = 1,
        callback = function()
            popup.visible = false
        end,
        single_shot = true
    }

    function popup_set_timer()
        popup.visible = true
        if popup_timer.started == true then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end

    update_volume()

    volume_widget:connect_signal('mouse::enter', function()
        popup.visible = true
        if popup_timer.started then popup_timer:stop() end
    end)
    volume_widget:connect_signal('mouse::leave', function()
        if popup_timer.started == true then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end)

    return volume_widget
end
return Volume_widget

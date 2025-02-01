local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

local icons = require('theme.icons')

local function storage_bar()
    local storage_image = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.storage_icon
    }
    local storage_text_cur = wibox.widget{
        widget = wibox.widget.textbox,
        text = '-',
        font = beautiful.system_font .. '9',
        align = 'center',
        valign = 'center',
        forced_height = 30,
        forced_width = 45
    }
    local storage_text_max = wibox.widget{
        widget = wibox.widget.textbox,
        text = '-',
        font = beautiful.system_font .. '9',
        align = 'center',
        valign = 'center',
        forced_height = 30,
        forced_width = 45
    }

    local storage_bar = wibox.widget{
        widget = wibox.widget.progressbar,
        max_value = 100,
        value = 0
    }

    local storage_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        forced_height = 30,
        storage_image,
        {
            layout = wibox.layout.align.horizontal,
            storage_text_cur,
            {
                widget = wibox.container.margin,
                storage_bar,
                top = 10,
                bottom = 10
            },
            storage_text_max
        }
    }

    local function update_storage()
        awful.spawn.easy_async_with_shell(
            'df -h /home | sed -n 2p',
            function(stdout)
                local total, used, percent_used = string.match(stdout, '%s([^%s]+)%s+([^%s]+)%s+.*%s(%d+)%%')

                storage_bar.value = tonumber(percent_used)
                storage_text_cur.text = used
                storage_text_max.text = total
            end
        )
    end

    local storage_timer = gears.timer{
        timeout = 1,
        call_now = true,
        callback = update_storage
    }

    return storage_widget, storage_timer
end
return storage_bar

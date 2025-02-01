local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

local icons = require('theme.icons')

local function Ram_bar()
    local ram_image = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.ram_icon
    }
    local ram_text_cur = wibox.widget{
        widget = wibox.widget.textbox,
        text = '-',
        font = beautiful.system_font .. '9',
        align = 'center',
        valign = 'center',
        forced_height = 30,
        forced_width = 45
    }
    local ram_text_max = wibox.widget{
        widget = wibox.widget.textbox,
        text = '-',
        font = beautiful.system_font .. '9',
        align = 'center',
        valign = 'center',
        forced_height = 30,
        forced_width = 45
    }

    local ram_bar = wibox.widget{
        widget = wibox.widget.progressbar,
        max_value = 100,
        value = 0
    }

    local ram_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        forced_height = 30,
        ram_image,
        {
            layout = wibox.layout.align.horizontal,
            ram_text_cur,
            {
                widget = wibox.container.margin,
                ram_bar,
                top = 10,
                bottom = 10
            },
            ram_text_max
        }
    }

    local function update_ram()
        awful.spawn.easy_async_with_shell(
            'free | grep -z Mem.*Swap.*',
            function(stdout)
                local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
                stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')

                total = total + total_swap
                used = used + used_swap

                ram_bar.value = (used / total * 100)
                ram_text_cur.text = string.format('%.1fG', used / 1024 / 1024)
                ram_text_max.text = string.format('%.1fG', total / 1024 / 1024)
            end
        )
    end

    local ram_timer = gears.timer{
        timeout = 1,
        call_now = true,
        callback = update_ram
    }

    return ram_widget, ram_timer
end
return Ram_bar

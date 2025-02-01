local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

local icons = require('theme.icons')

local function Cpu_widget()
    local function create_textbox(args)
        return wibox.widget{
            widget = wibox.widget.textbox,
            text = args.text,
            font = beautiful.system_font .. '9',
            forced_width = 50,
            align = 'center',
            valign = 'center'
        }
    end

    local function create_container(widget)
        return wibox.widget{
            widget = wibox.container.background,
            widget,
            shape = gears.shape.rectangle,
            shape_border_width = beautiful.border_width,
            shape_border_color = beautiful.border_secondary
        }
    end

    local function create_progress_bar()
        return wibox.widget{
            widget           = wibox.widget.progressbar,
            max_value        = 100,
            value            = 0
        }
    end

    local cpu_widget = {
        layout = wibox.layout.flex.vertical,
        spacing = 5
    }

    local n_cores = tonumber(io.popen('nproc --all'):read('*a'))
    for i = 0, n_cores do
        local cpu_text = wibox.widget{
            widget = wibox.container.background,
            {
                widget = wibox.widget.textbox,
                text = i == 0 and 'CPU-Total' or 'CPU-' .. i,
                font = beautiful.system_font .. '9',
                forced_width = 60,
                align = 'center',
                valign = 'center'
            },
            shape = gears.shape.rectangle,
            shape_border_width = beautiful.border_width,
            shape_border_color = beautiful.border_secondary
        }

        local cpu_row = wibox.widget{
            layout = wibox.layout.fixed.horizontal,
            fill_space = true,
            forced_height = 20,
            cpu_text,
            {
                widget = wibox.container.background,
                id = 'cpu_percent_container_id',
                {
                    widget = wibox.widget.textbox,
                    id = 'cpu_percent_id',
                    text = '100%',
                    font = beautiful.system_font .. '9',
                    forced_width = 35,
                    align = 'center',
                    valign = 'center'
                },
                shape = gears.shape.rectangle,
                shape_border_width = beautiful.border_width,
                shape_border_color = beautiful.border_secondary
            },
            {
                widget = wibox.container.margin,
                id = 'cpu_bar_container_id',
                {
                    widget = wibox.widget.progressbar,
                    id = 'cpu_bar_id',
                    max_value = 100,
                    value = 0
                },
                top = 5,
                bottom = 5
            }
        }
        cpu_widget[i] = cpu_row
    end

    cpu_data = {}
    for i = 0, n_cores do
        cpu_data[i] = {total_prev = 0, idle_prev = 0}
    end
    local function update_cpu()
        awful.spawn.easy_async_with_shell(
            [[grep '^cpu' /proc/stat]],
            function(stdout)
                for line in string.gmatch(stdout, '[^\r\n]+') do
                    local name, user, nice, system, idle, iowait, irq, softirq, steal, _, _ = string.match(line, '(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')
                    i = name == 'cpu' and 0 or tonumber(name:match('cpu(%d+)')) + 1
                    local total = user + nice + system + idle + iowait + irq + softirq + steal
                    local diff_idle  = idle - cpu_data[i].idle_prev
                    local diff_total = total - cpu_data[i].total_prev
                    local usage = 100 * (diff_total - diff_idle) / diff_total

                    cpu_data[i]['total_prev'] = total
                    cpu_data[i]['idle_prev']  = idle
                    cpu_widget[i].cpu_percent_container_id.cpu_percent_id.text = math.floor(usage) .. '%'
                    cpu_widget[i].cpu_bar_container_id.cpu_bar_id.value = usage
                end
            end
        )
    end

    local cpu_timer = gears.timer{
        timeout = 1,
        call_now = true,
        callback = update_cpu
    }

    return cpu_widget, cpu_timer
end
return Cpu_widget

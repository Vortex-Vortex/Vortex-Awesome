local awful     = require('awful')
local beautiful = require('beautiful')
local wibox     = require('wibox')
local gears     = require('gears')

local CMD = [[sh -c "grep '^cpu.' /proc/stat"]]

local cpu_rows = {
    spacing = 7,
    layout  = wibox.layout.fixed.vertical,
}

local function create_textbox(args)
    return wibox.widget{
        widget        = wibox.widget.textbox,
        text          = args.text,
        font          = args.font or 'Roboto medium 9',
        forced_height = args.forced_height or nil,
        forced_width  = args.forced_width or 40,
        align         = args.align or 'center',
        valign        = args.valign or 'center'
    }
end

local function create_container(widget)
    return wibox.widget{
        widget,
        widget             = wibox.container.background,
        shape              = gears.shape.rectangle,
        shape_border_width = beautiful.border_width + 1,
        shape_border_color = beautiful.border_normal,
        bg                 = '#00000000'
    }
end

local function create_progress_bar()
    return wibox.widget{
        widget           = wibox.widget.progressbar,
        max_value        = 100,
        value            = 100,
        forced_height    = 5,
        forced_width     = 320,
        shape            = gears.shape.rounded_rect,
        background_color = beautiful.bg_focus,
        color            = beautiful.border_focus,
        paddings         = 0
    }
end

local function create_container_margin(widget, args)
    return wibox.widget{
        widget,
        widget        = wibox.container.margin,
        forced_height = args.forced_height or nil,
        forced_width  = args.forced_width or nil,
        margins       = args.margins or nil,
        top           = args.top or nil,
        bottom        = args.bottom or nil,
        right         = args.right or nil,
        left          = args.left or nil,
    }
end

local i                    = 0
local cpu_percent          = {}
local cpu_percent_enclosed = {}
local cpu_bar              = {}
local cpu_bar_enclosed     = {}

local handle = io.popen(CMD)
local result = handle:read("*a")
handle:close()

for line in result:gmatch("[^\r\n]+") do
    if i == 0 then
        cpu_num = create_container(create_textbox({ text = 'CPU Total' }))
    else
        cpu_num = create_container(create_textbox({ text = 'CPU - ' .. i }))
    end

    cpu_percent[i]       = create_textbox({ text = '00%' })
    cpu_percent_enclosed = create_container(cpu_percent[i])

    cpu_bar[i]       = create_progress_bar()
    cpu_bar_enclosed = create_container_margin(
        cpu_bar[i],
        {
            forced_height = 10,
            top           = 5,
            bottom        = 5,
            left          = 2
        }
    )

    local row = wibox.widget{
        cpu_num,
        cpu_percent_enclosed,
        cpu_bar_enclosed,
        layout = wibox.layout.ratio.horizontal
    }
    row:ajust_ratio(2, 0.2, 0.15, 0.65)

    row_enclosed = create_container_margin(
        row,
        {
            left  = 25,
            right = 25
        }
    )

    cpu_rows[i] = row_enclosed
    i = i + 1
end

cpu_panel = wibox.widget{
    cpu_rows,
    widget = wibox.container.margin,
    margins = 8
}

cpus = {}
local function update_rows()
    local i = 0
    awful.spawn.easy_async_with_shell(CMD, function(stdout)
        for line in stdout:gmatch("[^\r\n]+") do
            if cpus[i] == nil then cpus[i] = {} end
            local name, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
                line:match('(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

            local total      = user + nice + system + idle + iowait + irq + softirq + steal

            local diff_idle  = idle - tonumber(cpus[i]['idle_prev'] == nil and 0 or cpus[i]['idle_prev'])
            local diff_total = total - tonumber(cpus[i]['total_prev'] == nil and 0 or cpus[i]['total_prev'])
            local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

            cpus[i]['total_prev'] = total
            cpus[i]['idle_prev']  = idle


            cpu_percent[i].text = math.floor(diff_usage) .. '%'
            cpu_bar[i].value    = diff_usage

            i = i + 1
        end
    end)
end

local timer = gears.timer{
    timeout   = 1,
    autostart = true,
    call_now  = true,
    callback  = function()
        update_rows()
    end
}

return cpu_panel

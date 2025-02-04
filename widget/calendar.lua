local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local naughty = require('naughty')
local clickable_container = require('widget.material.clickable-container')
local json = require('widget.utils.json')

local function Calendar(s)
    local screen_width = s.geometry.width

    local date_widget = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                widget = wibox.widget.textclock,
                font = beautiful.system_font .. 'mono bold 11',
                format = '%d.%m.%Y'
            },
            left = 12,
            right = 12
        }
    )

    local calendar_popup = awful.popup{
        ontop = true,
        visible = false,
        shape = gears.shape.rectangle,
        x = screen_width - 450,
        y = 50,
        maximum_width = 400,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
        widget = {}
    }

    local function create_textbox(text, font)
        return wibox.widget{
            widget = wibox.widget.textbox,
            text = text,
            font = font or beautiful.system_font .. '10',
            align = 'center',
            valign = 'center'
        }
    end

    local function create_month(date)
        num_rows = 6
        num_cols = 7
        local calendar_month_days_widget = wibox.widget{
            layout = wibox.layout.grid,
            expand = false,
            homogeneous = false,
            spacing = 1,
            forced_num_rows = num_rows,
            forced_num_cols = num_cols
        }

        local start_row = 1
        local week_start = 1 -- 1=Sunday, 2=Monday
        local last_day = os.date(
            "*t",
            os.time{
                year = date.year,
                month = date.month + 1,
                day = 0
            }
        )
        local month_days = last_day.day
        local column_first_day = (last_day.wday - month_days + 1 - week_start) % 7

        local date_header = wibox.widget{
            widget = wibox.container.margin,
            {
                widget = wibox.container.background,
                create_textbox(os.date("%B %Y", os.time{year = date.year, month = date.month, day = 1}), beautiful.system_font .. 'bold 13'),
                shape = gears.shape.rectangle,
                shape_border_width = beautiful.border_width + 1,
                shape_border_color = beautiful.border_normal
            },
            forced_height = 50,
            margins = 5
        }

        local weekdays = week_start == 1 and {
            "",
            "S",
            "M",
            "T",
            "T",
            "W",
            "F",
            "S"
        } or {
            "",
            "M",
            "T",
            "W",
            "T",
            "F",
            "S",
            "S"
        }
        local weekdays_header = wibox.widget{
            layout = wibox.layout.fixed.horizontal,
            spacing = 0,
            forced_height = 24
        }
        for i, weekday in ipairs(weekdays) do
            weekdays_header:add(
                wibox.widget{
                    widget = wibox.container.margin,
                    {
                        widget = wibox.container.background,
                        create_textbox(weekday, beautiful.system_font .. 'bold 10'),
                        bg = i == 1 and beautiful.bg_color or beautiful.bg_primary_darkened,
                        fg = beautiful.fg_color,
                        shape = gears.shape.circle
                    },
                    forced_width = i == 1 and 22 or 54, -- 7*54 + 22 = 400
                    forced_height = 24,
                    margins = 2
                }
            )
        end

        local week_number_header = wibox.widget{
            layout = wibox.layout.fixed.vertical,
            spacing = 0,
            forced_width = 22
        }

        local i = start_row
        local j = column_first_day + 1
        local current_week = nil
        local drawn_weekdays = 0
        for d=1, month_days do
            t = os.time{
                year = date.year,
                month = date.month,
                day = d
            }
            week_number = tonumber(os.date("%V", t))
            if week_number ~= current_week then
                week_number_header:add(
                    wibox.widget{
                        widget = wibox.container.margin,
                        {
                            widget = wibox.container.background,
                            create_textbox(week_number, beautiful.system_font .. 'bold 10'),
                            bg = beautiful.bg_primary_darkened,
                            fg = beautiful.fg_color,
                            shape = gears.shape.circle
                        },
                        forced_width = 22,
                        forced_height = 46,
                        margins = 2
                    }
                )
                current_week = week_number
            end

            local day = string.format("%02d", d)
            local focus = date.day == d
            local day_box_widget = wibox.widget{
                widget = wibox.container.background,
                create_textbox(day),
                shape = gears.shape.rectangle,
                bg = focus and beautiful.fg_color or beautiful.bg_primary_subtle,
                fg = focus and beautiful.bg_color or beautiful.fg_color,
                shape_border_width = beautiful.border_width_reduced,
                shape_border_color = focus and beautiful.border_focus or beautiful.border_normal,
                forced_height = 45,
                forced_width = 53,
                focus_day = focus
            }

            day_box_widget:connect_signal('mouse::enter', function()
                if not day_box_widget.focus_day then
                    day_box_widget.bg = '#ffffff44'
                    day_box_widget.shape_border_color = beautiful.border_focus
                end
            end)
            day_box_widget:connect_signal('mouse::leave', function()
                if not day_box_widget.focus_day then
                    day_box_widget.bg = beautiful.bg_color
                    day_box_widget.shape_border_color = beautiful.border_normal
                end
            end)

            calendar_month_days_widget:add_widget_at(
                day_box_widget,
                i,
                j,
                1,
                1
            )
            i, j = calendar_month_days_widget:get_next_empty(i, j)
        end

        local calendar_month_widget = wibox.widget{
            layout = wibox.layout.fixed.vertical,
            date_header,
            weekdays_header,
            {
                layout = wibox.layout.fixed.horizontal,
                week_number_header,
                calendar_month_days_widget,
            },
            forced_width = 400,
            forced_height = 350
        }

        return calendar_month_widget
    end

    local function show_calendar(offset)
        cur_offset = offset ~= 0 and cur_offset + offset or 0

        local raw_date = os.date("*t")
        local date = {
            year = raw_date.year,
            month = raw_date.month,
            day = raw_date.day
        }

        if cur_offset ~= 0 then
            local month_offset = (raw_date.month + cur_offset - 1) % 12 + 1
            local year_offset = raw_date.year + math.floor((raw_date.month + cur_offset - 1) / 12)
            date = {
                day = 0,
                month = month_offset,
                year = year_offset
            }
        end
        calendar_popup.widget = create_month(date)
    end

    popup_clicked_on = false

    date_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    if not calendar_popup.visible or popup_clicked_on then
                        calendar_popup.visible = not calendar_popup.visible
                    end
                    popup_clicked_on = calendar_popup.visible
                end
            ),
            awful.button(
                {},
                4,
                function()
                    show_calendar(-1)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    show_calendar(1)
                end
            )
        )
    )

    date_widget:connect_signal("mouse::enter", function()
        if not popup_clicked_on then
            show_calendar(0)
            calendar_popup.visible = true
        end
    end)
    date_widget:connect_signal("mouse::leave", function()
        if not popup_clicked_on then
            calendar_popup.visible = false
        end
    end)

    return date_widget
end

return Calendar

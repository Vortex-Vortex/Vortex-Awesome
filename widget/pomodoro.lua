local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')

local icons = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local function log(...)
    local timestamp = os.date("%Y/%m/%d - %H:%M:%S")
    local args = table.concat({...}, " ")
    gears.debug.dump(timestamp .. " " .. args)
end

local function Pomodoro_widget(s)
    local screen_width = s.geometry.width
    local work_time = 60 * 45
    local break_time = 60 * 7

    local function create_textbox(args)
        return wibox.widget{
            widget = wibox.widget.textbox,
            text = args.text,
            font = args.font or beautiful.system_font .. 'bold 11',
            align = 'center',
            valign = 'center'
        }
    end

    local status_text = create_textbox(
        {
            text = 'Start Pomodoro?'
        }
    )
    local clock_text = create_textbox(
        {
            text = '--:--',
            font = beautiful.system_font .. 'mono bold 14'
        }
    )

    local status_container = wibox.widget{
        widget = wibox.container.margin,
        {
            widget = wibox.container.background,
            status_text,
            shape = gears.shape.rectangle,
            shape_border_width = beautiful.border_width + 1,
            shape_border_color = beautiful.border_normal
        },
        margins = 5,
        forced_width = 140,
        forced_height = 35
    }
    local clock_container = wibox.widget{
        widget = wibox.container.margin,
        clock_text,
        left = 5,
        right = 5,
        bottom = 5
    }

    local popup = awful.popup{
        bg = beautiful.bg_color,
        ontop = true,
        visible = false,
        shape = gears.shape.rectangle,
        x = screen_width - 190,
        y = 50,
        maximum_width = 140,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
        widget = {}
    }

    popup:setup(
        {
            layout = wibox.layout.fixed.vertical,
            status_container,
            clock_container
        }
    )

    local pomodoro_counter = create_textbox(
        {
            text = '' .. math.floor(work_time / 60),
            font = beautiful.system_font .. 'bold 9'
        }
    )
    local pomodoro_arc = wibox.widget{
        widget = wibox.container.arcchart,
        pomodoro_counter,
        max_value = 1,
        value = 0.5,
        thickness = 4,
        start_angle = 1.5 * math.pi,
        forced_height = 29,
        forced_width = 29,
        rounded_edge = false,
        paddings = 0
    }

    local pomodoro_widget = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            pomodoro_arc,
            margins = 1
        },
        {
            shape = gears.shape.circle
        }
    )

    local is_on_break = false
    local is_on_pause = false
    local timer_value = -1
    local minutes = 0
    local seconds = 0

    local function format_time(counter_seconds)
        local reference = is_on_break and break_time or work_time
        local seconds_remaining = reference - counter_seconds
        local minutes = math.floor(seconds_remaining / 60)
        local seconds = seconds_remaining % 60
        return minutes, seconds
    end

    local function update_graphic(minutes, seconds, immediate_update)
        if timer_value == -1 then
            if popup.visible or immediate_update then
                status_text.text = 'Start Pomodoro?'
                clock_text.text = '--:--'
            end
            pomodoro_counter.text = '' .. math.floor(work_time / 60)
            pomodoro_arc.colors = {beautiful.border_focus}
            pomodoro_arc.value = 0.5
        else
            if popup.visible or immediate_update then
                clock_text.text = minutes .. ':' .. string.format('%02d', seconds)
            end
            pomodoro_counter.text = is_on_pause and pomodoro_counter.text or minutes
            pomodoro_arc.value = is_on_break and tonumber((break_time - timer_value) / break_time) or tonumber((work_time - timer_value) / work_time)
            pomodoro_arc.color = minutes < 5 and {'#ff0000'} or {beautiful.border_focus}
        end
    end

    local pomodoro_timer = gears.timer{
        timeout = 1,
        callback = function()
            timer_value = timer_value + 1
            minutes, seconds = format_time(timer_value)
            if minutes == 0 and seconds == 0 then
                if is_on_break then
                    naughty.notify{
                        text = 'Work Time',
                        title = 'Pomodoro timer',
                        icon = icons.alarm_clock,
                        icon_size = 128,
                        timeout = 0
                    }
                    is_on_break = false
                    pomodoro_arc.colors = {beautiful.border_focus}
                    status_text.text = 'Work!'
                else
                    naughty.notify{
                        text = 'Break Time',
                        title = 'Pomodoro timer',
                        icon = icons.alarm_clock,
                        icon_size = 128,
                        timeout = 0
                    }
                    is_on_break = true
                    pomodoro_arc.colors = {'#00ff00'}
                    status_text.text = 'Break!'
                end
                timer_value = 0
                minutes, seconds = format_time(0)
            end
            update_graphic(minutes, seconds)
        end
    }

    pomodoro_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    if is_on_pause then
                        is_on_pause = false
                    end
                    is_on_break = false
                    status_text.text = 'Work!'
                    clock_text.text = math.floor(work_time / 60) .. ':00'
                    pomodoro_arc.colors = {beautiful.border_focus}
                    timer_value = 0
                    if not pomodoro_timer.started then pomodoro_timer:start() end
                end
            ),
            awful.button(
                {},
                2,
                function()
                    if timer_value ~= -1 then
                        if is_on_pause then
                            if is_on_break then
                                status_text.text = 'Break!'
                                pomodoro_arc.colors = {'#00ff00'}
                            else
                                status_text.text = 'Work!'
                                pomodoro_arc.colors = {beautiful.border_focus}
                            end
                            if not pomodoro_timer.started then pomodoro_timer:start() end
                            is_on_pause = false
                        else
                            if is_on_break then
                                status_text.text = 'Break Paused!'
                                pomodoro_counter.text = 'PB'
                            else
                                status_text.text = 'Work Paused!'
                                pomodoro_counter.text = 'PW'
                            end
                            if pomodoro_timer.started then pomodoro_timer:stop() end
                            is_on_pause = true
                            pomodoro_arc.colors = {'#ffff00'}
                        end
                        update_graphic(format_time(timer_value))
                    end
                end
            ),
            awful.button(
                {},
                3,
                function()
                    if pomodoro_timer.started then pomodoro_timer:stop() end
                    timer_value = -1
                    update_graphic()
                end
            ),
            awful.button(
                {},
                4,
                function()
                    if timer_value == -1 then return end
                    if timer_value > 60 then
                        timer_value = timer_value - 60
                        update_graphic(format_time(timer_value))
                    end
                end
            ),
            awful.button(
                {'Shift'},
                4,
                function()
                    if timer_value == -1 then return end
                    if timer_value > 10 then
                        timer_value = timer_value - 10
                        update_graphic(format_time(timer_value))
                    end
                end
            ),
            awful.button(
                {},
                5,
                function()
                    if timer_value == -1 then return end
                    if is_on_break then
                        if timer_value < (break_time - 60) then
                            timer_value = timer_value + 60
                            update_graphic(format_time(timer_value))
                        end
                    elseif timer_value < (work_time - 60) then
                        timer_value = timer_value + 60
                        update_graphic(format_time(timer_value))
                    end
                end
            ),
            awful.button(
                {'Shift'},
                5,
                function()
                    if timer_value == -1 then return end
                    if is_on_break then
                        if timer_value < (break_time - 10) then
                            timer_value = timer_value + 10
                            update_graphic(format_time(timer_value))
                        end
                    elseif timer_value < (work_time - 10) then
                        timer_value = timer_value + 10
                        update_graphic(format_time(timer_value))
                    end
                end
            )
        )
    )

    pomodoro_widget:connect_signal("mouse::enter", function()
        update_graphic(minutes, seconds, true)
        popup.visible = true
    end)
    pomodoro_widget:connect_signal("mouse::leave", function()
        popup.visible = false
    end)

    return pomodoro_widget
end
return Pomodoro_widget

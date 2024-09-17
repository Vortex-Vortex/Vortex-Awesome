local awful               = require('awful')
local gears               = require('gears')
local beautiful           = require('beautiful')
local wibox               = require('wibox')
local icons               = require('theme.icons')
local naughty             = require('naughty')
local clickable_container = require('widget.material.clickable-container')

local function pomodoro_widget_call(s)
    local width = s.geometry.width
    local work_time = 60 * 45
    local break_time = 60 * 7

    local function create_textbox(args)
        return wibox.widget{
            widget        = wibox.widget.textbox,
            text          = args.text,
            font          = args.font or 'monospace bold 16',
            forced_height = args.forced_height or 40,
            forced_width  = args.forced_width or 130,
            align         = 'center',
            valign        = 'center'
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

    local status_text = create_textbox(
        {
            text = 'Start Pomodoro?',
            font = 'monospace bold 10',
            forced_height = 25
        }
    )
    local clock_text = create_textbox(
        {
            text = '--:--'
        }
    )

    local status_container = create_container(status_text)
    local clock_container = create_container(clock_text)

    local popup = awful.popup{
        bg           = beautiful.bg_normal,
        ontop        = true,
        visible      = false,
        shape        = gears.shape.rectangle,
        border_width = 2,
        border_color = beautiful.border_focus,
        x            = width - 180,
        y            = 50,
        widget       = {}
    }

    local popup_content = {
        status_container,
        clock_container,
        layout = wibox.layout.fixed.vertical
    }

    popup:setup(popup_content)

    local pomodoro_text = create_textbox(
        {
            text = '' .. math.floor( work_time / 60 ) .. '',
            font = 'monospace bold 10',
        }
    )

    local pomodoro_arc = wibox.widget{
        wibox.container.background(
            pomodoro_text
        ),
        max_value     = 1,
        value         = 0.5,
        thickness     = 4,
        start_angle   = 4.71238898,
        forced_height = 28,
        forced_width  = 28,
        rounded_edge  = false,
        bg            = '#ffffff11',
        paddings      = 0,
        widget        = wibox.container.arcchart
    }

    local pomodoro_widget = wibox.widget{
        {
            pomodoro_arc,
            widget = wibox.container.margin,
            margins = 2,
            border_width = 1,
            border_color = beautiful.border_focus
        },
        widget = clickable_container,
        shape = gears.shape.circle
    }

    local is_on_break = false
    local is_on_pause = false
    local timerValue = -1
    local remaining_time = '45:00'

    local function formatTime(counter_seconds)
        if is_on_break then
            total_reference = break_time
        else
            total_reference = work_time
        end
        seconds_remaining = total_reference - counter_seconds
        minutes = math.floor((seconds_remaining) / 60)
        seconds = seconds_remaining % 60
        return minutes, seconds
    end

    local function update_graphic(minutes, seconds)
        if timerValue == -1 then
            status_text.text = "Start Pomodoro?"
            pomodoro_text.text = '' .. math.floor(work_time / 60) .. ''
            pomodoro_arc.colors = {beautiful.border_focus}
            pomodoro_arc.value = 0.5
            clock_text.text = '--:--'
        else
            pomodoro_text.text = minutes
            clock_text.text = minutes .. ':' .. string.format("%02d", seconds)
            if is_on_break then
                pomodoro_arc.value = tonumber((break_time - timerValue)/break_time)
            else
                if minutes < 5 then
                    pomodoro_arc.colors = {'#ff0000'}
                else
                    pomodoro_arc.colors = {beautiful.border_focus}
                end
                pomodoro_arc.value = tonumber((work_time - timerValue)/work_time)
            end
        end
    end

    local pomodoro_timer = gears.timer{
        timeout = 1,
        callback = function()
            timerValue = timerValue + 1
            minutes, seconds = formatTime(timerValue)
            if minutes == 0 and seconds == 0 then
                if is_on_break then
                    naughty.notify{ text = "          Work Time          ", title = "          Pomodoro Timer          ", icon = icons.alarm_clock, icon_size = 128, timeout = 0 }
                    is_on_break = false
                    pomodoro_arc.colors = {beautiful.border_focus}
                    status_text.text = 'Work!'
                else
                    naughty.notify{ text = "          Break Time          ", title = "          Pomodoro Timer          ", icon = icons.alarm_clock, icon_size = 128, timeout = 0 }
                    is_on_break = true
                    pomodoro_arc.colors = {'#00ff00'}
                    status_text.text = 'Break!'
                end
                timerValue = 0
                minutes, seconds = formatTime(timerValue)
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
                    clock_text.text = math.floor( work_time / 60 ) .. ':00'
                    pomodoro_arc.colors = {beautiful.border_focus}
                    timerValue = 0
                    pomodoro_timer:start()
                end
            ),
            awful.button(
                {},
                2,
                function()
                    if timerValue ~= -1 then
                        if is_on_pause then
                            if is_on_break then
                                status_text.text = 'Break!'
                                pomodoro_arc.colors = {'#00ff00'}
                            else
                                status_text.text = 'Work!'
                                pomodoro_arc.colors = {beautiful.border_focus}
                            end
                            pomodoro_timer:start()
                            is_on_pause = false
                        else
                            if is_on_break then
                                status_text.text = 'Break Paused!'
                                pomodoro_text.text = 'PB'
                            else
                                status_text.text = 'Work Paused'
                                pomodoro_text.text = 'PW'
                            end
                            pomodoro_timer:stop()
                            is_on_pause = true
                            pomodoro_arc.colors = {'#ffff00'}
                        end
                        update_graphic(formatTime(timerValue))
                    end
                end
            ),
            awful.button(
                {},
                3,
                function()
                    pomodoro_timer:stop()
                    timerValue = -1
                    update_graphic()
                end
            ),
            awful.button(
                {},
                4,
                function()
                    if timerValue > 60 then
                        timerValue = timerValue - 60
                        minutes, seconds = formatTime(timerValue)
                        update_graphic(minutes, seconds)
                    end
                end
            ),
            awful.button(
                {},
                5,
                function()
                    if is_on_break then
                        if timerValue < (break_time - 60) then
                            timerValue = timerValue + 60
                            minutes, seconds = formatTime(timerValue)
                            update_graphic(minutes, seconds)
                        end
                    else
                        if timerValue < (work_time - 60) then
                            timerValue = timerValue + 60
                            minutes, seconds = formatTime(timerValue)
                            update_graphic(minutes, seconds)
                        end
                    end
                end
            )
        )
    )

    pomodoro_widget:connect_signal("mouse::enter", function()
        popup.visible = true
    end)
    pomodoro_widget:connect_signal("mouse::leave", function()
        popup.visible = false
    end)

    return pomodoro_widget
end
return pomodoro_widget_call

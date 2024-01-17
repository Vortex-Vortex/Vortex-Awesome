local awful               = require('awful')
local gears               = require('gears')
local beautiful           = require('beautiful')
local wibox               = require('wibox')
local clickable_container = require('widget.material.clickable-container')

local function pomodoro_widget_call(s)
    local width = s.geometry.width
    local work_time  = 45 * 60
    local break_time = 5 * 60

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
            text          = 'Start pomodoro?',
            font          = 'monospace bold 10',
            forced_height = 25
        }
    )
    local clock_text = create_textbox({ text = '--:--' })

    local status_container = create_container(status_text)
    local clock_container = create_container(clock_text)

    local popup_text = {
        status_container,
        clock_container,
        layout = wibox.layout.fixed.vertical
    }

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

    popup:setup(popup_text)

    local text = wibox.widget{
        font   = 'monospace bold 10',
        text   = '' .. math.floor( work_time / 60 ) .. '',
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }

    local pomodoroarc = wibox.widget{
        wibox.container.background(
            text
        ),
        max_value     = 1,
        value         = 0.5,
        thickness     = 3,
        start_angle   = 4.71238898,
        forced_height = 28,
        forced_width  = 28,
        rounded_edge  = true,
        bg            = "#ffffff11",
        paddings      = 0,
        widget        = wibox.container.arcchart
    }

    local pomodoro_widget = wibox.widget{
        {
            pomodoroarc,
            widget       = wibox.container.margin,
            margins      = 2,
            border_width = 1,
            border_color = beautiful.border_focus
        },
        widget = clickable_container,
        shape = gears.shape.circle
    }


    local function formatTime(seconds, workbreak)
        local seconds = workbreak - seconds
        local minutes = math.floor((seconds % 3600) / 60)
        local secs    = seconds % 60
        return string.format("%02d:%02d", minutes, secs)
    end

    local is_on_break = false
    local timerValue = 0
    local remaining_time = ' W' .. math.floor( work_time / 60 ) .. ':00'


    local update_graphic = function(widget, value)
        remaining_time = value or remaining_time
        local pomostatus = string.match(remaining_time, "(%D?%D?):%D?%D?")
        text.font = 'monospace bold 10'
        if pomostatus == "--" then
            text.text        = '' .. math.floor( work_time / 60 ) .. ''
            widget.colors    = beautiful.border_focus
            widget.value     = 0.5
            status_text.text = 'Start pomodoro?'
            clock_text.text  = '--:--'
        else
            local pomomin   = string.match(remaining_time, "[ P]?[BW](%d?%d?):%d?%d?")
            local pomosec   = string.match(remaining_time, "[ P]?[BW]%d?%d?:(%d?%d?)")
            local pomodoro  = pomomin * 60 + pomosec

            local status    = string.match(remaining_time, "([ P]?)[BW]%d?%d?:%d?%d?")
            local workbreak = string.match(remaining_time, "[ P]?([BW])%d?%d?:%d?%d?")

            text.text = pomomin
            clock_text.text = pomomin .. ':' .. pomosec

            if status == " " then
                if workbreak == "W" then
                    widget.value     = tonumber(pomodoro/(work_time))
                    status_text.text = '(W) Work!'
                    if tonumber(pomomin) < 5 then
                        widget.colors = {"#ff0000"}
                    else
                        widget.colors = {beautiful.border_focus}
                    end
                elseif workbreak == "B" then
                    status_text.text = '(B) Rest!'
                    widget.colors    = {"#00ff00"}
                    widget.value     = tonumber(pomodoro/(break_time))
                end
            elseif status == "P" then
                widget.colors = {"#ffff00"}
                clock_text.text = pomomin .. ':' .. pomosec
                if     workbreak == "W" then
                    status_text.text = '(PW) Work Paused'
                    widget.value     = tonumber(pomodoro/(work_time))
                    text.text        = "PW"
                elseif workbreak == "B" then
                    status_text.text = '(PB) Rest Paused'
                    widget.value     = tonumber(pomodoro/(break_time))
                    text.text        = "PB"
                end
            end
        end
    end

    local function call_update()
        update_graphic(pomodoroarc)
    end


    local pomodoro_timer = gears.timer{
        timeout = 1,
        callback = function()
            timerValue = timerValue + 1
            if not is_on_break then
                formatted_time = formatTime(timerValue, work_time)
                if formatted_time == "00:00" then
                    is_on_break = true
                    timerValue  = 0
                else
                    remaining_time = ' W' .. formatted_time
                end
            elseif is_on_break then
                formatted_time = formatTime(timerValue, break_time)
                if formatted_time == "00:00" then
                    is_on_break = false
                    timerValue  = 0
                else
                    remaining_time = ' B' .. formatted_time
                end
            end
        end
    }

    local timer = gears.timer{
        timeout = 1,
        callback = function()
            call_update()
        end
    }

    local is_paused = false

    pomodoro_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    if is_paused then
                        pomodoro_timer:stop()
                        timer:stop()
                        is_paused = false
                    end
                    is_on_break = false
                    status_text.text = '(W) Work!'
                    clock_text.text  = '' .. math.floor( work_time / 60 ) .. ':00'
                    timerValue       = 0
                    pomodoro_timer:start()
                    timer:start()
                end
            ),
            awful.button(
                {},
                2,
                function()
                    if status_text.text ~= 'Start pomodoro?' then
                        if is_paused then
                            if is_on_break then
                                status_text.text = '(B) Rest!'
                            else
                                status_text.text = '(W) Work!'
                            end
                            remaining_time = ' ' .. string.sub(remaining_time, 2)
                            pomodoro_timer:start()
                            is_paused = false
                        else
                            if is_on_break then
                                status_text.text = '(PB) Rest Paused'
                            else
                                status_text.text = '(PW) Work Paused'
                            end
                            remaining_time = 'P' .. string.sub(remaining_time, 2)
                            pomodoro_timer:stop()
                            is_paused = true
                        end
                    end
                end
            ),
            awful.button(
                {},
                3,
                function()
                    pomodoro_timer:stop()
                    timerValue = 0
                    timer:stop()
                    remaining_time    = ' W' .. math.floor( work_time / 60 ) .. ':00'
                    status_text.text  = 'Start pomodoro?'
                    clock_text.text   = '--:--'
                    text.text         = '' .. math.floor( work_time / 60 ) .. ''
                    pomodoroarc.value = 0.5
                end
            ),
            awful.button(
                {},
                4,
                function()
                    if status_text.text == '(W) Work!' then
                        if timerValue > 60 then
                            timerValue = timerValue - 60
                            operation = string.format("%02d", tonumber(string.match(remaining_time, " W(%d?%d?):%d?%d?")) + 1)
                            update_graphic(pomodoroarc, ' W' .. operation .. ':' .. string.match(remaining_time, " W%d?%d?:(%d?%d?)" ))
                        end
                    end
                end
            ),
            awful.button(
                {},
                5,
                function()
                    if status_text.text == '(W) Work!' then
                        if timerValue < (work_time - 60) then
                            timerValue = timerValue + 60
                            operation = string.format("%02d", tonumber(string.match(remaining_time, " W(%d?%d?):%d?%d?")) - 1)
                            update_graphic(pomodoroarc, ' W' .. operation .. ':' .. string.match(remaining_time, " W%d?%d?:(%d?%d?)" ))
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

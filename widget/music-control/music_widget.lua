local awful               = require('awful')
local gears               = require('gears')
local beautiful           = require('beautiful')
local wibox               = require('wibox')
local icons               = require('theme.icons')
local naughty             = require('naughty')
local clickable_container = require('widget.material.clickable-container')

local function music_widget_call(s)
    local width = s.geometry.width
    local rows = {
        layout = wibox.layout.fixed.vertical
    }
    local popup = awful.popup{
            ontop   = true,
            visible = false,
            shape   = gears.shape.rectangle,
            x       = width - 450,
            y       = 50,
            maximum_width = 400,
            border_width  = beautiful.border_width,
            border_color  = beautiful.border_focus,
            widget = {}
        }

    music_widget = clickable_container(wibox.widget{
        {
            wibox.widget{
                widget = wibox.widget.imagebox,
                image = icons.music
            },
            widget = wibox.container.place,
            align = 'center',
            valign = 'center'
        },
        widget        = wibox.container.margin,
        forced_height = 25,
        forced_width  = 25,
    })

    local first_row = wibox.widget{
        {
            {
                text  = 'Music Status',
                font  = 'Roboto Mono bold 12',
                align = 'center',
                forced_width  = 350,
                forced_height = 40,
                widget        = wibox.widget.textbox
            },
            {
                {
                    wibox.widget{
                        widget = wibox.widget.imagebox,
                        image = icons.music
                    },
                    widget = wibox.container.place,
                    align = 'center',
                    valign = 'center'
                },
                widget = wibox.container.margin,
                forced_height = 40,
                forced_width = 50,
                margins = 7
            },
            spacing = 8,
            layout  = wibox.layout.fixed.horizontal
        },
        bg = beautiful.bg_normal,
        shape              = gears.shape.rectangle,
        shape_border_color = beautiful.border_normal,
        shape_border_width = beautiful.border_width + 1,
        widget = wibox.container.background
    }

    local function formatDuration(seconds)
        local seconds = seconds or 0
        local minutes = math.floor(seconds / 60)
        local remainingSeconds = seconds % 60
        return string.format("%02d:%02d", minutes, remainingSeconds)
    end

    local function update_widget()
        for i = 0, #rows do
            rows[i] = nil
        end
        table.insert(rows, first_row)

        awful.spawn.easy_async_with_shell([[sleep 0.1; pragha -c | grep -E "state|file|length" | sed 's/^.\+:\s//;s/.*\///;s/\..*$//;s/^/|/;s/$/|/' | tr -d '\n']], function(stdout)
            local state, music, length = stdout:match("|(.+)||(.+)||(.+)|")
            if not music and not length then
                status_icon = icons.stopped
                status_info = "No Music Playing"
                music       = "--"
            elseif state == "Paused" then
                status_icon = icons.paused
                status_info = "Music Is Paused:"
            elseif state == "Playing" then
                status_icon = icons.playing
                status_info = "Music Is Playing"
            end
            local status_row = wibox.widget{
                {
                    {
                        {
                            {
                                wibox.widget{
                                    widget = wibox.widget.imagebox,
                                    image  = status_icon
                                },
                                widget = wibox.container.place,
                                align  = 'center',
                                valign = 'center'
                            },
                            widget        = wibox.container.margin,
                            forced_height = 40,
                            forced_width  = 80,
                            margins       = 7
                        },
                        shape              = gears.shape.rectangle,
                        shape_border_color = beautiful.border_normal,
                        shape_border_width = beautiful.border_width + 1,
                        widget = wibox.container.background
                    },
                    bg                 = beautiful.bg_normal,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_focus,
                    shape_border_width = beautiful.border_width -1,
                    widget             = wibox.container.background
                },
                {
                    {
                        text   = status_info,
                        align  = 'center',
                        widget = wibox.widget.textbox
                    },
                    widget = wibox.container.background,
                    bg     = beautiful.bg_primary_subtle,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_secondary,
                    shape_border_width = beautiful.border_width -1
                },
                spacing = 5,
                layout = wibox.layout.align.horizontal
            }
            table.insert(rows, status_row)

            local music_row = wibox.widget{
                {
                    {
                        {
                            text  = '  Music:  ',
                            font  = 'Roboto Mono bold 12',
                            align = 'center',
                            forced_height = 40,
                            forced_width  = 80,
                            widget        = wibox.widget.textbox
                        },
                        shape              = gears.shape.rectangle,
                        shape_border_color = beautiful.border_normal,
                        shape_border_width = beautiful.border_width + 1,
                        widget = wibox.container.background
                    },
                    bg                 = beautiful.bg_normal,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_focus,
                    shape_border_width = beautiful.border_width -1,
                    widget             = wibox.container.background
                },
                {
                    {
                        text = music,
                        align = 'center',
                        widget = wibox.widget.textbox
                    },
                    bg     = beautiful.bg_primary_subtle,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_secondary,
                    shape_border_width = beautiful.border_width -1,
                    widget = wibox.container.background
                },
                layout = wibox.layout.align.horizontal
            }
            table.insert(rows, music_row)

            local length_row = wibox.widget{
                {
                    {
                        {
                            text  = '  Length:  ',
                            font  = 'Roboto Mono bold 12',
                            align = 'center',
                            forced_height = 40,
                            forced_width  = 80,
                            widget        = wibox.widget.textbox
                        },
                        shape              = gears.shape.rectangle,
                        shape_border_color = beautiful.border_normal,
                        shape_border_width = beautiful.border_width + 1,
                        widget = wibox.container.background
                    },
                    bg                 = beautiful.bg_normal,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_focus,
                    shape_border_width = beautiful.border_width -1,
                    widget             = wibox.container.background
                },
                {
                    {
                        text = formatDuration(length),
                        align = 'center',
                        widget = wibox.widget.textbox
                    },
                    bg     = beautiful.bg_primary_subtle,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_secondary,
                    shape_border_width = beautiful.border_width -1,
                    widget = wibox.container.background
                },
                layout = wibox.layout.align.horizontal
            }
            table.insert(rows, length_row)

            popup:setup(rows)
        end)
    end

    music_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    awful.spawn.with_shell('pragha -r')
                    update_widget()
                end
            ),
            awful.button(
                {},
                2,
                function()
                    awful.spawn.with_shell('pragha -t')
                    update_widget()
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.spawn.with_shell('pragha -n')
                    update_widget()
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.spawn.with_shell('pragha -i')
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.spawn.with_shell('pragha -d')
                end
            )
        )
    )

    music_widget:connect_signal("mouse::enter", function()
        popup.visible = true
        update_widget()
    end)
    music_widget:connect_signal("mouse::leave", function()
        popup.visible = false
    end)


    return music_widget
end

return music_widget_call

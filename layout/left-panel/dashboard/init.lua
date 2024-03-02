local awful     = require('awful')
local wibox     = require('wibox')
local icons     = require('theme.icons')
local gears     = require('gears')
local beautiful = require('beautiful')

local dpi  = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')

return function(_, panel)
    local search_button = wibox.widget{
        {
            {
                {
                    {
                        widget = wibox.widget.imagebox,
                        image = icons.search
                    },
                    widget = wibox.container.margin,
                    top    = 10,
                    bottom = 10,
                    left   = 0,
                    right  = 10
                },
                {
                    widget = wibox.widget.textbox,
                    opacity = 0.75,
                    text    = 'Search Applications',
                    font    = 'Roboto medium 9'
                },
                layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.margin,
            left = 25,
            forced_height = 50
        },
        widget = clickable_container,
        shape              = gears.shape.rectangle,
        shape_border_width = beautiful.border_width - 1,
        shape_border_color = beautiful.border_focus
    }
    search_button:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    panel:run_rofi()
                end
            )
        )
    )

    local exit_button = wibox.widget{
        {
            {
                {
                    {
                        widget = wibox.widget.imagebox,
                        image = icons.logout
                    },
                    widget = wibox.container.margin,
                    top    = 10,
                    bottom = 10,
                    left   = 0,
                    right  = 10
                },
                {
                    widget = wibox.widget.textbox,
                    opacity = 0.75,
                    text    = 'End work session',
                    font    = 'Roboto medium 9',
                },
                layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.margin,
            left = 25,
            forced_height = 50
        },
        widget = clickable_container,
        shape              = gears.shape.rectangle,
        shape_border_width = beautiful.border_width - 1,
        shape_border_color = beautiful.border_focus
    }
    exit_button:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    panel:toggle()
                    _G.exit_screen_show()
                end
            )
        )
    )

    local Dashboard = wibox.widget{
        {
            search_button,
            require('layout.left-panel.dashboard.quick-settings'),
            require('layout.left-panel.dashboard.hardware-monitor'),
            layout = wibox.layout.fixed.vertical
        },
        nil,
        exit_button,
        layout = wibox.layout.align.vertical
    }

    return Dashboard
end

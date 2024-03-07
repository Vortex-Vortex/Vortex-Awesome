local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')

-- Widgets
local Tasklist = require('widget.task-list')
local TagList  = require('widget.tag-list')
local icons    = require('theme.icons')

local calendar_widget  = require('widget.calendar-widget.calendar')
local LayoutBox        = require('widget.layoutbox.layoutbox')
local todo_widget      = require("widget.todo-widget.todo")
local net_speed_widget = require("widget.net-speed-widget.net-speed")
local pomodoro_widget  = require('widget.pomodoro.pomodoro')
local music_widget     = require("widget.music-control.music_widget")
local left_button      = require("widget.material.left-button")
local add_button       = require('widget.material.add-button')
local menu_widget      = require('layout.left-panel')

local powerline_separator = wibox.widget{
    widget = wibox.widget.separator,
    orientation  = 'vertical',
    color        = '#ffffff',
    forced_width = 24,
    opacity      = 1,
    visible      = true,
    shape        = function(cr, width, height)
        local shape = gears.shape.powerline(cr, width, height, -16)
        return shape
    end
}

local systray_button = wibox.widget{
    left_button(),
    widget = wibox.container.margin,
    margins = dpi(4)
}

local systray = wibox.widget.systray()
    systray:set_horizontal(true)
    systray:set_base_size(20)
    systray.forced_height = 20

local systray_widget = wibox.widget{
    {
        powerline_separator,
        {
            systray,
            widget = wibox.container.margin,
            left = dpi(3),
            right = dpi(3),
            top = dpi(6),
            bottom = dpi(3)
        },
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.background,
    visible = true
}

systray_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            nil,
            function()
                systray_widget.visible = not systray_widget.visible
            end
        )
    )
)

local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 12">%H:%M:%S</span>', 1)

local TaskList = function(s)
    width = (s.geometry.width / 2) - 375
    return wibox.widget{
        Tasklist(s),
        widget = wibox.container.margin,
        forced_width = width,
        margins      = 1
    }
end

local add_button = add_button()
local add_button_widget = wibox.widget{
    add_button,
    widget = wibox.container.margin,
    margins = dpi(4)
}
add_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            nil,
            function()
                awful.spawn(
                    awful.screen.focused().selected_tag.defaultApp,
                    {
                        tag = _G.mouse.screen.selected_tag,
                        placement = awful.placement.bottom_right
                    }
                )
            end
        )
    )
)

local TopPanel = function(s)
    local panel = wibox(
        {
            ontop   = true,
            screen  = s,
            height  = 30,
            width   = s.geometry.width,
            x       = s.geometry.x,
            y       = s.geometry.y,
            stretch = false,
            bg      = beautiful.bg_normal,
            fg      = beautiful.fg_focus
        }
    )
    panel:struts(
        {
            top = 30
        }
    )

    panel:setup{
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                menu_widget(s),
                TagList(s),
                add_button_widget,
                TaskList(s)
            },
            nil,
            {
                layout = wibox.layout.fixed.horizontal,
                systray_widget,
                systray_button,
                powerline_separator,
                music_widget(s),
                powerline_separator,
                pomodoro_widget(s),
                powerline_separator,
                net_speed_widget,
                powerline_separator,
                todo_widget(s),
                powerline_separator,
                LayoutBox(s),
                powerline_separator,
                calendar_widget
            }
        },
        {
            layout = wibox.container.place,
            valign = 'center',
            halign = 'center',
            textclock
        }
    }
    return panel
end

return TopPanel

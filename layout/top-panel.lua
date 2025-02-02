local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears')
local wibox     = require('wibox')

awesome.register_xproperty("AWESOME", "string")

local left_panel = require('layout.left-panel')
local taglist = require('widget.tag-list')
local tasklist = require('widget.task-list')
local clock = require('widget.clock')
local systray_widget = require('widget.systray-widget')
local crypto_widget = require('widget.crypto-screener')
local volume_widget = require('widget.volume-widget')
local music_widget = require('widget.music-widget')
local pomodoro_widget = require('widget.pomodoro')
local net_speed_widget = require('widget.net-speed')
local layout_widget = require('widget.layout-widget')
local todo_widget = require('widget.todo-widget')
local calendar_widget = require('widget.calendar')
local notification_center = require('widget.notification-center')

local crypto_screener = require('widget.crypto-screener')

local function TopPanel(s)
    local Panel = wibox(
        {
            ontop = true,
            visible = true,
            screen = s,
            height = beautiful.top_panel_height,
            width = s.geometry.width,
            x = s.geometry.x,
            y = s.geometry.y,
            stretch = false
        }
    )

    Panel:struts(
        {
            top = beautiful.top_panel_height
        }
    )

    Panel:setup{
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                left_panel(s),
                taglist(s),
                tasklist(s)
            },
            nil,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 3,
                spacing_widget = wibox.widget{
                    widget = wibox.widget.separator,
                    orientation = 'vertical',
                    thickness = 3,
                    color = beautiful.bg_neutral
                },
                nil,
                systray_widget(s),
                crypto_widget(s),
                volume_widget(s),
                music_widget(s),
                pomodoro_widget(s),
                net_speed_widget(),
                layout_widget(s),
                todo_widget(s),
                calendar_widget(s),
                notification_center(s)
            }
        },
        clock
    }
    Panel:set_xproperty("AWESOME", "TopPanel")

    return Panel
end

return TopPanel

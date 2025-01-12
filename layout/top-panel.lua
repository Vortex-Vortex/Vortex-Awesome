local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears')
local wibox     = require('wibox')

awesome.register_xproperty("AWESOME", "string")

local taglist = require('widget.tag-list')
local tasklist = require('widget.task-list')
local clock = require('widget.clock')
local net_speed_widget = require('widget.net-speed')
local calendar_widget = require('widget.calendar')
local notification_center = require('widget.notification-center')

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
--             y = s.geometry.height - beautiful.top_panel_height,
            stretch = false
        }
    )

    Panel:struts(
        {
            top = beautiful.top_panel_height
--             bottom = beautiful.top_panel_height
        }
    )

    Panel:setup{
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
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
                net_speed_widget(),
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

local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears')
local naughty   = require('naughty')
local wibox     = require('wibox')

local icons     = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local function Notification_center(s)
    local screen_width = s.geometry.width
    local notification_queue = {}
    local current_callback = nil
    local update_queue = false
    local notif_counter = 0

    local count_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = 0
    }

    local notification_center_button = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    {
                        widget = wibox.container.place,
                        {
                            widget = wibox.widget.imagebox,
                            image = icons.notification_icon
                        },
                        align = 'center',
                        valign = 'center'
                    },
                    forced_height = 25,
                    forced_width = 25
                },
                count_textbox
            },
            left = 5,
            right = 5
        }
    )

    return notification_center_button
end

return Notification_center

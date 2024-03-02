local wibox     = require('wibox')
local icons     = require('theme.icons')
local gears     = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')

local function create_up_button()
    local up_button = wibox.widget{
        {
            widget        = wibox.widget.imagebox,
            image         = icons.half_arrow_up
        },
        widget = clickable_container(
            nil,
            {
                enter = beautiful.border_semi,
                leave = '#00000000'
            }
        ),
        shape = gears.shape.circle
    }

    return up_button
end
return create_up_button

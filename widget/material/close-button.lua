local wibox     = require('wibox')
local icons     = require('theme.icons')
local gears     = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')

local function create_close_button()
    local close_button = wibox.widget{
        {
            widget        = wibox.widget.imagebox,
            image         = icons.close
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

    return close_button
end
return create_close_button

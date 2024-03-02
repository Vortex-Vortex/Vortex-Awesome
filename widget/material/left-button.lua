local wibox     = require('wibox')
local icons     = require('theme.icons')
local gears     = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')

local function create_left_button()
    local left_button = wibox.widget{
        {
            widget        = wibox.widget.imagebox,
            image         = icons.half_arrow_left
        },
        widget = clickable_container,
        shape = gears.shape.circle
    }

    return left_button
end
return create_left_button

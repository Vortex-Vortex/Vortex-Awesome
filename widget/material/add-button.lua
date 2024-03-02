local wibox = require('wibox')
local icons = require('theme.icons')
local gears = require('gears')

local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')

local function create_add_button()
    local add_button = wibox.widget{
        {
            widget        = wibox.widget.imagebox,
            image         = icons.plus
        },
        widget = clickable_container,
        shape = gears.shape.circle
    }

    return add_button
end

return create_add_button

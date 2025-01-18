local gears = require('gears')
local wibox = require('wibox')

local icons = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local function create_button(icon)
    local button = clickable_container(
        {
            widget = wibox.widget.imagebox,
            id = 'image_id',
            image = icons[icon]
        },
        {
            shape = gears.shape.circle
        }
    )
    return button
end
return create_button

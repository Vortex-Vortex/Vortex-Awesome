local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

local icons = require('theme.icons')
local button_widget = require('widget.material.button-widget')
local clickable_container = require('widget.material.clickable-container')

local function Systray_widget(s)
    local screen_width = s.geometry.width

    local popup = awful.popup{
        ontop   = true,
        visible = false,
        shape   = gears.shape.rectangle,
        x       = screen_width - 85,
        y       = 50,
        maximum_width = 30,
        border_width  = beautiful.border_width,
        border_color  = beautiful.border_focus,
        widget = {}
    }

    local systray = {
        widget = wibox.container.margin,
        {
            widget = wibox.widget.systray,
            horizontal = false,
            base_size = 26,
            forced_width = 26,
            screen = s
        },
        forced_height = 180,
        margins = 2
    }

    popup:setup(systray)

    local systray_widget_button = button_widget('half_arrow_down')
    systray_widget_button:buttons(
        awful.button(
            {},
            1,
            nil,
            function()
                popup.visible = not popup.visible
                systray_widget_button.image_id.image = popup.visible and icons.half_arrow_up or icons.half_arrow_down
            end
        )
    )

    local systray_widget = wibox.widget{
        widget = wibox.container.margin,
        systray_widget_button,
        margins = 4
    }

    return systray_widget
end
return Systray_widget

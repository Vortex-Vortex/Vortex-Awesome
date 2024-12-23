local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local modkey = require('configuration.keys.mod').modkey

local taglist_buttons = gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    )
)

local widget_template = {
    widget = wibox.container.background,
    {
        widget = wibox.container.margin,
        {
            widget = wibox.widget.imagebox,
            id = 'icon_role'
        },
        margins = 6
    },
    id = 'background_role'
}

local function Taglist(s)
    return awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = widget_template
    }
end

return Taglist

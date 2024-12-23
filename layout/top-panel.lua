local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears')
local wibox     = require('wibox')

awesome.register_xproperty("AWESOME", "string")

local function TopPanel(s)
    local Panel = wibox(
        {
            ontop = true,
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

--     Panel:setup{
--
--     }
    Panel:set_xproperty("AWESOME", "TopPanel")

    return Panel
end

return TopPanel
local awful               = require('awful')
local gears               = require('gears')
local beautiful           = require('beautiful')
local wibox               = require('wibox')
local icons               = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')


-- local popup = awful.popup{
--     ontop        = true,
--     visible      = false,
--     shape        = gears.shape.rectangle,
--     width        = 400,
--     border_width = beatiful.border_width,
--     border_color = beutiful.border_focus,
--     widget       = {}
-- }
-- awful.placement.top(popup, { margins = {top = 40}})


music_widget = clickable_container(wibox.widget{
    {
        wibox.widget{
            widget = wibox.widget.imagebox,
            image = icons.music
        },
        widget = wibox.container.place,
        align = 'center',
        valign = 'center'
    },
    widget        = wibox.container.margin,
    forced_height = 25,
    forced_width  = 25,
})

music_widget:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                awful.spawn.with_shell('pragha -r')
            end
        ),
        awful.button(
            {},
            2,
            function()
                awful.spawn.with_shell('pragha -t')
            end
        ),
        awful.button(
            {},
            3,
            function()
                awful.spawn.with_shell('pragha -n')
            end
        ),
        awful.button(
            {},
            4,
            function()
                awful.spawn.with_shell('pragha -i')
            end
        ),
        awful.button(
            {},
            5,
            function()
                awful.spawn.with_shell('pragha -d')
            end
        )
    )
)

return music_widget

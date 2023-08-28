local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local modkey = require('configuration.keys.mod').modkey

local clickable_container = require('widget.material.clickable-container')

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/.config/awesome/theme/icons/layouts/'


local popup = awful.popup{
    ontop   = true,
    visible = false,
    shape   = gears.shape.rectangle,
    x       = 1740,
    y       = 50,
    border_width = dpi(2),
    border_color = beautiful.border_focus,
    widget = {}
}

local menu_items = {
    {
        name = 'Max',
        icon_name = 'arrow-expand-all.png',
        command = function()
            awful.layout.set(awful.layout.suit.max)
        end
    },
    {
        name = 'Tile',
        icon_name = 'view-quilt.png',
        command = function()
            awful.layout.set(awful.layout.suit.tile)
        end
    },
    {
        name = 'Floating',
        icon_name = 'floating.png',
        command = function()
            awful.layout.set(awful.layout.suit.floating)
        end
    },
    {
        name = 'Fair-V',
        icon_name = 'fair-v.png',
        command = function()
            awful.layout.set(awful.layout.suit.fair)
        end
    },
    {
        name = 'Fair-H',
        icon_name = 'fair-h.png',
        command = function()
            awful.layout.set(awful.layout.suit.fair.horizontal)
        end
    }
}

local rows = {
    layout = wibox.layout.fixed.vertical
}

for _, item in ipairs(menu_items) do
    local row = clickable_container(wibox.widget{
        {
            {
                {
                    widget        = wibox.widget.imagebox,
                    image         = ICON_DIR .. item.icon_name,
                    resize        = true,
                    forced_height = 60,
                    forced_width  = 60
                },
                {
                    widget = wibox.widget.textbox,
                    text   = item.name,
                    font   = font
                },
                layout  = wibox.layout.fixed.horizontal,
                spacing = 4
            },
            layout = wibox.container.margin,
            forced_width = 130,
            right  = 6
        },
        widget = wibox.container.background,
        shape  = gears.shape.rectangle,
        shape_border_width = beautiful.border_width + 1,
        shape_border_color = beautiful.border_normal
    })

    row:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    popup.visible = not popup.visible
                    item.command()
                end
            )
        )
    )
    table.insert(rows, row)
end
popup:setup(rows)


local LayoutBox = function(s)
    local layoutBox = clickable_container(awful.widget.layoutbox(s))
    layoutBox:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                2,
                function()
                    popup.visible = not popup.visible
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.layout.inc(-1)
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.layout.inc(-1)
                end
            )
        )
    )
    return layoutBox
end
return LayoutBox

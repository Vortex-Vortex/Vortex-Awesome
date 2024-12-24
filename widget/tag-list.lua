local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local modkey = require('configuration.keys.mod').modkey
local clickable_container = require('widget.material.clickable-container')

local taglist_buttons = gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    )
)

local function list_update(w, buttons, label, _, objects)
    w:reset()
    for _, tag_object in ipairs(objects) do
        local image_box = wibox.widget{
            widget = wibox.widget.imagebox
        }
        local constrained_image_box = wibox.widget{
            widget = wibox.container.margin,
            image_box,
            margins = 6
        }

        local background_box = wibox.widget{
            widget = wibox.container.background,
            constrained_image_box
        }


        local btns = {}
        for _, b in ipairs(buttons) do
            local button = _G.button{
                modifiers = b.modifiers,
                button = b.button
            }
            button:connect_signal(
                'press',
                function()
                b:emit_signal('press', tag_object)
                end
            )
            button:connect_signal(
                'release',
                function()
                b:emit_signal('release', tag_object)
                end
            )
            btns[#btns + 1] = button
        end
        background_box:buttons(btns)

        local text, bg, bg_image, icon = label(tag_object)

        background_box.bg = bg
        image_box.image = icon

        w:add(background_box)
    end
end

local function Taglist(s)
    return awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {},
        update_function = list_update
    }
end

return Taglist

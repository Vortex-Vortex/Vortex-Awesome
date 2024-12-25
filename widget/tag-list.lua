local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local modkey = require('configuration.keys.mod').modkey
local button_widget = require('widget.material.button-widget')
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

local function list_update(w, buttons, label, data, objects)
    w:reset()
    for _, tag_object in ipairs(objects) do
        local cache = data[tag_object]
        local image_box, background_box, constrained_image_box

        if cache then
            image_box = cache.image_box
            background_box = cache.background_box
            constrained_image_box = cache.constrained_image_box
        else
            image_box = wibox.widget{
                widget = wibox.widget.imagebox
            }
            constrained_image_box = wibox.widget{
                widget = wibox.container.margin,
                image_box,
                margins = 6
            }

            local clickable_image = clickable_container(constrained_image_box)

            background_box = wibox.widget{
                widget = wibox.container.background,
                clickable_image
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

            data[tag_object] = {
                image_box = image_box,
                background_box = background_box,
                constrained_image_box = constrained_image_box
            }
        end
        local text, bg, bg_image, icon = label(tag_object)

        background_box.bg = bg
        image_box.image = icon

        w:add(background_box)
    end
end


local function Taglist(s)
    taglist = awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {},
        update_function = list_update
    }

    app_loader = button_widget('plus_icon')
    app_loader:buttons(
        awful.button(
            {},
            1,
            nil,
            function()
                awful.spawn(
                    awful.screen.focused().selected_tag.default_app
                )
            end
        )
    )

    app_loader_widget = wibox.widget{
        widget = wibox.container.margin,
        app_loader,
        margins = 4
    }

    taglist_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        taglist,
        app_loader_widget
    }

    return taglist_widget
end

return Taglist

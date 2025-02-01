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
            change_tag(
                function()
                    t:view_only()
                end
            )
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            change_tag(
                function()
                    _G.client.focus:move_to_tag(t)
                    t:view_only()
                end
            )
        end
    ),
    awful.button(
        {},
        3,
        function(t)
            change_tag(
                function()
                    awful.tag.viewtoggle(t)
                end
            )
        end
    ),
    awful.button(
        {modkey},
        3,
        function(t)
            if _G.client.focus then
                _G.client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            change_tag(
                function()
                    awful.tag.viewprev(t.screen)
                end
            )
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            change_tag(
                function()
                    awful.tag.viewnext(t.screen)
                end
            )
        end
    )
)

local function list_update(w, buttons, label, data, objects)
    w:reset()
    for _, tag_object in ipairs(objects) do
        local cache = data[tag_object]

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

gears.timer.delayed_call(
    function()
        for _, c in ipairs(client.get()) do
            c.minimized = c.skip_taskbar and c.minimized or false
        end
    end
)

function change_tag(action)
    local prev_tags = awful.screen.focused().selected_tags
    action()
    local cur_tags = awful.screen.focused().selected_tags

    if #prev_tags == 1 and #cur_tags == 1 and prev_tags[1] == cur_tags[1] then
        return
    else
        for _, tag in ipairs(cur_tags) do
            for _, client in ipairs(tag:clients()) do
                if client.marked and not client.skip_taskbar then
                    client.minimized = false
                end
                client.marked = false
            end
        end
        local cur_clients = cur_tags[1]:clients()
        for _, tag in ipairs(prev_tags) do
            if not gears.table.hasitem(cur_tags, tag) then
                for _, client in ipairs(tag:clients()) do
                    if not client.skip_taskbar and not gears.table.hasitem(cur_clients, client) then
                        client.marked = not client.minimized
                        client.minimized = true
                    end
                end
            end
        end
    end
end

local function Taglist(s)
    local taglist = awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {},
        update_function = list_update
    }

    local app_loader = button_widget('plus_icon')
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

    local app_loader_widget = wibox.widget{
        widget = wibox.container.margin,
        app_loader,
        margins = 4
    }

    local taglist_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        taglist,
        app_loader_widget
    }

    return taglist_widget
end

return Taglist

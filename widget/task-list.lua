local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local button_widget = require('widget.material.button-widget')
local clickable_container = require('widget.material.clickable-container')

local target_client
local properties_menu = {
    {
        'Toggle Floating',
        function()
            if target_client then
                target_client.floating = not target_client.floating
            end
        end
    },
    {
        'Toggle Ontop',
        function()
            if target_client then
                target_client.ontop = not target_client.ontop
            end
        end
    },
    {
        'Toggle Sticky',
        function()
            if target_client then
                target_client.sticky = not target_client.sticky
            end
        end
    },
    {
        'Change Opacity',
        {
            {
                '25%',
                function()
                    if target_client then
                        target_client.opacity = 0.25
                    end
                end
            },
            {
                '50%',
                function()
                    if target_client then
                        target_client.opacity = 0.5
                    end
                end
            },
            {
                '75%',
                function()
                    if target_client then
                        target_client.opacity = 0.75
                    end
                end
            },
            {
                '100%',
                function()
                    if target_client then
                        target_client.opacity = 1.0
                    end
                end
            }
        }
    },
    {
        'Close Client',
        function()
            if target_client then
                target_client:kill()
            end
        end
    },
    {
        'Kill Client',
        function()
            if target_client then
                target_client:kill(9)
            end
        end
    }
}
local tasklist_menu = awful.menu.new(properties_menu)

local tasklist_buttons = gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == _G.client.focus then
                c.minimized = true
            else
                c.minimized = false
            end
            _G.client.focus = c
            c:raise()
        end
    ),
    awful.button(
        {},
        2,
        function(c)
            c:kill()
        end
    ),
    awful.button(
        {},
        3,
        function(c)
            _G.client.focus = c
            c:raise()
            target_client = c
            tasklist_menu:update()
            tasklist_menu:toggle()
        end
    ),
    awful.button(
        {},
        4,
        function()
            awful.client.focus.byidx(-1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        8,
        function()
            awful.client.focus.history.previous()
        end
    )
)

local function list_update(w, buttons, label, data, objects)
    w:reset()
    for _, client_object in ipairs(objects) do
        local cache = data[client_object]
        local image_box, text_box, background_box, constrained_image_box, constrained_text_box

        if cache then
            image_box = cache.image_box
            text_box = cache.text_box
            background_box = cache.background_box
            constrained_text_box = cache.constrained_text_box
            constrained_image_box = cache.constrained_image_box
            tooltip = cache.tooltip
        else
            image_box = wibox.widget{
                widget = wibox.widget.imagebox
            }
            constrained_image_box = wibox.widget{
                widget = wibox.container.margin,
                image_box,
                margins = 6
            }

            text_box = wibox.widget{
                widget = wibox.widget.textbox
            }

            tag_info = wibox.widget{
                layout = wibox.layout.align.horizontal,
                constrained_image_box,
                text_box
            }

            close_button = button_widget('x_icon')
            close_button:buttons(
                awful.button(
                    {},
                    1,
                    nil,
                    function()
                        client_object.kill(client_object)
                    end
                )
            )
            constrained_close_button = wibox.widget{
                widget = wibox.container.margin,
                close_button,
                margins = 5
            }

            clickable_image = clickable_container(
                {
                    widget = wibox.container.margin,
                    {
                        layout = wibox.layout.align.horizontal,
                        nil,
                        tag_info,
                        constrained_close_button
                    },
                    left = 15,
                    right = 10
                },
                {
                    shape = gears.shape.powerline
                }
            )

            background_box = wibox.widget{
                widget = wibox.container.background,
                clickable_image,
                shape = gears.shape.powerline
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
                        b:emit_signal('press', client_object)
                    end
                )
                button:connect_signal(
                    'release',
                    function()
                        b:emit_signal('release', client_object)
                    end
                )
                btns[#btns + 1] = button
            end
            tag_info:buttons(btns)

            tooltip = awful.tooltip{
                objects = { text_box },
                mode = 'outside',
                align = 'bottom',
                delay_show = 1
            }

            data[client_object] = {
                image_box = image_box,
                text_box = text_box,
                background_box = background_box,
                constrained_text_box = constrained_text_box,
                constrained_image_box = constrained_image_box,
                tooltip = tooltip
            }
        end
        local text, bg, bg_image, icon, args = label(client_object)

        local text_only = text:match('>(.-)<')

        background_box.bg = bg
        image_box.image = icon
        text_box.markup = text
        tooltip.text = text_only

        background_box.shape = args.shape
        background_box.shape_border_width = args.shape_border_width
        background_box.shape_border_color = args.shape_border_color

        w:add(background_box)
    end
end

local function Tasklist(s)
    local tasklist = awful.widget.tasklist{
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {},
        update_function = list_update
    }

    local width = (s.geometry.width / 2) - 45 - 330

    local tasklist_widget = wibox.widget{
        widget = wibox.container.margin,
        tasklist,
        forced_width = width
    }

    return tasklist_widget
end

return Tasklist

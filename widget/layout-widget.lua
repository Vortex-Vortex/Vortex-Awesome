local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

local clickable_container = require('widget.material.clickable-container')

local function Layout_widget(s)
    local screen_width = s.geometry.width

    local popup = awful.popup{
        bg = beautiful.bg_color,
        ontop = true,
        visible = false,
        shape = gears.shape.rectangle,
        x = screen_width - 190,
        y = 50,
        maximum_width = 140,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
        widget = {}
    }

    local layout_widget = clickable_container(
        {
            widget = wibox.container.margin,
            awful.widget.layoutbox(s),
            margins = 4
        }
    )

    local layout_list_base_layout = wibox.widget{
        layout = wibox.layout.flex.vertical,
        spacing = 3
    }

    local layout_list_widget_template = {
        widget = wibox.container.background,
        {
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                {
                    widget = wibox.widget.imagebox,
                    id = 'icon_role',
                    forced_width = 42
                },
                margins = 4
            },
            {
                widget = wibox.widget.textbox,
                id = 'text_role',
                align = 'center',
                forced_width = 90
            }
        },
        id = 'background_role',
        forced_height = 50,
        create_callback = function(self)
            self:connect_signal('mouse::enter', function()
                old_bg = self.bg
                self.bg = beautiful.bg_primary
            end)
            self:connect_signal('mouse::leave', function()
                self.bg = old_bg
            end)
        end
    }

    local layout_list_widget = awful.widget.layoutlist{
        screen = s,
        base_layout = layout_list_base_layout,
        widget_template = layout_list_widget_template
    }

    popup.widget = layout_list_widget

    function toggle_layout_list()
        layout_widget_keygrabber:start()
    end

    layout_widget_keygrabber = awful.keygrabber{
        export_keybindings = false,
        stop_event = 'release',
        stop_key = {'Escape', 'q', '1', '2', '3', '4', '5'},
        start_callback = function() popup.visible = true end,
        stop_callback = function() popup.visible = false end,
        keybindings = {
            {
                {},
                '1',
                function()
                    awful.layout.set(awful.layout.suit.tile)
                end
            },
            {
                {},
                '2',
                function()
                    awful.layout.set(awful.layout.suit.max)
                end
            },
            {
                {},
                '3',
                function()
                    awful.layout.set(awful.layout.suit.fair)
                end
            },
            {
                {},
                '4',
                function()
                    awful.layout.set(awful.layout.suit.fair.horizontal)
                end
            },
            {
                {},
                '5',
                function()
                    awful.layout.set(awful.layout.suit.floating)
                end
            }
        }
    }

    local popup_clicked_on = false

    layout_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    if not popup.visible or popup_clicked_on then
                        popup.visible = not popup.visible
                    end
                    popup_clicked_on = popup.visible
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.layout.inc(-1)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.layout.inc(1)
                end
            )
        )
    )

    layout_widget:connect_signal("mouse::enter", function()
        if not popup_clicked_on then
            popup.visible = true
        end
    end)
    layout_widget:connect_signal("mouse::leave", function()
        if not popup_clicked_on then
            popup.visible = false
        end
    end)

    return layout_widget
end
return Layout_widget

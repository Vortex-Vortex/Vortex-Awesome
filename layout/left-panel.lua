local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')

awesome.register_xproperty("AWESOME", "string")

local apps = require('configuration.apps')
local icons = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local ram_widget, ram_timer = require('widget.panel-widgets.ram')()
local storage_widget, storage_timer = require('widget.panel-widgets.storage')()
local b_battery_widget, b_battery_timer = require('widget.panel-widgets.bluetooth-battery')()
local cpu_panel, cpu_timer = require('widget.panel-widgets.cpu')()

local function Left_panel(s)
    local screen_width = s.geometry.width
    local screen_height = s.geometry.height
    local home_menu_hover = false

    local panel = wibox(
        {
            ontop = true,
            visible = false,
            screen = s,
            height = screen_height - 30 - (2 * beautiful.border_width),
            width = screen_width / 4,
            x = s.geometry.x,
            y = s.geometry.y + 30,
            stretch = false,
            bg = beautiful.bg_color,
            shape = gears.shape.rectangle,
            border_width = beautiful.border_width,
            border_color = beautiful.border_focus
        }
    )

    local backdrop = wibox(
        {
            ontop = true,
            visible = false,
            screen = s,
            height = screen_height - 30,
            width = screen_width,
            x = s.geometry.x,
            y = s.geometry.y + 30,
            bg = beautiful.bg_color .. '77',
            type = 'dock'
        }
    )
    backdrop:connect_signal(
        'button::press',
        function()
            panel.visible = false
            backdrop.visible = false
            ram_timer:stop()
            storage_timer:stop()
            b_battery_timer:stop()
            cpu_timer:stop()
        end
    )

    local menu_widget = clickable_container(
        {
            widget = wibox.container.margin,
            id = 'container_margin_id',
            {
                widget = wibox.widget.imagebox,
                id = 'image_id',
                image = icons.menu_icon
            },
            margins = 4
        },
        {
            enter = beautiful.border_focus .. '99',
            leave = beautiful.border_focus .. '55',
            click = beautiful.border_focus .. 'cc'
        }
    )

    menu_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                nil,
                function()
                    backdrop.visible = not panel.visible
                    panel.visible = not panel.visible
                    if ram_timer.started then
                        ram_timer:stop()
                        storage_timer:stop()
                        b_battery_timer:stop()
                        cpu_timer:stop()
                    else
                        ram_timer:start()
                        storage_timer:start()
                        b_battery_timer:start()
                        cpu_timer:start()
                    end
                end
            ),
            awful.button(
                {},
                2,
                nil,
                function()
                    home_menu_hover = not home_menu_hover
                end
            ),
            awful.button(
                {},
                3,
                function()
                    _G.change_tag(
                        function()
                            awful.tag.history.restore()
                        end
                    )
                end
            ),
            awful.button(
                {},
                4,
                function()
                    change_tag(
                        function()
                            awful.tag.viewprev()
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
                            awful.tag.viewnext()
                        end
                    )
                end
            )
        )
    )
    menu_widget:connect_signal(
        'mouse::leave',
        function()
            if home_menu_hover then
                _G.change_tag(
                    function()
                        awful.tag.history.restore()
                    end
                )
            end
        end
    )

    local function run_rofi()
        _G.awesome.spawn(
            apps.default.rofi,
            false,
            false,
            false,
            false,
            function()
                panel.visible = false
                backdrop.visible = false
                ram_timer:stop()
                storage_timer:stop()
                b_battery_timer:stop()
                cpu_timer:stop()
            end
        )
    end

    local search_button = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.widget.imagebox,
                    image = icons.search_icon
                },
                {
                    widget = wibox.widget.textbox,
                    text = 'Search Applications',
                    font = beautiful.system_font .. '9',
                    opacity = 0.75,
                    align = 'center',
                    valign = 'center'
                }
            },
            margins = 10,
            forced_height = 50
        },
        {
            border_width = beautiful.border_width_reduced,
            border_color = beautiful.border_focus
        }
    )
    search_button:buttons(
        awful.button(
            {},
            1,
            run_rofi
        )
    )

    local exit_button = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.widget.imagebox,
                    image = icons.search_icon
                },
                {
                    widget = wibox.widget.textbox,
                    text = 'End Work Session',
                    font = beautiful.system_font .. '9',
                    opacity = 0.75,
                    align = 'center',
                    valign = 'center'
                }
            },
            margins = 10,
            forced_height = 50
        },
        {
            border_width = beautiful.border_width_reduced,
            border_color = beautiful.border_focus
        }
    )
    exit_button:buttons(
        awful.button(
            {},
            1,
            function()
                _G.show_exit_screen()
            end
        )
    )

    panel:setup(
        {
            layout = wibox.layout.align.vertical,
            search_button,
            {
                widget = wibox.container.margin,
                {
                    layout = wibox.layout.fixed.vertical,
                    {
                        widget = wibox.widget.textbox,
                        text = 'System Monitor',
                        font = beautiful.system_font .. '10',
                        align = 'center',
                        valign = 'center',
                        forced_height = 40
                    },
                    ram_widget,
                    storage_widget,
                    b_battery_widget,
                    {
                        widget = wibox.widget.textbox,
                        text = 'CPU Monitor',
                        font = beautiful.system_font .. '10',
                        align = 'center',
                        valign = 'center',
                        forced_height = 40
                    },
                    cpu_panel
                },
                left = 25,
                right = 25
            },
            exit_button
        }
    )

    panel:set_xproperty("AWESOME", "LeftPanel")

    return menu_widget
end
return Left_panel

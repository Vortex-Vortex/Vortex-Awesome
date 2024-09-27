local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local icons     = require('theme.icons')
local beautiful = require('beautiful')

local dpi  = require('beautiful').xresources.apply_dpi
local apps = require('configuration.apps')

local clickable_container = require('widget.material.clickable-container')

left_panel = function(screen)
    local home_menu = wibox.widget{
        {
            {
                widget = wibox.widget.imagebox,
                image = icons.menu
            },
            widget = wibox.container.margin,
            margins = 4
        },
        widget = clickable_container(nil,{
            enter = beautiful.border_focus .. '99',
            leave = beautiful.border_focus .. '55',
            click = beautiful.border_focus .. 'cc',
        }),
        bg = beautiful.border_focus .. '55'
    }
    local home_menu_hover = false

    local void = wibox.widget {
        widget = wibox.container.background,
        forced_width = 0
    }

    local menu_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
        void,
        home_menu
    }

    local backdrop = wibox{
        ontop  = true,
        screen = screen,
        bg     = '#00000077',
        type   = 'dock',
        x      = screen.geometry.x,
        y      = screen.geometry.y + 30,
        width  = screen.geometry.width,
        height = screen.geometry.height - 30
    }

    local panel = wibox{
        screen       = screen,
        width        = beautiful.border_width - 1,
        height       = screen.geometry.height - 4,
        x            = screen.geometry.x,
        y            = screen.geometry.y,
        ontop        = true,
        bg           = beautiful.bg_normal,
        fg           = beautiful.fg_normal,
        shape        = gears.shape.rectangle,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus
    }

    function panel:run_rofi()
        _G.awesome.spawn(
            apps.default.rofi,
            false,
            false,
            false,
            false,
            function()
                panel:toggle()
            end
        )
    end

    local openPanel = function(should_run_rofi)
        panel.width      = 496
        backdrop.visible = true
        panel.visible    = false
        panel.visible    = true
        panel:get_children_by_id('panel_content')[1].visible = true
        if should_run_rofi then
            panel:run_rofi()
        end
        void.forced_width = 498
        home_menu.icon    = icons.close
    end

    local closePanel = function()
        panel.width       = 1
        panel:get_children_by_id('panel_content')[1].visible = false
        backdrop.visible  = false
        panel.visible     = false
        home_menu.icon    = icons.menu
        void.forced_width = 0
    end

    function panel:toggle(should_run_rofi)
        self.opened = not self.opened
        if self.opened then
            openPanel(should_run_rofi)
        else
            closePanel()
        end
    end

    backdrop:buttons(
        awful.util.table.join(
            awful.button(
            {},
            1,
            function()
                panel:toggle()
            end
            )
        )
    )

    panel:setup {
        layout = wibox.layout.stack,
        {
            id           = 'panel_content',
            bg           = beautiful.bg_normal,
            widget       = wibox.container.background,
            visible      = false,
            forced_width = dpi(500),
            {
                require('layout.left-panel.dashboard')(screen, panel),
                layout = wibox.layout.stack
            }
        }
    }

    home_menu:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                nil,
                function()
                    panel:toggle()
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
                    _G.clients_on_tag_change(function() awful.tag.history.restore() end)
                end
            ),
            awful.button(
                {},
                4,
                function(t)
                    _G.clients_on_tag_change(function() awful.tag.viewprev(t.screen) end)
                end
            ),
            awful.button(
                {},
                5,
                function(t)
                    _G.clients_on_tag_change(function() awful.tag.viewnext(t.screen) end)
                end
            )
        )
    )

    home_menu:connect_signal("mouse::leave", function()
        if home_menu_hover then
            _G.clients_on_tag_change(function() awful.tag.history.restore() end)
        end
    end)

    return menu_widget
end
return left_panel

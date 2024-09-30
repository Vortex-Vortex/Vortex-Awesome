local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

local tasklist_buttons = awful.util.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == _G.client.focus then
                c.minimized = true
            else
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                _G.client.focus = c
                c:raise()
            end
        end
    ),
    awful.button(
        {},
        2,
        function(c)
            c.kill(c)
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
    )
)

local widget_template = {
    {
        {
            {
                {
                    widget = wibox.widget.imagebox,
                    id     = 'icon_role'
                },
                widget  = wibox.container.margin,
                margins = 2
            },
            {
                widget = wibox.widget.textbox,
                id     = 'text_role'
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin,
        left   = 15,
        right  = 15,
        top    = 4,
        bottom = 4
    },
    widget = wibox.container.background,
    id = 'background_role',
    create_callback = function(self, c, index, objects)
        local tooltip = awful.tooltip{
            objects = { self },
        }
        self:connect_signal('mouse::enter', function()
            tooltip.text = c.name
            if self.bg ~= '#ffffff22' then
                self.backup     = self.bg
                self.has_backup = true
            end
            self.bg = '#ffffff22'
            local w = _G.mouse.current_wibox
            if w then
                old_cursor, old_wibox = w.cursor, w
                w.cursor = 'hand1'
            end
        end)

        self:connect_signal('mouse::leave', function()
            if self.has_backup then
                self.bg = self.backup
            end
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end)

        self:connect_signal('button::press', function()
            self.bg = '#ffffff33'
        end)

        self:connect_signal('button::release', function()
            self.bg = '#ffffff22'
        end)
    end
}


local TaskList = function(s)
    width = (s.geometry.width / 2) - 375
    return wibox.widget{
        awful.widget.tasklist{
            screen = s,
            widget_template = widget_template,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        },
        widget = wibox.container.margin,
        forced_width = width,
        margins = 1
    }
end

return TaskList

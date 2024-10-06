local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')
local modkey    = require('configuration.keys.mod').modKey

local clickable_container = require('widget.material.clickable-container')
local naughty = require('naughty')

local taglist_buttons = gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            clients_on_tag_change(function() t:view_only() end, t)
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if _G.client.focus then
                _G.client.focus:move_to_tag(t)
                t:view_only()
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
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
            clients_on_tag_change(function() awful.tag.viewprev(t.screen) end)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            clients_on_tag_change(function() awful.tag.viewnext(t.screen) end)
        end
    )
)

local widget_template = {
    {
        {
            id     = 'icon_role',
            widget = wibox.widget.imagebox,
        },
        margins = 6,
        widget  = wibox.container.margin,
    },
--     id = 'background_role',
    widget = wibox.container.background,
    create_callback = function(self, t, index, objects)
        self:connect_signal('mouse::enter', function()
            self.old_bg = self.bg
            if t.selected then
                self.bg = beautiful.taglist_bg_focus_hover
            elseif t.urgent then
                self.bg = beautiful.taglist_bg_urgent_hover
            else
                self.bg = beautiful.taglist_bg_normal_hover
            end
        end)

        self:connect_signal('mouse::leave', function()
            if t.selected then
                self.bg = beautiful.taglist_bg_focus
            elseif t.urgent then
                self.bg = beautiful.taglist_bg_urgent
            else
                self.bg = beautiful.taglist_bg_empty
            end
        end)

        self:connect_signal('button::press', function()
            if t.selected then
                self.bg = beautiful.taglist_bg_focus_click
            else
                self.bg = beautiful.taglist_bg_normal_click
            end
        end)

        self:connect_signal('button::release', function()
            if t.selected then
                self.bg = beautiful.taglist_bg_focus_hover
            else
                self.bg = beautiful.taglist_bg_normal_hover
            end
        end)
    end,
    update_callback = function(self, t, index, objects)
        if t.selected then
            self.bg = beautiful.taglist_bg_focus
        elseif t.urgent then
            self.bg = beautiful.taglist_bg_urgent
        else
            self.bg = beautiful.taglist_bg_empty
        end
    end
}

minimized_clients_per_tag = {}
for i = 1,10 do
    minimized_clients_per_tag[i] = {}
end

clients_on_tag_change = function(action, tag)
    prev_tag = screen[1].selected_tag
    if tag ~= prev_tag then
        if prev_tag then
            for _, c in ipairs(prev_tag:clients()) do
                if not c.minimized then
                    if c.name == 'QuakeTerminal' then
                        goto continue
                    end
                    table.insert(minimized_clients_per_tag[prev_tag.index], c)
                    c.minimized = true
                    ::continue::
                end
            end
        end
        action()
        cur_tag = screen[1].selected_tag
        for _, c in ipairs(minimized_clients_per_tag[cur_tag.index]) do
            pcall(function() c.minimized = false end)
        end
        minimized_clients_per_tag[cur_tag.index] = {}
    end
end

local TagList = function(s)
    return awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = widget_template
    }
end
return TagList

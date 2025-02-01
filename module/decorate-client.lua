local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')

local function renderClient(client, mode)
    if client.skip_decoration or client.rendering_mode == mode or client.name == 'QuakeTerminal' then
        return
    end
    client.rendering_mode = mode
    client.floating = false
    client.maximized = false
    client.above = false
    client.below = false
    client.ontop = false
    client.sticky = false
    client.maximized_horizontal = false
    client.maximized_vertical = false

    client.border_width = (mode == 'maximized') and 0 or beautiful.border_width
    client.shape = gears.shape.rectangle
end

local function updateClients(screen)
    local tag_is_max = screen.selected_tag and screen.selected_tag.layout == awful.layout.suit.max
    local clients_to_manage = {}

    for _, client in ipairs(screen.clients) do
        if not client.skip_decoration and not client.hidden then
            table.insert(clients_to_manage, client)
        end
    end

    local mode = (tag_is_max or #clients_to_manage == 1) and 'maximized' or 'tiled'

    for _, client in ipairs(clients_to_manage) do
        renderClient(client, mode)
    end
end

local function handleChange()
    local screen = awful.screen.focused()
    if screen then
        gears.timer.delayed_call(function()
            updateClients(screen)
        end)
    end
end

local signals = {
    'manage',
    'unmanage',
    'property::hidden',
    'property::minimized',
    'property::selected',
    'property::layout'
}

for _, signal in ipairs(signals) do
    if signal:find('^p') then
        _G.tag.connect_signal(signal, handleChange)
    else
        _G.client.connect_signal(signal, handleChange)
    end
end

_G.client.connect_signal('property::fullscreen', function(c)
    if c.fullscreen then
        renderClient(c, 'maximized')
    else
        handleChange()
    end
end)

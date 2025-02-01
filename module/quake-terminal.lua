local awful = require('awful')
local terminal = require('configuration.apps').default.quake

local quake_client

function toggle_quake()
    if not quake_client then
        awful.spawn(terminal, { skip_decoration = true })
    else
        quake_client.hidden = not quake_client.hidden
        quake_client.focus = not quake_client_hidden
        if not quake_client.hidden then
            quake_client:raise()
            client.focus = quake_client
        end
    end
end

_G.client.connect_signal(
    'manage',
    function(c)
        if (c.name == 'QuakeTerminal') then
            quake_client = c
            c.opacity = 1
            c.floating = true
            c.skip_taskbar = true
            c.ontop = true
            c.above = true
            c.sticky = true
            c.maximized_horizontal = true
        end
    end
)

_G.client.connect_signal(
    'unmanage',
    function(c)
        if (c.name == 'QuakeTerminal') then
            quake_client = nil
        end
    end
)

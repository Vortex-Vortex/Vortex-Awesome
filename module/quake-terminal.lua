local awful = require('awful')
local app = require('configuration.apps').default.quake

local quakeid = "notnil"
local quake_client
local opened = false

local function create_shell()
    quake_id = awful.spawn(app, { skip_decoration = true })
end

local function open_quake()
    quake_client.hidden = false
    quake_client:emit_signal('request::activate', { raise = false })
end

local function close_quake()
    quake_client.hidden = true
    quake_client:emit_signal('request::activate', { raise = true })
end

toggle_quake = function()
    opened = not opened
    if not quake_client then
        create_shell()
    else
        if opened then
            open_quake()
        else
            close_quake()
        end
    end
end

_G.client.connect_signal(
    'manage',
    function(c)
        if (c.pid == quake_id) then
            quake_client           = c
            c.opacity              = 0.5
            c.floating             = true
            c.skip_taskbar         = true
            c.ontop                = true
            c.above                = true
            c.sticky               = true
            c.hidden               = not opened
            c.maximized_horizontal = true
        end
    end
)

_G.client.connect_signal(
    'unmanage',
    function(c)
        if (c.pid == quake_id) then
            opened       = false
            quake_client = nil
        end
    end
)

-- create_shell()

local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')

local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

awful.rules.rules = {
    {
        rule = {},
        properties = {
            focus                = awful.client.focus.filter,
            raise                = true,
            keys                 = client_keys,
            buttons              = client_buttons,
            screen               = awful.screen.preferred,
            placement            = awful.placement.no_offscreen,
            floating             = false,
            maximized            = false,
            above                = false,
            below                = false,
            ontop                = false,
            sticky               = false,
            maximized_horizontal = false,
            maximized_vertical   = false
        }
    },
    {
        rule_any = {
            name = { 'Picture-in-Picture' },
            type = { 'dialog' },
            class = { 'Lxpolkit', 'lxpolkit', 'mpv', 'kcalc', 'kruler', 'huiontablet' }
        },
        properties = {
            floating = true,
            ontop = true,
            skip_decoration = true
        }
    },
    {
        rule_any = {
            class = { 'rnote' }
        },
        callback = function(c)
            local keys = c:keys()
            c:keys(
                gears.table.join(
                    keys,
                    awful.key(
                        {},
                        "b",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 780 1030 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Brush', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {"Shift"},
                        "b",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 780 1030 click 1 sleep 0.25 mousemove 1870 335 click 1 sleep 0.001 mousemove 1550 350 click 1 mousemove 960 540 click 1')
                        end,
                        {description = 'Set Standard Brush', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "m",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 780 1030 click 1 sleep 0.25 mousemove 1870 335 click 1 sleep 0.001 mousemove 1550 300 click 1 mousemove 960 540 click 1')
                        end,
                        {description = 'Marker Brush', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "]",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 415 click 1')
                        end,
                        {description = 'Increase Brush Size', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "[",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 480 click 1')
                        end,
                        {description = 'Decrease Brush Size', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "#87",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 525 click 1')
                        end,
                        {description = 'Small Brush Size', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "#88",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 575 click 1')
                        end,
                        {description = 'Medium Brush Size', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "#89",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 615 click 1')
                        end,
                        {description = 'Big Brush Size', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "s",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Shaper', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "l",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 670 click 1 sleep 0.001 mousemove 1600 590 click 1 mousemove 780 1030 click 1 mousemove 780 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Line Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "a",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 670 click 1 sleep 0.001 mousemove 1655 590 click 1 mousemove 780 1030 click 1 mousemove 780 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Arrow Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "r",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 670 click 1 sleep 0.001 mousemove 1690 590 click 1 mousemove 780 1030 click 1 mousemove 780 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Rectangle Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "t",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 670 click 1 sleep 0.001 mousemove 1745 590 click 1 mousemove 780 1030 click 1 mousemove 780 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Table Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "g",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 670 click 1 sleep 0.001 mousemove 1600 670 click 1 mousemove 780 1030 click 1 mousemove 780 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Graph Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "e",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 670 click 1 sleep 0.001 mousemove 1600 740 click 1 mousemove 780 1030 click 1 mousemove 780 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Circle Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "c",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 670 click 1 sleep 0.001 mousemove 1655 800 click 1 mousemove 780 1030 click 1 mousemove 780 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Curve Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "\\",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 945 1030 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Eraser', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "#82",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 335 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Toolbar OPT 1', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "#86",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 375 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Toolbar OPT 2', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "#129",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 415 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Toolbar OPT 3', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "#104",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 455 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Toolbar OPT 4', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "z",
                        function()
                            awful.spawn.with_shell('sleep 0.07; xdotool keydown Ctrl key z keyup Ctrl')
                        end,
                        {description = 'Undo', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "x",
                        function()
                            awful.spawn('xdotool mousemove 1000 1030 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Selection', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "1",
                        function()
                            awful.spawn('xdotool mousemove 840 125 click 1')
                        end,
                        {description = 'Color 1', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "2",
                        function()
                            awful.spawn('xdotool mousemove 880 125 click 1')
                        end,
                        {description = 'Color 2', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "3",
                        function()
                            awful.spawn('xdotool mousemove 920 125 click 1')
                        end,
                        {description = 'Color 3', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "4",
                        function()
                            awful.spawn('xdotool mousemove 960 125 click 1')
                        end,
                        {description = 'Color 4', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "5",
                        function()
                            awful.spawn('xdotool mousemove 1000 125 click 1')
                        end,
                        {description = 'Color 5', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "6",
                        function()
                            awful.spawn('xdotool mousemove 1040 125 click 1')
                        end,
                        {description = 'Color 6', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "7",
                        function()
                            awful.spawn('xdotool mousemove 1080 125 click 1')
                        end,
                        {description = 'Color 7', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "8",
                        function()
                            awful.spawn('xdotool mousemove 1120 125 click 1')
                        end,
                        {description = 'Color 8', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "d",
                        function()
                            awful.spawn('xdotool mousemove 1060 1030 click 1')
                        end,
                        {description = 'Drag Vertical Space', group = 'Rnote Exclusive'}
                    )
                )
            )
        end
    },
    {
        rule_any = {
            name = { 'arras.io' }
        },
        callback = function(c)
            local keys = c:keys()
            local buttons = c:buttons()
            c:buttons(
                gears.table.join(
                    buttons,
                    awful.button(
                        {},
                        4,
                        function()
                            local filename = "/tmp/ARRAS_CIRCLE"
                            local value = 0.1

                            awful.spawn.easy_async_with_shell(
                                "test -f " .. filename,
                                function(_, _, _, exit_code)
                                    if exit_code == 0 then
                                        -- File exists
                                        awful.spawn.easy_async_with_shell(
                                            "cat " .. filename,
                                            function(stdout)
                                                value = tonumber(stdout) + 0.01
                                                awful.spawn.with_shell('dbus-send --type=method_call --dest="org.freedesktop.Notifications" /org/freedesktop/Notifications org.freedesktop.Notifications.Notify string:"String" uint32:1 string:"" string:"Circle_Angle" string:"' .. tostring(value) .. '" array:string:"" dict:string:string:"",""')
                                                awful.spawn.with_shell("echo " .. tostring(value) .. " > " .. filename)
                                            end
                                        )
                                    else
                                        -- File does not exist
                                        awful.spawn.easy_async_with_shell("echo " .. tostring(value) .. " > " .. filename)
                                        naughty.notify{text = "Creating File"}
                                    end
                                end
                            )
                        end,
                        {description = '', group = ''}
                    ),
                    awful.button(
                        {},
                        5,
                        function()
                            local filename = "/tmp/ARRAS_CIRCLE"
                            local value = 0.1

                            awful.spawn.easy_async_with_shell(
                                "test -f " .. filename,
                                function(_, _, _, exit_code)
                                    if exit_code == 0 then
                                        -- File exists
                                        awful.spawn.easy_async_with_shell(
                                            "cat " .. filename,
                                            function(stdout)
                                                value = tonumber(stdout) - 0.01
                                                awful.spawn.with_shell('dbus-send --type=method_call --dest="org.freedesktop.Notifications" /org/freedesktop/Notifications org.freedesktop.Notifications.Notify string:"String" uint32:1 string:"" string:"Circle_Angle" string:"' .. tostring(value) .. '" array:string:"" dict:string:string:"",""')
                                                awful.spawn.with_shell("echo " .. tostring(value) .. " > " .. filename)
                                            end
                                        )
                                    else
                                        -- File does not exist
                                        awful.spawn.easy_async_with_shell("echo " .. tostring(value) .. " > " .. filename)
                                        naughty.notify{text = "Creating File"}
                                    end
                                end
                            )
                        end,
                        {description = '', group = ''}
                    )
                )
            )
            c:keys(
                gears.table.join(
                    keys,
                    awful.key(
                        {},
                        "#87",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/finger')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#88",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/scatterer')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#89",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/basher')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#83",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/leviathan')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#84",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/chisel')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#85",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/designer')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#79",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/pincer')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#80",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/rigger')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#81",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/vortex')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "#90",
                        function()
                            awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/random')
                        end,
                        {description = '', group = ''}
                    ),
                    awful.key(
                        {},
                        "c",
                        function()
                            if not state then
                                awful.spawn.with_shell('sh /home/vortex/Downloads/Arras/spin')
                                state = true -- Update state to running
                            else
                                -- Stop the script
                                os.execute("pkill -f '/home/vortex/Downloads/Arras/spin'")
                                state = false -- Update state to stopped
                            end
                        end,
                        {description = '', group = ''}
                    )
                )
            )
        end
    },
    {
        rule_any = {
            name = { 'QuakeTerminal' }
        },
        properties = {
            skip_decoration = true
        }
    }
}

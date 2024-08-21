local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')

local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

awful.rules.rules = {
    {
        rule = {},
        except_any = {
            instance = { "Microsoft", "Microsoft Excel", "Microsoft PowerPoint", "Microsoft Word", "Microsoft Visio", "Microsoft Project", "Autodesk AutoCAD", "RAIL" },
            class = { "sketchbook.exe" },
            name = { "PanelWindow", "Autodesk SketchBook" }
        },
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
            instance = { "Microsoft", "Microsoft Excel", "Microsoft PowerPoint", "Microsoft Word", "Microsoft Visio", "Microsoft Project", "Autodesk AutoCAD", "RAIL" }
        },
        properties = {
            focus                = false,
            raise                = true,
            keys                 = client_keys,
            buttons              = client_buttons,
            screen               = awful.screen.preferred,
            placement            = awful.placement.no_offscreen,
            opacity              = 1,
            focusable            = true,
            floating             = false,
            maximized            = false,
            above                = false,
            below                = false,
            ontop                = false,
            sticky               = false,
            maximized_horizontal = false,
            maximized_vertical   = false,
            skip_decoration      = true
        }
    },
    {
        rule = {
            class = "Microsoft Excel",
            name = "Temporary c"
        },
        properties = {
            focus                = false,
            raise                = false,
            keys                 = nil,
            buttons              = nil,
            screen               = awful.screen.preferred,
            placement            = awful.placement.no_offscreen,
            opacity              = 0,
            focusable            = false,
            floating             = true,
            maximized            = false,
            above                = false,
            below                = true,
            ontop                = false,
            sticky               = false,
            maximized_horizontal = false,
            maximized_vertical   = false,
            skip_decoration      = true,
            skip_taskbar         = true
        }
    },
    {
        rule = {
            class = "Microsoft Excel",
            type = "dialog"
        },
        properties = {
            focus                = true,
            raise                = true,
            keys                 = nil,
            buttons              = nil,
            screen               = awful.screen.preferred,
            placement            = awful.placement.no_offscreen,
            opacity              = 1,
            focusable            = false,
            floating             = true,
            maximized            = false,
            above                = false,
            below                = false,
            ontop                = false,
            sticky               = false,
            maximized_horizontal = false,
            maximized_vertical   = false,
            skip_decoration      = true,
            skip_taskbar         = true
        }
    },
    {
        rule_any = {
            class = { "Microsoft Excel", "Microsoft PowerPoint", "Microsoft Word", "Microsoft Visio", "Microsoft Project" }
        },
        callback = function(c)
            local buttons = c:buttons()
            c:buttons(
                gears.table.join(
                    buttons,
                    awful.button(
                        {"Shift", altkey},
                        3,
                        function()
                            awful.spawn.with_shell('xdotool mousedown 1; xdotool mousemove_relative -- 75 0; xdotool mouseup 1')
                        end,
                        {description = 'Mouse Drag right', group = 'Excel'}
                    ),
                    awful.button(
                        {"Shift", altkey},
                        1,
                        function()
                            awful.spawn.with_shell('xdotool mousedown 1; xdotool mousemove_relative -- -75 0; xdotool mouseup 1')
                        end,
                        {description = 'Mouse Drag left', group = 'Excel'}
                    ),
                    awful.button(
                        {"Shift", altkey},
                        9,
                        function()
                            awful.spawn.with_shell('xdotool mousedown 1; xdotool mousemove_relative -- 0 -35; xdotool mouseup 1')
                        end,
                        {description = 'Mouse Drag up', group = 'Excel'}
                    ),
                    awful.button(
                        {"Shift", altkey},
                        8,
                        function()
                            awful.spawn.with_shell('xdotool mousedown 1; xdotool mousemove_relative -- 0 35; xdotool mouseup 1')
                        end,
                        {description = 'Mouse Drag down', group = 'Excel'}
                    )
                )
            )
        end
    },
    {
        rule = {
            instance = "SpawnOn1"
        },
        properties = {
            tag = "1"
        }
    },
    {
        rule = {
            role = "SpawnOn2"
        },
        properties = {
            tag = "2"
        }
    },
    {
        rule = {
            class = "TelegramDesktop"
        },
        properties = {
            tag = "3"
        }
    },
    {
        rule = {
            class = "SpawnOn5"
        },
        properties = {
            tag = "5"
        }
    },
    {
        rule_any = {
            instance = { "pragha", "Pragha" }
        },
        properties = {
            tag = "8"
        }
    },
    {
        rule_any = {
            name = { 'Picture-in-Picture' },
            type = { 'dialog' },
            class = { 'Lxpolkit', 'lxpolkit', 'mediainfo-gui', 'Mediainfo-gui', 'mpv', 'kcalc', 'kruler', 'huiontablet', 'shotwell', 'Shotwell' }
        },
        except_any = {
            instance = { "Microsoft", "Microsoft Word", "Microsoft Excel", "Microsoft PowerPoint", "Autodesk AutoCAD", "RAIL", "PanelWindow" }
        },
        properties = {
            floating = true,
            opacity = 1,
            ontop = true,
            skip_decoration = true,
            placement = awful.placement.centered
        }
    },
    {
        rule_any = {
            class = { "sketchbook.exe" },
            name = { "PanelWindow", "Autodesk SketchBook" }
        },
        properties = {
            focus                = false,
            raise                = false,
            keys                 = client_keys,
            buttons              = client_buttons,
            floating             = true,
            ontop                = false,
            sticky               = false,
            maximized_horizontal = false,
            maximized_vertical   = false,
            skip_decoration      = true
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
                        "1",
                        function()
                            awful.spawn('xdotool mousemove 820 125 click 1')
                        end,
                        {description = 'Color 1', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "2",
                        function()
                            awful.spawn('xdotool mousemove 860 125 click 1')
                        end,
                        {description = 'Color 2', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "3",
                        function()
                            awful.spawn('xdotool mousemove 900 125 click 1')
                        end,
                        {description = 'Color 3', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "4",
                        function()
                            awful.spawn('xdotool mousemove 940 125 click 1')
                        end,
                        {description = 'Color 4', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "5",
                        function()
                            awful.spawn('xdotool mousemove 980 125 click 1')
                        end,
                        {description = 'Color 5', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "6",
                        function()
                            awful.spawn('xdotool mousemove 1020 125 click 1')
                        end,
                        {description = 'Color 6', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "7",
                        function()
                            awful.spawn('xdotool mousemove 1060 125 click 1')
                        end,
                        {description = 'Color 7', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "8",
                        function()
                            awful.spawn('xdotool mousemove 1100 125 click 1')
                        end,
                        {description = 'Color 8', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "9",
                        function()
                            awful.spawn('xdotool mousemove 1140 125 click 1')
                        end,
                        {description = 'Color 9', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "b",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 770 1030 click 1 sleep 0.01 mousemove restore')
                        end,
                        {description = 'Brush', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {"Shift"},
                        "b",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 780 1030 click 1 sleep 0.25 mousemove 1870 335 click 1 sleep 0.001 mousemove 1550 350 click 1 mousemove 1880 335 click 1')
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
                        "[",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 1870 415 click 1')
                        end,
                        {description = 'Increase Brush Size', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "]",
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
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 330 click 1 sleep 0.001 mousemove 1600 250 click 1 mousemove 770 1030 click 1 mousemove 770 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Line Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "a",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 330 click 1 sleep 0.001 mousemove 1655 250 click 1 mousemove 770 1030 click 1 mousemove 770 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Arrow Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "r",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 330 click 1 sleep 0.001 mousemove 1690 250 click 1 mousemove 770 1030 click 1 mousemove 770 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Rectangle Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "t",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 330 click 1 sleep 0.001 mousemove 1745 250 click 1 mousemove 770 1030 click 1 mousemove 770 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Table Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "g",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 330 click 1 sleep 0.001 mousemove 1600 330 click 1 mousemove 770 1030 click 1 mousemove 770 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Graph Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "e",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 330 click 1 sleep 0.001 mousemove 1600 405 click 1 mousemove 770 1030 click 1 mousemove 770 1030 click 1 mousemove 960 540')
                        end,
                        {description = 'Circle Shape', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {},
                        "c",
                        function()
                            awful.spawn.with_shell('xdotool mousemove 840 1030 click 1 sleep 0.25 mousemove 1870 330 click 1 sleep 0.001 mousemove 1655 470 click 1 mousemove 770 1030 click 1 mousemove 770 1030 click 1 mousemove 960 540')
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
                            awful.spawn('xdotool mousemove 1125 1030 click 1')
                        end,
                        {description = 'Undo', group = 'Rnote Exclusive'}
                    ),
                    awful.key(
                        {'Shift'},
                        "z",
                        function()
                            awful.spawn('xdotool mousemove 1160 1030 click 1')
                        end,
                        {description = 'Redo', group = 'Rnote Exclusive'}
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
                        "d",
                        function()
                            awful.spawn('xdotool mousemove 1060 1030 click 1 mousemove restore')
                        end,
                        {description = 'Drag Vertical Space', group = 'Rnote Exclusive'}
                    )
                )
            )
        end
    },
    {
        rule_any = {
            name = { 'QuakeTerminal' },
        },
        properties = {
            skip_decoration = true
        }
    }
}

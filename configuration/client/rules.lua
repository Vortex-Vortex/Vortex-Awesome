local awful = require('awful')
local gears = require('gears')

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
            class = { 'Lxpolkit', 'lxpolkit' }
        },
        properties = {
            floating = true,
            ontop = true,
            skip_decoration = true
        }
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

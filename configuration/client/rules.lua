local awful = require('awful')
local client_buttons = require('configuration.client.buttons')

awful.rules.rules = {
    {
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            buttons = client_buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_offscreen,
            floating = false,
            maximized = false,
            above = false,
            below = false,
            ontop = false,
            sticky = false,
            maximized_horizontal = false,
            maximized_vertical = false
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
            role = "spawn_on_2"
        },
        properties = {
            tag = "2"
        }
    },
    {
        rule_any = {
            name = { 'Picture-in-Picture' },
            type = { 'dialog' },
            class = { 'Lxpolkit', 'lxpolkit', 'mediainfo-gui', 'Mediainfo-gui', 'mpv', 'kcalc', 'kruler', 'huiontablet', 'shotwell', 'Shotwell', 'feh', 'mupdf', 'MuPDF' }
        },
        properties = {
            floating = true,
            opacity = 1,
            ontop = true,
            skip_decoration = true,
            placement = awful.placement.centered
        }
    }
}

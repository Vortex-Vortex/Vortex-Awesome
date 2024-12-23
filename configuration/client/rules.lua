local awful = require('awful')

awful.rules.rules = {
    {
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
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
    }
}

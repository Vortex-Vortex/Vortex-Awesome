local dir = require('gears.filesystem').get_configuration_dir() .. '/theme/icons/'

return {
    -- tags
    browser  = dir .. '/tags/browser.svg',
    terminal = dir .. '/tags/braces.svg',
    social   = dir .. '/tags/chat.svg',
    game     = dir .. '/tags/controller.svg',
    folder   = dir .. '/tags/folder.svg',
    coding   = dir .. '/tags/memory.svg',
    edit     = dir .. '/tags/pencil.svg',
    music    = dir .. '/tags/music.svg',
    lab      = dir .. '/tags/flask.svg',
    -- others
    menu_icon = dir .. '/misc/menu.svg',
    notification_icon = dir .. '/misc/notification.svg',
    plus_icon = dir .. '/misc/plus.svg',
    x_icon = dir .. '/misc/close.svg',
    half_arrow_down = dir .. '/misc/half-arrow-down.svg',
    half_arrow_up = dir .. '/misc/half-arrow-up.svg',
    half_arrow_left = dir .. '/misc/half-arrow-left.svg',
    half_arrow_right = dir .. '/misc/half-arrow-right.svg',
    trash_icon = dir .. '/misc/trash.svg',
    arrow_down = dir .. '/misc/arrow-down.svg',
    arrow_up = dir .. '/misc/arrow-up.svg',
    arrow_left = dir .. '/misc/arrow-left.svg',
    arrow_right = dir .. '/misc/arrow-right.svg',
    alarm_clock = dir .. '/misc/alarm-clock.svg'
}

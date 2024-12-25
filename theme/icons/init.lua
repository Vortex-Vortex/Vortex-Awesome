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
    x_icon = dir .. '/misc/close.svg'
}

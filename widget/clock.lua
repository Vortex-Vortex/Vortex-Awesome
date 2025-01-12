wibox = require('wibox')
beautiful = require('beautiful')

local textclock = wibox.widget{
    widget = wibox.container.place,
    {
        widget = wibox.widget.textclock,
        format = '<span font="' .. beautiful.system_font .. 'mono bold 12">%H:%M:%S</span>',
        refresh = 1
    },
    valign = 'center',
    halign = 'center'
}

return textclock

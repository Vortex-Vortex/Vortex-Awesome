local wibox = require('wibox')

local function quick_settings()
    local main_panel = wibox.widget{
        {
            widget = wibox.widget.textbox,
            forced_height = 50,
            text  = 'Quick settings',
            font  = 'Roboto medium 10',
            align = "center",
            valign = "center"
        },
        require('widget.volume-panel.volume-slider'),
        require('widget.brightness-panel.brightness-slider'),
        layout = wibox.layout.fixed.vertical
    }

    return main_panel
end
return quick_settings()

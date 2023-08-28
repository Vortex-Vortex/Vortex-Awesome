local wibox = require('wibox')

local function hardware_monitor()
    local main_panel = wibox.widget{
        {
            widget = wibox.widget.textbox,
            forced_height = 50,
            text  = 'Hardware monitor',
            font  = 'Roboto medium 10',
            align = "center",
            valign = "center"
        },
        require('widget.ram-panel.ram-bar'),
        require('widget.harddrive-panel.harddrive-bar'),
        require('widget.cpu-panel.cpu-panel'),
        layout = wibox.layout.fixed.vertical
    }

    return main_panel
end
return hardware_monitor()

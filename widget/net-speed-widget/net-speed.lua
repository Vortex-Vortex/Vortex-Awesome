local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local icons = require('theme.icons')

local interface = '*' -- 'eno1' 'eth0' 'lo'
local CMD = string.format([[bash -c "cat /sys/class/net/%s/statistics/*_bytes"]], interface)

local function convert_to_h(bytes)
    local speed
    local dim
    if bytes < 1000 then
        speed = bytes
        dim = 'B/s'
    elseif bytes < 1000000 then
        speed = bytes/1000
        dim = 'KB/s'
    elseif bytes < 1000000000 then
        speed = bytes/1000000
        dim = 'MB/s'
    elseif bytes < 1000000000000 then
        speed = bytes/1000000000
        dim = 'GB/s'
    else
        speed = tonumber(bytes)
        dim = 'B/s'
    end
    return math.floor(speed + 0.5) .. dim
end

local function split(string_to_split, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}

    for str in string.gmatch(string_to_split, "([^".. separator .."]+)") do
        table.insert(t, str)
    end

    return t
end

local rx_textbox = wibox.widget{
    widget = wibox.widget.textbox,
    forced_width = 55,
    align        = 'left',
    text         = '0B/s'
}
local tx_textbox = wibox.widget{
    widget = wibox.widget.textbox,
    forced_width = 55,
    align        = 'left',
    text         = '0B/s'
}

local net_speed_widget = wibox.widget{
    {
        image = icons.arrow_down,
        widget = wibox.widget.imagebox
    },
    rx_textbox,
    {
        image = icons.arrow_up,
        widget = wibox.widget.imagebox
    },
    tx_textbox,
    layout = wibox.layout.fixed.horizontal
}

local prev_rx = 0
local prev_tx = 0

local function update_widget()
    awful.spawn.easy_async_with_shell(CMD, function(stdout)
        local cur_vals = split(stdout, '\r\n')

        local cur_rx = 0
        local cur_tx = 0

        for i, v in ipairs(cur_vals) do
            if i%2 == 1 then cur_rx = cur_rx + v end
            if i%2 == 0 then cur_tx = cur_tx + v end
        end

        local speed_rx = (cur_rx - prev_rx)
        local speed_tx = (cur_tx - prev_tx)

        rx_textbox.text = tostring(convert_to_h(speed_rx))
        tx_textbox.text = tostring(convert_to_h(speed_tx))

        prev_rx = cur_rx
        prev_tx = cur_tx
    end)
end

gears.timer{
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function()
        update_widget()
    end
}

return net_speed_widget

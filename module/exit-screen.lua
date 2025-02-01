local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local apps = require('configuration.apps')
local icons = require('theme.icons')
local button_widget = require('widget.material.button-widget')

local screen = awful.screen.focused()
local exit_screen = wibox(
    {
        screen = screen,
        x = screen.geometry.x,
        y = screen.geometry.y,
        visible = false,
        ontop = true,
        type = 'splash',
        bg = beautiful.bg_color .. 'dd',
        fg = beautiful.fg_color,
        height = screen.geometry.height,
        width = screen.geometry.width
    }
)

function show_exit_screen()
    exit_screen.visible = true
end

local function hide_exit_screen()
    exit_screen.visible = false
end

exit_screen:connect_signal(
    'button::press',
    function()
        gears.timer{
            timeout = 0.05,
            single_shot = true,
            autostart = true,
            callback = hide_exit_screen
        }
    end
)

function system_poweroff()
    awful.spawn('poweroff')
end
function system_restart()
    awful.spawn('reboot')
end
function system_suspend()
    awful.spawn.with_shell(apps.default.lock .. ' & systemctl suspend')
end
function system_logout()
    _G.awesome.quit()
end
function system_lock()
    awful.spawn(apps.default.lock)
end

local poweroff = button_widget('power_icon')
poweroff:connect_signal('button::press', system_poweroff)

local restart = button_widget('restart_icon')
restart:connect_signal('button::press', system_restart)

local suspend = button_widget('suspend_icon')
suspend:connect_signal('button::press', system_suspend)

local logout = button_widget('logout_icon')
logout:connect_signal('button::press', system_logout)

local lock = button_widget('lock_icon')
lock:connect_signal('button::press', system_lock)

exit_screen:setup{
    layout = wibox.container.place,
    {
        layout = wibox.layout.flex.horizontal,
        poweroff,
        restart,
        suspend,
        logout,
        lock,
        spacing = 30,
        forced_width = screen.geometry.width * 0.45 + 120,
        forced_height = screen.geometry.width * 0.09
    },
    halign = 'center',
    valign = 'center'
}

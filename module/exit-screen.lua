local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')
local icons     = require('theme.icons')
local apps      = require('configuration.apps')

local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')

local function create_button(icon)
    local button = wibox.widget{
        {
            {
                {
                    widget = wibox.widget.imagebox,
                    image = icon
                },
                widget = wibox.container.margin,
                margins = dpi(16)
            },
            widget = clickable_container,
            shape         = gears.shape.circle,
            forced_height = dpi(140),
            forced_width  = dpi(140)
        },
        widget = wibox.container.margin,
        left  = dpi(24),
        right = dpi(24)
    }
    return button
end

local function suspend_command()
    exit_screen_hide()
    awful.spawn.with_shell(apps.default.lock .. ' & systemctl suspend')
end
function exit_command()
    _G.awesome.quit()
end
function lock_command()
    exit_screen_hide()
    awful.spawn.with_shell('sleep 0.5 && ' .. apps.default.lock)
end
function poweroff_command()
    awful.spawn.with_shell('poweroff')
    awful.keygrabber.stop(_G.exit_screen_grabber)
end
function reboot_command()
    awful.spawn.with_shell('reboot')
    awful.keygrabber.stop(_G.exit_screen_grabber)
end

local poweroff = create_button(icons.power, 'Shutdown')
poweroff:connect_signal('button::release', function()
    poweroff_command()
end)
local reboot = create_button(icons.restart, 'Restart')
reboot:connect_signal('button::release', function()
    reboot_command()
end)
local suspend = create_button(icons.sleep, 'Sleep')
suspend:connect_signal('button::release', function()
    suspend_command()
end)
local exit = create_button(icons.logout, 'Logout')
exit:connect_signal('button::release', function()
    exit_command()
end)
local lock = create_button(icons.lock, 'Lock')
lock:connect_signal('button::release', function()
    lock_command()
end)

local screen_geometry = awful.screen.focused().geometry
local exit_screen = wibox(
    {
        screen  = 1,
        x       = screen_geometry.x,
        y       = screen_geometry.y,
        visible = false,
        ontop   = true,
        type    = 'splash',
        bg      = beautiful.bg_normal .. 'dd',
        fg      = beautiful.fg_normal,
        height  = screen_geometry.height,
        width   = screen_geometry.width
    }
)

function exit_screen_hide()
    exit_screen.visible = false
end

function exit_screen_show()
    exit_screen.visible = true
end

exit_screen:buttons(
    gears.table.join(
        awful.button(
            {},
            2,
            function()
                exit_screen_hide()
            end
        ),
        awful.button(
            {},
            3,
            function()
                exit_screen_hide()
            end
        )
    )
)

exit_screen:setup{
    nil,
    {
        nil,
        {
            poweroff,
            reboot,
            suspend,
            exit,
            lock,
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        layout = wibox.layout.align.horizontal,
        expand = 'none'
    },
    nil,
    layout = wibox.layout.align.vertical,
    expand = 'none'
}

local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')

local hotkeys_popup = require('awful.hotkeys_popup').widget
local modkey = require('configuration.keys.mod').modkey
local altkey = require('configuration.keys.mod').altkey
local apps = require('configuration.apps')

local global_keys = gears.table.join(
        -- Undefined

    awful.key(
        {},
        'Num_Lock',
        function()
            awful.spawn.with_shell('sleep 0.1; brightnessctl -d "*scrolllock" set 100%')
        end,
        {description = nil, group = nil}
    ),
    awful.key(
        {},
        'Caps_Lock',
        function()
            awful.spawn.with_shell('sleep 0.1; brightnessctl -d "*scrolllock" set 100%')
        end,
        {description = nil, group = nil}
    ),
        -- Awesome WM
    awful.key(
        {modkey},
        'F1',
        function()
            hotkeys_popup.show_help()
        end,
        {description = "Show help menu", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        'z',
        function()
            for s in screen do
                s.top_panel.visible = not s.top_panel.visible
            end
        end,
        {description = "Toggle top bar", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        'F1',
        function()
            hotkeys_popup:show_help()
        end,
        {description = "Show help menu", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        'r',
        function()
            awful.spawn(apps.default.rofi)
        end,
        {description = "Show application menu", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'r',
        function()
            _G.system_restart()
        end,
        {description = "Restart computer", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Shift'},
        's',
        function()
            _G.system_poweroff()
        end,
        {description = "Shutdown computer", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'l',
        function()
            _G.show_exit_screen()
        end,
        {description = "Show log-out screen", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        'l',
        function()
            awful.spawn(apps.default.lock)
        end,
        {description = "Lock screen", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Control'},
        'r',
        function()
            _G.awesome.restart()
        end,
        {description = "Reload AwesomeWM", group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Control'},
        'q',
        function()
            _G.awesome.quit()
        end,
        {description = "Kill AwesomeWM", group = 'Awesome WM'}
    ),

        -- Tag management

    awful.key(
        {modkey},
        'Next',
        function()
            _G.change_tag(
                function()
                    awful.tag.viewnext()
                end
            )
        end,
        {description = "View next", group = 'Tag'}
    ),
    awful.key(
        {modkey},
        'Prior',
        function()
            _G.change_tag(
                function()
                    awful.tag.viewprev()
                end
            )
        end,
        {description = "View previous", group = 'Tag'}
    ),
    awful.key(
        {modkey},
        'Escape',
        function()
            _G.change_tag(
                function()
                    awful.tag.history.restore()
                end
            )
        end,
        {description = "Go back", group = 'Tag'}
    ),
    awful.key(
        {modkey},
        '#90',
        function()
            _G.change_tag(
                function()
                    awful.tag.history.restore()
                end
            )
        end,
        {description = "Go back", group = 'Tag'}
    ),

        -- Client/Window management

    awful.key(
        {altkey},
        'Tab',
        function()
            awful.client.focus.byidx(1)
            if _G.client.focus then
                _G.client.focus:raise()
            end
        end,
        {description = 'Switch to next window', group = 'Client'}
    ),
    awful.key(
        {altkey, 'Shift'},
        'Tab',
        function()
            awful.client.focus.byidx(-1)
            if _G.client.focus then
                _G.client.focus:raise()
            end
        end,
        {description = 'Switch to previous window', group = 'Client'}
    ),
    awful.key(
        {modkey},
        'Up',
        function()
            local c = awful.client.restore()
            if c then
                _G.client.focus = c
                c:raise()
            end
        end,
        {description = 'Restore minimized', group = 'Client'}
    ),
    awful.key(
        {modkey},
        "Down",
        function ()
            local c = client.focus
            if c then
                c.minimized = true
            end
        end,
        {description = "Minimize client", group = "Client"}
    ),
    awful.key(
        {modkey},
        't',
        function ()
            local c = client.focus
            if c then
                c.ontop = not c.ontop
            end
        end,
        {description = "Toggle always on top", group = 'Client'}
    ),
    awful.key(
        {modkey},
        "d",
        function ()
            local c = client.focus
            if c then
                c.floating = not c.floating
                c.ontop = c.floating
                c.opacity = 1
            end
        end,
        {description = "Toggle floating/ontop", group = "Client"}
    ),
    awful.key(
        {modkey},
        'f',
        function()
            local c = client.focus
            if c then
                c.fullscreen = not c.fullscreen
                c:raise()
            end
        end,
        {description = 'Toggle fullscreen', group = 'Client'}
    ),
    awful.key(
        {modkey},
        'q',
        function()
            local c = client.focus
            if c then
                c:kill(9)
            end
        end,
        {description = 'Close', group = 'Client'}
    ),

        -- Screenshot

    awful.key(
        {},
        'Print',
        function()
            awful.spawn.with_shell(apps.default.region_screenshot)
        end,
        {description = 'Mark an area and screenshot it', group = 'Screenshots'}
    ),
    awful.key(
        {modkey},
        'Print',
        function()
            awful.spawn.with_shell(apps.default.screenshot)
        end,
        {description = 'Take a screenshot of your active monitor', group = 'Screenshots'}
    ),
    awful.key(
        {modkey, 'Control'},
        'p',
        function()
            gears.timer{
                timeout = 9,
                autostart = true,
                single_shot = true,
                callback = function()
                    naughty.notify{
                        title = 'Screenshotting',
                        text = 'In 1 second!',
                        timeout = 1
                    }
                    gears.timer{
                        timeout = 1,
                        autostart = true,
                        single_shot = true,
                        callback = function()
                            naughty.destroy_all_notifications()
                            awful.spawn.with_shell(apps.default.screenshot)
                        end
                    }
                end
            }
        end,
        {description = 'Screenshot with 10 seconds delay', group = 'Screenshots'}
    ),
    awful.key(
        {modkey},
        'p',
        function()
            awful.spawn(apps.default.pip_screenshot)
        end,
        {description = 'Screenshot area and PIP it', group = 'Screenshots'}
    ),
    awful.key(
        {modkey},
        'o',
        function()
            awful.spawn(apps.default.ocr_screenshot)
        end,
        {description = 'OCR scan region and copy to clipboard', group = 'Screenshots'}
    ),
    awful.key(
        {modkey},
        'i',
        function()
            awful.spawn(apps.default.qr_screenshot)
        end,
        {description = 'QR scan region and open link', group = 'Screenshots'}
    ),
    awful.key(
        {modkey, "Shift"},
        'p',
        function()
            awful.spawn.with_shell(apps.default.color_picker)
        end,
        {description = 'Pick color to HEX value', group = 'Screenshots'}
    ),

        -- Launch programs

    awful.key(
        {modkey},
        'c',
        function()
            awful.spawn(apps.default.coding)
        end,
        {description = 'Open a text/code editor', group = 'Launcher'}
    ),
    awful.key(
        {modkey},
        'b',
        function()
            awful.spawn(apps.default.browser)
        end,
        {description = 'Open a browser', group = 'Launcher'}
    ),
    awful.key(
        {modkey},
        'x',
        function()
            awful.spawn(apps.default.terminal)
        end,
        {description = 'Open a terminal', group = 'Launcher'}
    ),
    awful.key(
        {modkey},
        'e',
        function()
            awful.spawn(apps.default.files)
        end,
        {description = 'Filebrowser', group = 'Launcher'}
    ),
    awful.key(
        {modkey},
        'a',
        function()
            awful.spawn(
                awful.screen.focused().selected_tag.default_app,
                {
                    tag = _G.mouse.screen.selected_tag,
                    placement = awful.placement.bottom_right
                }
            )
        end,
        {description = 'Open default program for tag/workspace', group = 'Launcher'}
    ),
    awful.key(
        {modkey},
        'v',
        function()
            _G.toggle_quake()
        end,
        {description = 'Dropdown terminal', group = 'Launcher'}
    ),
    awful.key(
        {modkey, 'Control'},
        'z',
        function()
            awful.spawn(apps.default.custom_script)
        end,
        {description = 'Run custom script', group = 'Launcher'}
    ),

        -- Widgets

    awful.key(
        {modkey},
        '.',
        function()
            awful.spawn(apps.default.rofi_emoji)
        end,
        {description = "Show emoji picker", group = 'Widgets'}
    ),
    awful.key(
        {modkey},
        ',',
        function()
            awful.spawn(apps.default.rofi_calc)
        end,
        {description = "Show calculator widget", group = 'Widgets'}
    ),
    awful.key(
        {modkey},
        'g',
        function()
            awful.spawn(apps.default.rofi_internet)
        end,
        {description = "Show internet menu", group = 'Widgets'}
    ),
    awful.key(
        {modkey},
        'k',
        function()
            awful.spawn(apps.default.rofi_translate)
        end,
        {description = "Show translate widget", group = 'Widgets'}
    ),
    awful.key(
        {modkey, 'Control'},
        "Prior",
        function()
            _G.change_song('previous', true)
        end,
        {description = "Play previous music", group = "Widgets"}
    ),
    awful.key(
        {modkey, 'Control'},
        "Next",
        function()
            _G.change_song('next', true)
        end,
        {description = "Play next music", group = "Widgets"}
    ),
    awful.key(
        {modkey, 'Control'},
        "Home",
        function()
            _G.parameter_song('play')
        end,
        {description = "Play music", group = "Widgets"}
    ),
    awful.key(
        {modkey, 'Control'},
        "End",
        function()
            _G.parameter_song('pause')
        end,
        {description = "Stop music", group = "Widgets"}
    ),
    awful.key(
        {modkey},
        'n',
        function()
            _G.toggle_notification_center()
        end,
        {description = "Toggle notification center", group = "Widgets"}
    ),
    awful.key(
        {modkey},
        '\'',
        function()
            toggle_layout_list()
        end
    ),

        -- ALSA volume control

    awful.key(
        {'Control', modkey},
        'Up',
        function()
            _G.update_volume('+5')
        end,
        {description = 'Volume up', group = 'Hotkeys'}
    ),
    awful.key(
        {'Control', modkey},
        'Down',
        function()
            _G.update_volume('-5')
        end,
        {description = 'Volume down', group = 'Hotkeys'}
    ),
    awful.key(
        {'Control', modkey},
        'm',
        function()
            _G.update_volume('toggle')
        end,
        {description = 'Toggle mute', group = 'Hotkeys'}
    )
)

for i = 1, 9 do
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = 'view tag #', group = 'Tag'}
        descr_toggle = {description = 'toggle tag #', group = 'Tag'}
        descr_move = {description = 'move focused client to tag #', group = 'Tag'}
        descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'Tag'}
    end

    global_keys = awful.util.table.join(
        global_keys,
            -- View tag only.
        awful.key(
            {modkey},
            '#' .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    _G.change_tag(
                        function()
                            tag:view_only()
                        end
                    )
                end
            end,
            descr_view
        ),
            -- Toggle tag display.
        awful.key(
            {modkey, 'Control'},
            '#' .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    _G.change_tag(
                        function()
                            awful.tag.viewtoggle(tag)
                        end
                    )
                end
            end,
            descr_toggle
        ),
            -- Move client to tag.
        awful.key(
            {modkey, 'Shift'},
            '#' .. i + 9,
            function()
                if _G.client.focus then
                    local tag = _G.client.focus.screen.tags[i]
                    if tag then
                        _G.change_tag(
                            function()
                                _G.client.focus:move_to_tag(tag)
                                tag:view_only()
                            end
                        )
                    end
                end
            end,
            descr_move
        ),
            -- Toggle tag on focused client.
        awful.key(
            {modkey, 'Control', 'Shift'},
            '#' .. i + 9,
            function()
                if _G.client.focus then
                    local tag = _G.client.focus.screen.tags[i]
                    if tag then
                        _G.client.focus:toggle_tag(tag)
                    end
                end
            end,
            descr_toggle_focus
        )
    )
end

local strings = {"87", "88", "89", "83", "84", "85", "79", "80", "81"}
for i, key in ipairs(strings) do
    global_keys = awful.util.table.join(
        global_keys,
            -- View tag only.
        awful.key(
            {modkey},
            '#' .. key,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    _G.change_tag(
                        function()
                            tag:view_only()
                        end
                    )
                end
            end,
            {description = nil, group = nil}
        ),
            -- Toggle tag display.
        awful.key(
            {modkey, 'Control'},
            '#' .. key,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    _G.change_tag(
                        function()
                            awful.tag.viewtoggle(tag)
                        end
                    )
                end
            end,
            {description = nil, group = nil}
        ),
            -- Move client to tag.
        awful.key(
            {modkey, 'Shift'},
            '#' .. key,
            function()
                if _G.client.focus then
                    local tag = _G.client.focus.screen.tags[i]
                    if tag then
                        _G.change_tag(
                            function()
                                _G.client.focus:move_to_tag(tag)
                                tag:view_only()
                            end
                        )
                    end
                end
            end,
            {description = nil, group = nil}
        ),
            -- Toggle tag on focused client.
        awful.key(
            {modkey, 'Control', 'Shift'},
            '#' .. key,
            function()
                if _G.client.focus then
                    local tag = _G.client.focus.screen.tags[i]
                    if tag then
                        _G.client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = nil, group = nil}
        )
    )
end

return global_keys

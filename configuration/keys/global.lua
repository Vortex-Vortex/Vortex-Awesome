local awful = require('awful')
require('awful.autofocus')
local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local apps   = require('configuration.apps')
local top_panel = require('layout.top-panel')

-- Key Bindings
local globalKeys = awful.util.table.join(

        -- Hotkeys
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
    awful.key(
        {modkey},
        'z',
        function()
            for s in screen do
                s.top_panel.visible = not s.top_panel.visible
            end
        end,
        {description = "Toggle On/Off Top Bar", group = "Awesome WM"}
    ),
    awful.key(
        {modkey},
        'F1',
        hotkeys_popup.show_help,
        {description = "Show help menu", group = "Awesome WM"}
    ),
    awful.key(
        {modkey},
        'r',
        function()
            awful.spawn(apps.default.rofi)
        end,
        {description = 'Show main menu', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        '.',
        function()
            awful.spawn(apps.default.rofi_emoji)
        end,
        {description = 'Show emoji picker', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        ',',
        function()
            awful.spawn(apps.default.rofi_calc)
        end,
        {description = 'Show calculator', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        'g',
        function()
            awful.spawn(apps.default.rofi_internet)
        end,
        {description = 'Show internet menu', group = 'Awesome WM'}
    ),
    awful.key(
        {altkey},
        'space',
        function()
            awful.spawn(apps.default.rofi)
        end,
        {description = 'Show main menu', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'r',
        function()
            awful.spawn('reboot')
        end,
        {description = 'Reboot Computer', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Shift'},
        's',
        function()
            awful.spawn('shutdown now')
        end,
        {description = 'Shutdown Computer', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'l',
        function()
            _G.exit_screen_show()
        end,
        {description = 'Log Out Screen', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey},
        'l',
        function()
            awful.spawn(apps.default.lock)
        end,
        {description = 'Lock the screen', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Control'},
        'r',
        _G.awesome.restart,
        {description = 'Reload awesome', group = 'Awesome WM'}
    ),
    awful.key(
        {modkey, 'Control'},
        'q',
        _G.awesome.quit,
        {description = 'Kill awesome', group = 'Awesome WM'}
    ),

        -- Tag Management
    awful.key(
        {modkey},
        'w',
        function()
            _G.clients_on_tag_change(function() awful.tag.viewprev() end)
        end,
        {description = 'View previous', group = 'Tag'}
    ),
    awful.key(
        {modkey},
        's',
        function()
            _G.clients_on_tag_change(function() awful.tag.viewnext() end)
        end,
        {description = 'View next', group = 'Tag'}
    ),
    awful.key(
        {altkey, 'Control'},
        'Up',
        awful.tag.viewprev,
        {description = 'View previous', group = 'Tag'}
    ),
    awful.key(
        {altkey, 'Control'},
        'Down',
        awful.tag.viewnext,
        {description = 'View next', group = 'Tag'}
    ),
    awful.key(
        {modkey},
        'Escape',
        function()
            _G.clients_on_tag_change(function() awful.tag.history.restore() end)
        end,
        {description = 'Go back', group = 'Tag'}
    ),
    awful.key(
        {modkey},
        '#90',
        function()
            _G.clients_on_tag_change(function() awful.tag.history.restore() end)
        end,
        {description = 'Go back', group = 'Tag'}
    ),
    awful.key(
        {modkey},
        '#86',
        awful.tag.viewnext,
        {description = 'View next', group = 'Tag'}
    ),
    awful.key(
        {modkey},
        '#82',
        awful.tag.viewprev,
        {description = 'View previous', group = 'Tag'}
    ),

        -- Client/Window management
    awful.key(
        {modkey},
        'd',
        function()
            awful.client.focus.byidx(1)
        end,
        {description = 'Focus next by index', group = 'Client'}
    ),
    awful.key(
        {modkey},
        'a',
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = 'Focus previous by index', group = 'Client'}
    ),
    awful.key(
        {modkey},
        'u',
        awful.client.urgent.jumpto,
        {description = 'Jump to urgent client', group = 'Client'}
    ),
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
        'y',
        function ()
            local c = client.focus
            if c then
                c.sticky = not c.sticky
            end
        end,
        {description = "Toggle always on top", group = 'Client'}
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
        {modkey, "Control"},
        "space",
        function ()
            client.focus.ontop = not client.focus.ontop
            awful.client.floating.toggle()
        end,
        {description = "Toggle floating", group = "Client"}
    ),

        -- Screenshot Usage
    awful.key(
        {modkey},
        'Print',
        function()
            awful.spawn.with_shell(apps.default.delayed_screenshot)
        end,
        {description = 'Screenshot with 10 seconds delay', group = 'Screenshots'}
    ),
    awful.key(
        {modkey},
        'p',
        function()
            awful.spawn.with_shell(apps.default.screenshot)
        end,
        {description = 'Take a screenshot of your active monitor', group = 'Screenshots'}
    ),
    awful.key(
        {},
        'Print',
        function()
            awful.spawn.with_shell(apps.default.region_screenshot)
        end,
        {description = 'Mark an area and screenshot it', group = 'Screenshots'}
    ),
    awful.key(
        {modkey, "Control"},
        'p',
        function()
            awful.spawn.easy_async_with_shell(apps.default.pip_screenshot_1, function()
                    awful.spawn.easy_async_with_shell('ls -t /tmp/png | head -1', function(stdout)
                        awful.spawn.with_shell('feh /tmp/png/' .. string.gsub(stdout, "\n", "") .. ' --title "Picture-in-Picture"')
                    end)
            end)
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
        {modkey, "Shift"},
        'p',
        function()
            awful.spawn.with_shell(apps.default.color_picker)
        end,
        {description = 'Open color picker app and return a HEX value', group = 'Screenshots'}
    ),

        -- Launch Programs
    awful.key(
        {modkey},
        'c',
        function()
            awful.spawn(apps.default.editor)
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
        'a',
        function()
            awful.spawn(
                awful.screen.focused().selected_tag.defaultApp,
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
        'e',
        function()
            awful.spawn(apps.default.files)
        end,
        {description = 'Filebrowser', group = 'Launcher'}
    ),
    awful.key(
        {modkey},
        'v',
        function()
            _G.toggle_quake()
        end,
        {description = 'Dropdown application', group = 'Launcher'}
    ),

        -- Widgets
    awful.key(
        {modkey},
        "k",
        function()
            _G.launch_translate()
        end,
        {description = "Run translate prompt", group = "Widgets"}
    ),
    awful.key(
        {modkey},
        "#112",
        function()
            _G.music_control('r')
        end,
        {description = "Play Previous Music", group = "Widgets"}
    ),
    awful.key(
        {modkey},
        "#117",
        function()
            _G.music_control('n')
        end,
        {description = "Play Next Music", group = "Widgets"}
    ),
    awful.key(
        {modkey},
        'n',
        function()
            _G.toggle_notification_center()
        end,
        {description = "Show/Hide Notification Center", group = "Widgets"}
    ),


        -- Layout Management
    awful.key(
        {altkey, 'Shift'},
        'Right',
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = 'Increase master width factor', group = 'Layout'}
    ),
    awful.key(
        {altkey, 'Shift'},
        'Left',
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = 'Decrease master width factor', group = 'Layout'}
    ),
    awful.key(
        {altkey, 'Shift'},
        'Down',
        function()
            awful.client.incwfact(0.05)
        end,
        {description = 'Decrease master height factor', group = 'Layout'}
    ),
    awful.key(
        {altkey, 'Shift'},
        'Up',
        function()
            awful.client.incwfact(-0.05)
        end,
        {description = 'Increase master height factor', group = 'Layout'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'Left',
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = 'Increase the number of master clients', group = 'Layout'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'Right',
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = 'Decrease the number of master clients', group = 'Layout'}
    ),
    awful.key(
        {modkey, 'Control'},
        'Left',
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = 'Increase the number of columns', group = 'Layout'}
    ),
    awful.key(
        {modkey, 'Control'},
        'Right',
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = 'Decrease the number of columns', group = 'Layout'}
    ),
    awful.key(
        {modkey},
        'space',
        function()
            awful.layout.inc(1)
        end,
        {description = 'Select next', group = 'Layout'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'space',
        function()
            awful.layout.inc(-1)
        end,
        {description = 'Select previous', group = 'Layout'}
    ),

        -- Brightness
    awful.key(
        {},
        'XF86MonBrightnessUp',
        function()
            awful.spawn('xbacklight -inc 10')
        end,
        {description = '+10%', group = 'Hotkeys'}
    ),
    awful.key(
        {},
        'XF86MonBrightnessDown',
        function()
            awful.spawn('xbacklight -dec 10')
        end,
        {description = '-10%', group = 'Hotkeys'}
    ),

        -- ALSA volume control
    awful.key(
        {'Control', modkey},
        'Up',
        function()
            _G.volume_control('up', 5)
        end,
        {description = 'Volume up', group = 'Hotkeys'}
    ),
    awful.key(
        {'Control', modkey},
        'Down',
        function()
            _G.volume_control('down', 5)
        end,
        {description = 'Volume down', group = 'Hotkeys'}
    ),
    awful.key(
        {'Control', modkey},
        'm',
        function()
            awful.spawn('amixer -D pipewire set Master toggle')
        end,
        {description = 'Toggle mute', group = 'Hotkeys'}
    )
--[[
        -- Deprecated for desktop PC
    awful.key(
        {},
        'XF86AudioNext',
        function()
            --
        end,
        {description = 'toggle mute', group = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86PowerDown',
        function()
            --
        end,
        {description = 'toggle mute', group = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86PowerOff',
        function()
            _G.exit_screen_show()
        end,
        {description = 'toggle mute', group = 'hotkeys'}),
]]
)

for i = 1, 9 do
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = 'view tag #', group = 'Tag'}
        descr_toggle = {description = 'toggle tag #', group = 'Tag'}
        descr_move = {description = 'move focused client to tag #', group = 'Tag'}
        descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'Tag'}
    end

    globalKeys = awful.util.table.join(
        globalKeys,
            -- View tag only.
        awful.key(
            {modkey},
            '#' .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    _G.clients_on_tag_change(function() tag:view_only() end, tag)
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
                    awful.tag.viewtoggle(tag)
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
                        _G.client.focus:move_to_tag(tag)
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
    globalKeys = awful.util.table.join(
        globalKeys,
            -- View tag only.
        awful.key(
            {modkey},
            '#' .. key,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    _G.clients_on_tag_change(function() tag:view_only() end, tag)
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
                    awful.tag.viewtoggle(tag)
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
                        _G.client.focus:move_to_tag(tag)
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

return globalKeys

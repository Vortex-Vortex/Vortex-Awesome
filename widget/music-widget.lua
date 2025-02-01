local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')

local icons = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local function Music_widget(s)
    local screen_width = s.geometry.width
    local player = 'pragha'

    local popup_set_timer

    local shuffle_off_icon = gears.color.recolor_image(icons.shuffle_icon, beautiful.bg_neutral)
    local shuffle_on_icon = gears.color.recolor_image(icons.shuffle_icon, beautiful.border_focus)
    local loop_off_icon = gears.color.recolor_image(icons.loop_icon, beautiful.bg_neutral)
    local loop_on_icon = gears.color.recolor_image(icons.loop_icon, beautiful.border_focus)
    local volume_full_icon = gears.color.recolor_image(icons.volume_full_icon, beautiful.bg_neutral)
    local volume_muted_icon = gears.color.recolor_image(icons.volume_muted_icon, beautiful.bg_neutral)

    local popup = awful.popup{
        ontop = true,
        visible = false,
        shape = gears.shape.rectangle,
        x = screen_width - 450,
        y = 50,
        maximum_width = 400,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
        widget = {}
    }

    local music_widget = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                widget = wibox.container.place,
                {
                    widget = wibox.widget.imagebox,
                    image = icons.music_icon
                },
                halign = 'center',
                valign ='center'
            },
            forced_height = 25,
            forced_width = 29,
            left = 2,
            right = 2
        }
    )

    local popup_header = wibox.widget{
        widget = wibox.container.margin,
        {
            widget = wibox.container.background,
            {
                layout = wibox.layout.align.horizontal,
                nil,
                {
                    widget = wibox.widget.textbox,
                    text = 'Music Controller: ' .. player,
                    font = beautiful.system_font .. 'Bold 16',
                    align = 'center',
                    valign = 'center'
                },
                {
                    widget = wibox.container.margin,
                    {
                        widget = wibox.widget.imagebox,
                        image = icons.music_icon
                    },
                    margins = 5
                }
            },
            shape = gears.shape.rectangle,
            shape_border_width = beautiful.border_width + 1,
            shape_border_color = beautiful.border_normal,
            forced_height = 40
        },
        margins = 5
    }

    local song_album_image = wibox.widget{
        widget = wibox.widget.imagebox,
        image = icons.music_album_icon,
        forced_height = 120
    }
    local song_album_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = '--',
        align = 'center',
        valign = 'center',
        font = beautiful.system_font .. 'bold 12'
    }
    local song_album_track_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = '0',
        align = 'center',
        valign = 'center',
        font = beautiful.system_font .. 'mono 10',
        forced_width = 45,
        forced_height = 30
    }

    local album_row = wibox.widget{
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
                widget = wibox.container.background,
                song_album_image,
                shape = gears.shape.rectangle,
                shape_border_width = beautiful.border_width,
                shape_border_color = beautiful.border_focus
            },
            {
                widget = wibox.container.background,
                {
                    widget = wibox.container.margin,
                    song_album_textbox,
                    margins = 4
                },
                bg = beautiful.bg_primary_subtle,
                shape = gears.shape.rectangle,
                shape_border_width = beautiful.border_width_reduced,
                shape_border_color = beautiful.border_secondary
            }
        },
        {
            widget = wibox.container.place,
            {
                widget = wibox.container.background,
                song_album_track_textbox,
                shape = gears.shape.rectangle,
                shape_border_width = beautiful.border_width_reduced,
                shape_border_color = beautiful.border_secondary
            },
            halign = 'right',
            valign = 'bottom'
        }
    }

    local song_title_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = '--',
        align = 'center',
        valign = 'bottom',
        font = beautiful.system_font .. 'bold 12',
        forced_height = 25
    }
    local song_artist_textbox = wibox.widget{
        widget = wibox.container.background,
        {
            widget = wibox.widget.textbox,
            id = 'artist_id',
            text = '--',
            align = 'center',
            valign = 'top',
            font = beautiful.system_font .. '9',
            forced_height = 20
        },
        fg = beautiful.bg_neutral
    }

    local song_slider_handle = wibox.widget{
        widget = wibox.widget.slider,
        bar_height = 0,
        handle_color = beautiful.fg_color,
        handle_shape = gears.shape.circle,
        handle_width = 8,
        handle_border_width = 0,
        value = 50,
        maximum = 100,
        minimum = 0
    }
    local song_slider_bar = wibox.widget{
        widget = wibox.widget.progressbar,
        max_value = 100,
        value = 50
    }
    local song_slider_lenght = wibox.widget{
        widget = wibox.widget.textbox,
        text = '00:00',
        align = 'center',
        valign = 'center',
        font = beautiful.system_font .. 'mono 9'
    }
    local song_slider_position = wibox.widget{
        widget = wibox.widget.textbox,
        text = '00:00',
        align = 'center',
        valign = 'center',
        font = beautiful.system_font .. 'mono 9'
    }

    local song_slider = wibox.widget{
        widget = wibox.container.margin,
        {
            layout = wibox.layout.align.horizontal,
            {
                widget = wibox.container.margin,
                song_slider_position,
                right = 3
            },
            {
                layout = wibox.layout.stack,
                forced_height = 15,
                {
                    widget = wibox.container.margin,
                    song_slider_bar,
                    top = 6,
                    bottom = 6
                },
                song_slider_handle
            },
            {
                widget = wibox.container.margin,
                song_slider_lenght,
                left = 3
            },
        },
        left = 10,
        right = 10
    }

    local player_status_bar = wibox.widget{
        widget = wibox.container.place,
        {
            layout = wibox.layout.fixed.horizontal,
            id = 'container_id',
            spacing = 35,
            forced_height = 45,
            {
                widget = wibox.container.margin,
                id = 'shuffle_container_id',
                {
                    widget = wibox.widget.imagebox,
                    id = 'shuffle_id',
                    image = shuffle_off_icon
                },
                margins = 10
            },
            {
                widget = wibox.container.margin,
                id = 'status_container_id',
                {
                    widget = wibox.widget.imagebox,
                    id = 'status_id',
                    image = icons.play_icon
                },
                margins = 3
            },
            {
                widget = wibox.container.margin,
                id = 'loop_container_id',
                {
                    widget = wibox.widget.imagebox,
                    id = 'loop_id',
                    image = loop_off_icon
                },
                margins = 10
            }
        },
        halign = 'center',
        valign = 'center'
    }

    local volume_slider_handle = wibox.widget{
        widget = wibox.widget.slider,
        bar_height = 0,
        handle_color = beautiful.fg_color,
        handle_shape = gears.shape.circle,
        handle_width = 5,
        handle_border_width = 0,
        value = 50,
        maximum = 100,
        minimum = 0
    }
    local volume_slider_bar = wibox.widget{
        widget = wibox.widget.progressbar,
        max_value = 100,
        value = 50
    }

    local volume_slider = wibox.widget{
        layout = wibox.layout.flex.horizontal,
        forced_height = 20,
        {
            widget = wibox.container.background
        },
        {
            layout = wibox.layout.align.horizontal,
            {
                widget = wibox.widget.imagebox,
                image = volume_muted_icon
            },
            {
                widget = wibox.container.margin,
                {
                    layout = wibox.layout.stack,
                    {
                        widget = wibox.container.margin,
                        volume_slider_bar,
                        top = 6,
                        bottom = 6
                    },
                    volume_slider_handle
                },
                top = 3,
                bottom = 3
            },
            {
                widget = wibox.widget.imagebox,
                image = volume_full_icon
            }
        },
        {
            widget = wibox.container.background
        }
    }

    popup:setup(
        {
            layout = wibox.layout.fixed.vertical,
            popup_header,
            album_row,
            song_title_textbox,
            song_artist_textbox,
            song_slider,
            player_status_bar,
            volume_slider
        }
    )

    local function update_position(offset)
        if not offset then
            awful.spawn.easy_async(
                'playerctl -p ' .. player .. ' position',
                function(stdout)
                    if string.find(stdout, '%w') then
                        stdout = string.gsub(stdout, '\n', '')
                        song_slider_handle.value = tonumber(stdout)
                        song_slider_bar.value = tonumber(stdout)
                    end
                end
            )
        else
            local sig, num = string.match(offset, '^(.)(%d+)$')
            awful.spawn('playerctl -sp ' .. player .. ' position ' .. num .. sig)
            if sig == '+' then
                song_slider_handle.value = song_slider_handle.value + num - 1
            else
                song_slider_handle.value = song_slider_handle.value - num - 1
            end
            song_slider_bar.value = song_slider_handle.value
        end
        local minutes = math.floor(song_slider_handle.value / 60)
        local seconds = math.floor(song_slider_handle.value % 60)
        song_slider_position.text = string.format('%02d:%02d', minutes, seconds)
    end

    local function update_volume(offset)
        if not offset then
            awful.spawn.easy_async(
                'playerctl -p ' .. player .. ' volume',
                function(stdout)
                    cur_volume = string.gsub(stdout, '\n', '')
                    volume_slider_handle.value = cur_volume * 100
                    volume_slider_bar.value = cur_volume * 100
                end
            )
        else
            local sig, num = string.match(offset, '^(.)(%d+)$')
            awful.spawn('playerctl -sp ' .. player .. ' volume ' .. num / 100 .. sig)
            if sig == '+' then
                volume_slider_handle.value = volume_slider_handle.value + num
            else
                volume_slider_handle.value = volume_slider_handle.value - num
            end
            volume_slider_bar.value = volume_slider_handle.value
        end
    end

    function change_song(side, external)
        awful.spawn('playerctl -sp ' .. player .. ' ' .. side)
        if external then
            popup_set_timer()
        end
    end

    function parameter_song(parameter, get_only)
        local change = not get_only
        local new_status = ''
        if parameter == 'shuffle' then
            awful.spawn.easy_async(
                'playerctl -p ' .. player .. ' shuffle',
                function(stdout)
                    if change then awful.spawn('playerctl -sp ' .. player .. ' shuffle toggle') end
                    if string.gsub(stdout, '\n', '') == 'On' then
                        player_status_bar.container_id.shuffle_container_id.shuffle_id.image = change and shuffle_off_icon or shuffle_on_icon
                    else
                        player_status_bar.container_id.shuffle_container_id.shuffle_id.image = change and shuffle_on_icon or shuffle_off_icon
                    end
                end
            )
        elseif parameter == 'loop' then
            awful.spawn.easy_async(
                'playerctl -p ' .. player .. ' loop',
                function(stdout)
                    if string.gsub(stdout, '\n', '') == 'Playlist' then
                        player_status_bar.container_id.loop_container_id.loop_id.image = change and loop_off_icon or loop_on_icon
                        new_status = 'None'
                    else
                        player_status_bar.container_id.loop_container_id.loop_id.image = change and loop_on_icon or loop_off_icon
                        new_status = 'Playlist'
                    end
                    if change then awful.spawn('playerctl -sp ' .. player .. ' loop ' .. new_status) end
                end
            )
        elseif parameter == 'play-pause' then
            awful.spawn.easy_async(
                'playerctl -p ' .. player .. ' status',
                function(stdout)
                    if change then awful.spawn('playerctl -sp ' .. player .. ' play-pause') end
                    if string.gsub(stdout, '\n', '') == 'Playing' then
                        player_status_bar.container_id.status_container_id.status_id.image = change and icons.play_icon or icons.pause_icon
                    else
                        player_status_bar.container_id.status_container_id.status_id.image = change and icons.pause_icon or icons.play_icon
                    end
                end
            )
        elseif parameter == 'play' or parameter == 'pause' then
            awful.spawn('playerctl -sp ' .. player .. ' ' .. parameter)
            player_status_bar.container_id.status_container_id.status_id.image = parameter == 'play' and icons.pause_icon or icons.play_icon
            popup_set_timer()
        elseif parameter == nil then
            parameter_song('shuffle', true)
            parameter_song('loop', true)
            parameter_song('play-pause', true)
        end
    end

    local function update_song_data(title, artist, album_name, length, track, album_image)
        album_image = album_image or ''
        song_title_textbox.text = title or '--'
        song_artist_textbox.artist_id.text = artist or '--'
        song_album_textbox.text = album_name or '--'
        song_album_track_textbox.text = track or 0

        local minutes = math.floor(length / 60)
        local seconds = length % 60
        song_slider_lenght.text = string.format('%02d:%02d', minutes, seconds)
        update_position()
        song_slider_handle.maximum = tonumber(length) or 60
        song_slider_bar.max_value = tonumber(length) or 60
        awful.spawn.easy_async_with_shell(
            'python3 -c "from urllib.parse import unquote; print(unquote(\\\"' .. album_image .. '\\\"))"',
            function(stdout)
                local stdout = string.gsub(stdout, '\n', '')
                song_album_image.image = gears.filesystem.file_readable(stdout) and stdout or icons.music_album_icon
            end
        )
    end

    local function follow_player()
        local first_line = true
        awful.spawn.with_line_callback(
            'playerctl -p ' .. player .. ' -F metadata -f "{{title}}||{{artist}}|{{album}}||{{mpris:length}}|{{xesam:trackNumber}}||{{mpris:artUrl}}"',
            {
                stdout = function(line)
                    if first_line then
                        update_volume()
                        parameter_song()
                        first_line = false
                    end
                    if gears.string.startswith(line, '|') then return end
                    local title, artist, album_name, length, track, album_image = string.match(line, '^(.*)||(.*)|(.*)||(.*)000000|(.*)||(.*)$')
                    update_song_data(title, artist, album_name, length, track, album_image:gsub('^file://', ''))
                    parameter_song('play-pause', true)
                end
            }
        )
    end

    music_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    change_song('previous')
                end
            ),
            awful.button(
                {},
                2,
                function()
                    parameter_song('play-pause')
                end
            ),
            awful.button(
                {},
                3,
                function()
                    change_song('next')
                end
            ),
            awful.button(
                {},
                4,
                function()
                    update_volume('+5')
                end
            ),
            awful.button(
                {'Shift'},
                4,
                function()
                    update_position('+10')
                end
            ),
            awful.button(
                {},
                5,
                function()
                    update_volume('-10')
                end
            ),
            awful.button(
                {'Shift'},
                5,
                function()
                    update_position('-5')
                end
            ),
            awful.button(
                {},
                9,
                function()
                    parameter_song('loop')
                end
            ),
            awful.button(
                {},
                8,
                function()
                    parameter_song('shuffle')
                end
            )
        )
    )

    local position_timer = gears.timer{
        timeout = 1,
        callback = function()
            update_position()
        end,
        call_now = true
    }

    local popup_timer = gears.timer{
        timeout = 1,
        callback = function()
            popup.visible = false
            position_timer:stop()
        end,
        single_shot = true
    }

    local not_following = true
    function popup_set_timer()
        if not_following then
            follow_player()
            not_following = false
        end
        if not position_timer.started then position_timer:start() end
        update_position()
        popup.visible = true
        if popup_timer.started then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end

    music_widget:connect_signal("mouse::enter", function()
        if not_following then
            follow_player()
            not_following = false
        end
        if not position_timer.started then position_timer:start() end
        update_position()
        popup.visible = true
        if popup_timer.started then popup_timer:stop() end
    end)
    music_widget:connect_signal("mouse::leave", function()
        if popup_timer.started then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end)

    return music_widget
end
return Music_widget

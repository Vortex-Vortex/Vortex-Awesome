local awful               = require('awful')
local gears               = require('gears')
local beautiful           = require('beautiful')
local wibox               = require('wibox')
local icons               = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local ALBUM_COVER_DIR = os.getenv('HOME') .. '/.cache/pragha/'

local function music_widget_call(s)
    local width = s.geometry.width
    local rows = {
        layout = wibox.layout.fixed.vertical
    }
    local popup = awful.popup{
        ontop   = true,
        visible = false,
        shape   = gears.shape.rectangle,
        x       = width - 450,
        y       = 50,
        maximum_width = 400,
        border_width  = beautiful.border_width,
        border_color  = beautiful.border_focus,
        widget = {}
    }

    music_widget = clickable_container(wibox.widget{
        {
            wibox.widget{
                widget = wibox.widget.imagebox,
                image = icons.music
            },
            widget = wibox.container.place,
            align = 'center',
            valign = 'center'
        },
        widget        = wibox.container.margin,
        forced_height = 25,
        forced_width  = 25,
    })

    local first_row = wibox.widget{
        {
            {
                text  = 'Music Status',
                font  = 'Roboto Mono bold 12',
                align = 'center',
                forced_width  = 350,
                forced_height = 40,
                widget        = wibox.widget.textbox
            },
            {
                {
                    wibox.widget{
                        widget = wibox.widget.imagebox,
                        image  = icons.music
                    },
                    widget = wibox.container.place,
                    align  = 'center',
                    valign = 'center'
                },
                widget        = wibox.container.margin,
                forced_height = 40,
                forced_width  = 50,
                margins       = 7
            },
            spacing = 8,
            layout  = wibox.layout.fixed.horizontal
        },
        bg                 = beautiful.bg_normal,
        shape              = gears.shape.rectangle,
        shape_border_color = beautiful.border_normal,
        shape_border_width = beautiful.border_width + 1,
        widget             = wibox.container.background
    }

    local function create_textbox(args)
        return wibox.widget{
            widget        = wibox.widget.textbox,
            text          = args.text or '--',
            font          = args.font or nil,
            align         = args.align or 'center',
            valign        = args.valign or 'center',
            forced_height = args.forced_height or nil,
            forced_width  = args.forced_width or nil,
        }
    end

    local function encapsulate_left_box(given_widget)
        return wibox.widget{
            {
                given_widget,
                shape              = gears.shape.rectangle,
                shape_border_color = beautiful.border_normal,
                shape_border_width = beautiful.border_width + 1,
                widget             = wibox.container.background
            },
            bg = beautiful.bg_normal,
            shape              = gears.shape.rectangle,
            shape_border_color = beautiful.border_focus,
            shape_border_width = beautiful.border_width - 1,
            widget             = wibox.container.background
        }
    end

    local function encapsulate_right_box(given_widget)
        return wibox.widget{
            given_widget,
            widget             = wibox.container.background,
            bg                 = beautiful.bg_primary_subtle,
            shape              = gears.shape.rectangle,
            shape_border_color = beautiful.border_secondary,
            shape_border_width = beautiful.border_width -1
        }
    end
    table.insert(rows, first_row)

    row_status_icon = wibox.widget.imagebox()
    row_status_text = create_textbox({})
    row_status_icon_closed = wibox.widget{
        {
            row_status_icon,
            widget = wibox.container.place,
            align  = 'center',
            valign = 'center'
        },
        widget        = wibox.container.margin,
        forced_height = 40,
        forced_width  = 80,
        margins       = 7
    }

    row_status = wibox.widget{
        encapsulate_left_box(row_status_icon_closed),
        encapsulate_right_box(row_status_text),
        layout = wibox.layout.align.horizontal
    }
    table.insert(rows, row_status)

    row_artist_text = create_textbox({})
    row_artist = wibox.widget{
        encapsulate_left_box(
            create_textbox({
                text = '  Artist:  ',
                font  = 'Roboto Mono bold 12',
                align = 'center',
                valign = 'center',
                forced_height = 40,
                forced_width  = 80,
            })
        ),
        encapsulate_right_box(row_artist_text),
        layout = wibox.layout.align.horizontal
    }
    table.insert(rows, row_artist)

    row_music_text = create_textbox({})
    row_music = wibox.widget{
        encapsulate_left_box(
            create_textbox({
                text = '  Music:  ',
                font  = 'Roboto Mono bold 12',
                align = 'center',
                valign = 'center',
                forced_height = 40,
                forced_width  = 80,
            })
        ),
        encapsulate_right_box(row_music_text),
        layout = wibox.layout.align.horizontal
    }
    table.insert(rows, row_music)

    row_length_text = create_textbox({})
    row_length = wibox.widget{
        encapsulate_left_box(
            create_textbox({
                text = '  Length:  ',
                font  = 'Roboto Mono bold 12',
                align = 'center',
                valign = 'center',
                forced_height = 40,
                forced_width  = 80,
            })
        ),
        encapsulate_right_box(row_length_text),
        layout = wibox.layout.align.horizontal
    }
    row_track_text = create_textbox({})
    row_track = wibox.widget{
        encapsulate_left_box(
            create_textbox({
                text = '  Track:  ',
                font  = 'Roboto Mono bold 12',
                align = 'center',
                valign = 'center',
                forced_height = 40,
                forced_width  = 80,
            })
        ),
        encapsulate_right_box(row_track_text),
        layout = wibox.layout.align.horizontal
    }
    row_length_track = wibox.widget{
        row_length,
        row_track,
        layout = wibox.layout.flex.horizontal
    }
    table.insert(rows, row_length_track)

    row_album_cover = wibox.widget.imagebox()
    row_album_cover.forced_height = 120
    row_album_text = create_textbox({})
    row_album_cover_closed = wibox.widget{
        {
            row_album_cover,
            widget = wibox.container.place,
            align  = 'center',
            valign = 'center'
        },
        widget        = wibox.container.margin,
        margins       = 0
    }

    row_album = wibox.widget{
        encapsulate_left_box(row_album_cover_closed),
        {
            encapsulate_left_box(
                create_textbox({
                    text = '  Album:  ',
                    font  = 'Roboto Mono bold 12',
                    align = 'center',
                    forced_height = 40,
                    forced_width  = 80,
                })
            ),
            encapsulate_right_box(row_album_text),
            layout = wibox.layout.align.vertical
        },
        layout = wibox.layout.align.horizontal
    }
    table.insert(rows, row_album)
    popup:setup(rows)

    local function formatDuration(seconds)
        local seconds = seconds or 0
        local minutes = math.floor(seconds / 60)
        local remainingSeconds = seconds % 60
        return string.format("%02d:%02d", minutes, remainingSeconds)
    end

    local function update_widget(arg)
        if arg then
            command = 'pragha -' .. arg .. '&& sleep 0.05 && '
        else
            command = ''
        end
            awful.spawn.easy_async_with_shell(command .. [[pragha -c | grep -E "state|title|artist|album|length|track_no"]], function(stdout)
            local state, music, artist, album, track, length = stdout:match('state: ([^\n]*).*title: ([^\n]*).*artist: ([^\n]*).*album: ([^\n]*).*track_no: ([^\n]*).*length: ([^\n]*)')
            if not music and not length then
                row_status_icon.image = icons.stopped
                row_status_text.text  = "No Music Playing"
                row_artist_text.text  = '--'
                row_music_text.text   = '--'
                row_length_text.text  = '--'
                row_track_text.text   = '--'
                row_album_text.text   = '--'
                row_album_cover.image = icons.album_placeholder
            elseif state == "Paused" then
                row_status_icon.image = icons.paused
                row_status_text.text  = "Music Is Paused"
                row_artist_text.text  = artist or '--'
                row_music_text.text   = music
                row_length_text.text  = formatDuration(length)
                row_track_text.text   = track
                row_album_text.text   = album or '--'
                cover_art_path        = ALBUM_COVER_DIR .. 'album-' .. artist .. '-' .. album .. '.jpeg'
                cover_art             = gears.filesystem.file_readable(cover_art_path) and cover_art_path or icons.album_placeholder
                row_album_cover.image = cover_art
            elseif state == "Playing" then
                row_status_icon.image = icons.playing
                row_status_text.text  = "Music Is Playing"
                row_artist_text.text  = artist or '--'
                row_music_text.text   = music
                row_length_text.text  = formatDuration(length)
                row_track_text.text   = track
                row_album_text.text   = album or '--'
                cover_art_path        = ALBUM_COVER_DIR .. 'album-' .. artist .. '-' .. album .. '.jpeg'
                cover_art             = gears.filesystem.file_readable(cover_art_path) and cover_art_path or icons.album_placeholder
                row_album_cover.image = cover_art
            end
        end)
    end

    local popup_timer = gears.timer{
        timeout = 1,
        callback = function()
            popup.visible = false
        end,
        single_shot = true
    }

    music_widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    update_widget('r')
                end
            ),
            awful.button(
                {},
                2,
                function()
                    update_widget('t')
                end
            ),
            awful.button(
                {},
                3,
                function()
                    update_widget('n')
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.spawn.with_shell('pragha -i')
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.spawn.with_shell('pragha -d')
                end
            )
        )
    )

    music_widget:connect_signal("mouse::enter", function()
        update_widget()
        popup.visible = true
        popup_timer:stop()
    end)
    music_widget:connect_signal("mouse::leave", function()
        if popup_timer.started == true then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end)

    music_control = function(command)
        update_widget(command)
        popup.visible = true
        if popup_timer.started == true then
            popup_timer:again()
        else
            popup_timer:start()
        end
    end

    return music_widget
end

return music_widget_call

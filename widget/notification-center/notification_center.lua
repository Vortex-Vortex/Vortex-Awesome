local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')
local naughty   = require('naughty')
local icons     = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')

local close_button = require('widget.material.close-button')

local function notification_center_call(s)
    local width = s.geometry.width
    local notification_queue = {}
    local current_callback = nil
    local update_queue = false
    local notif_counter = 0

    local count_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        font = 'Roboto Mono bold 11',
        text = 0
    }

    local notification_center = clickable_container(wibox.widget{
        {
            {
                {
                    {
                        widget = wibox.widget.imagebox,
                        image = icons.notification_icon
                    },
                    widget = wibox.container.place,
                    align = 'center',
                    valign = 'center'
                },
                widget = wibox.container.margin,
                forced_height = 25,
                forced_width = 25
            },
            count_textbox,
            layout = wibox.layout.fixed.horizontal
        },
        left = 5,
        right = 5,
        widget = wibox.container.margin
    })

    local popup = awful.popup{
        ontop = true,
        visible = false,
        shape = gears.shape.rectangle,
        x = width - 450,
        y = 50,
        maximum_width = 400,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
        widget = {}
    }

    local first_row = wibox.widget{
        {
            widget = wibox.widget.textbox,
            text = 'Notification Center',
            font = 'Roboto Mono bold 14',
            align = 'center',
            forced_height = 40,
            forced_width = 400
        },
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        shape = gears.shape.rectangle,
        shape_border_color = beautiful.border_normal,
        shape_border_width = beautiful.border_width + 1
    }

    local rows = {
        id = "idrows",
        layout = wibox.layout.fixed.vertical
    }

    table.insert(rows, first_row)
    popup:setup(rows)

    local add_to_queue = function(args)
        table.insert(notification_queue, {
            title = args.title or "",
            text = args.text or "",
            icon = args.icon or icons.notification_icon,
            time = args.time or ""
        })
    end

    local update_notification_center = function()
        if not update_queue then
            return
        end
        for _, notification_object in ipairs(notification_queue) do
            local trash_button = close_button()

            local notification_text = wibox.widget{
                widget = wibox.widget.textbox,
                text = notification_object.text,
                font = 'Roboto Mono 10',
                align = 'center',
                forced_height = 60,
                forced_width = 315
            }

            local notification_body = wibox.widget{
                {
                    widget = wibox.widget.textbox,
                    text = notification_object.title,
                    font = 'Roboto Mono bold 12',
                    align = 'center',
                    forced_height = 20,
                    forced_width = 315
                },
                notification_text,
                layout = wibox.layout.fixed.vertical
            }
            notification_body:connect_signal("button::press", function()
                if notification_text.forced_height == 60 then
                    notification_text.forced_height = notification_text:get_height_for_width(315)
                else
                    notification_text.forced_height = 60
                end
            end)

            local row = wibox.widget{
                {
                    {
                        {
                            {
                                {
                                    {
                                        forced_height = 45,
                                        forced_width = 45,
                                        image = notification_object.icon,
                                        widget = wibox.widget.imagebox
                                    },
                                    forced_height = 60,
                                    forced_width = 60,
                                    valign = 'center',
                                    halign = 'center',
                                    widget = wibox.container.place
                                },
                                shape              = gears.shape.rectangle,
                                shape_border_color = beautiful.border_normal,
                                shape_border_width = beautiful.border_width + 1,
                                widget             = wibox.container.background
                            },
                            {
                                {
                                    text = notification_object.time,
                                    font = 'Roboto Mono bold 9',
                                    align = 'center',
                                    valign = 'center',
                                    forced_height = 20,
                                    forced_width = 60,
                                    widget = wibox.widget.textbox
                                },
                                forced_height = 20,
                                forced_width = 60,
                                valign = 'center',
                                halign = 'center',
                                widget = wibox.container.place
                            },
                            layout = wibox.layout.fixed.vertical
                        },
                        bg = beautiful.bg_normal,
                        shape              = gears.shape.rectangle,
                        shape_border_color = beautiful.border_focus,
                        shape_border_width = beautiful.border_width - 1,
                        widget             = wibox.container.background
                    },
                    {
                        notification_body,
                        {
                            {
                                trash_button,
                                widget = wibox.container.margin,
                                forced_height = 25,
                                forced_width  = 25,
                                margins = 1
                            },
                            valign = 'center',
                            layout = wibox.container.place
                        },
                        layout = wibox.layout.align.horizontal
                    },
                    layout = wibox.layout.align.horizontal
                },
                widget = clickable_container(
                    nil,
                    {
                        leave = beautiful.bg_primary_subtle
                    }
                ),
                bg = beautiful.bg_primary_subtle,
                shape              = gears.shape.rectangle,
                shape_border_color = beautiful.border_focus,
                shape_border_width = 0
            }
            row:connect_signal("mouse::enter", function(c)
                c.shape_border_width = beautiful.border_width
            end)
            row:connect_signal("mouse::leave", function(c)
                c.shape_border_width = 0
            end)
            table.insert(rows, 2, row)
            popup.idrows:insert(2, row)

            trash_button:connect_signal("button::press", function()
                popup.idrows:remove_widgets(row)
                popup:emit_signal("widget::updated")

                notif_counter = notif_counter - 1
                count_textbox.text = notif_counter
            end)
        end
        notification_queue = {}
        update_queue = false
    end

    local popup_clicked_on = false
    notification_center:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    if not popup.visible or popup_clicked_on then
                        popup.visible = not popup.visible
                    end
                    popup_clicked_on = popup.visible
                end
            ),
            awful.button(
                {},
                3,
                function()
                    if current_callback then
                        current_callback()
                    end
                end
            )
        )
    )

    notification_center:connect_signal("mouse::enter", function()
        if not popup_clicked_on then
            update_notification_center()
            popup.visible = true
        end
    end)
    notification_center:connect_signal("mouse::leave", function()
        if not popup_clicked_on then
            popup.visible = false
        end
    end)

    toggle_notification_center = function()
        popup.visible = not popup.visible
    end

    local notification_sound = os.getenv('HOME') .. '/.config/awesome/theme/notification.wav'

    notification_call = function(args)
        awful.spawn('aplay ' .. notification_sound)
        update_queue = true
        args.time = os.date("%H:%M:%S")
        add_to_queue(args)
        current_callback = args.callback or args.run
        if popup.visible then
            update_notification_center()
        end
        notif_counter = notif_counter + 1
        count_textbox.text = notif_counter
    end

    return notification_center
end
return notification_center_call

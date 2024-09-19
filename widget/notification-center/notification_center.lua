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
    local notification_data = {}
    local current_callback = nil

    local count_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        font   = 'Roboto Mono bold 11',
        text   = 0
    }

    local notification_center = clickable_container(wibox.widget{
        {
            {
                {
                    wibox.widget{
                        widget = wibox.widget.imagebox,
                        image = icons.notification_icon
                    },
                    widget = wibox.container.place,
                    align = 'center',
                    valign = 'center'
                },
                widget        = wibox.container.margin,
                forced_height = 25,
                forced_width  = 25
            },
            count_textbox,
            layout = wibox.layout.fixed.horizontal
        },
        left = 5,
        right = 5,
        widget = wibox.container.margin
    })

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

    local rows = {
        layout = wibox.layout.fixed.vertical
    }

    local first_row = wibox.widget{
        {
            text  = 'Notification Center',
            font  = 'Roboto Mono bold 14',
            align = 'center',
            forced_height = 40,
            forced_width = 400,
            widget        = wibox.widget.textbox
        },
        bg = beautiful.bg_normal,
        shape              = gears.shape.rectangle,
        shape_border_color = beautiful.border_normal,
        shape_border_width = beautiful.border_width + 1,
        widget = wibox.container.background
    }

    local function update_notification_center()
        for i = 0, #rows do
            rows[i] = nil
        end

        table.insert(rows, first_row)

        for i, notification_object in ipairs(notification_data) do
            if string.find(notification_object.title, "^Flameshot") then
                goto continue
            end
            local trash_button = close_button()
            trash_button:connect_signal("button::press", function()
                table.remove(notification_data, i)
                update_notification_center()
            end)

            local notification_text = wibox.widget{
                text  = notification_object.text,
                font  = 'Roboto Mono 10',
                align = 'center',
                forced_height = 40,
                forced_width = 315,
                widget        = wibox.widget.textbox
            }

            local notification_body = clickable_container(wibox.widget{
                {
                    text  = notification_object.title,
                    font  = 'Roboto Mono bold 12',
                    align = 'center',
                    forced_height = 20,
                    forced_width = 315,
                    widget        = wibox.widget.textbox
                },
                notification_text,
                layout = wibox.layout.fixed.vertical
            })
            notification_body:connect_signal("button::press", function()
                if notification_text.forced_height == 40 then
                    notification_text.forced_height = notification_text:get_height_for_width(315)
                else
                    notification_text.forced_height = 40
                end
            end)

            local row = wibox.widget{
                {
                    {
                        {
                            {
                                forced_height = 45,
                                forced_width = 45,
                                image = notification_object.icon or icons.notification_icon,
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
                    bg = beautiful.bg_normal,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_focus,
                    shape_border_width = beautiful.border_width - 1,
                    widget             = wibox.container.background
                },
                {
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
                    widget             = wibox.container.background,
                    bg                 = beautiful.bg_primary_subtle,
                    shape              = gears.shape.rectangle,
                    shape_border_color = beautiful.border_secondary,
                    shape_border_width = beautiful.border_width -1
                },
                layout = wibox.layout.align.horizontal
            }
            table.insert(rows, row)
            ::continue::
        end
        popup:setup(rows)
        count_textbox.text = tostring(#rows - 1)
    end

    local popup_clicked_on = false
    notification_center:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    update_notification_center()
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
            popup.visible = true
        end
    end)
    notification_center:connect_signal("mouse::leave", function()
        if not popup_clicked_on then
            popup.visible = false
        end
    end)

    local old_notify = naughty.notify
    naughty.notify = function(args)
        local n = old_notify(args)
        table.insert(notification_data, 1, {
            title = args.title or "",
            text = args.text or "",
            icon = args.icon
        })
        current_callback = args.callback or args.run
        update_notification_center()
        return n
    end

    toggle_notification_center = function()
        update_notification_center()
        popup.visible = not popup.visible
    end

    update_notification_center()

    return notification_center
end
return notification_center_call

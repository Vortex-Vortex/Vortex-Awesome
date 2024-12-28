local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears')
local naughty   = require('naughty')
local wibox     = require('wibox')

local icons     = require('theme.icons')
local button_widget = require('widget.material.button-widget')
local clickable_container = require('widget.material.clickable-container')

local function log(...)
    local timestamp = os.date("%Y/%m/%d - %H:%M:%S")
    local args = table.concat({...}, " ")
    gears.debug.dump(timestamp .. " " .. args)
end

local function Notification_center(s)
    local screen_width = s.geometry.width
    local notification_queue = {}
    local notification_limited_queue = {}
    local current_callback = nil
    local update_queue = true
    local notif_counter = 0
    local all_notif_counter = 0
    local current_filter = 'All'
    local update_notification_limited_queue
    local update_notification_center
    local delete_queue = {}
    local delete_notifications
    local popup_clicked_on = false
    local notification_rows = {
        layout = wibox.layout.fixed.vertical
    }

    log('Started function Notification_center')

    local count_textbox = wibox.widget{
        widget = wibox.widget.textbox,
        text = 0
    }

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

    local notification_center_button = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    {
                        widget = wibox.container.place,
                        {
                            widget = wibox.widget.imagebox,
                            image = icons.notification_icon
                        },
                        align = 'center',
                        valign = 'center'
                    },
                    forced_height = 25,
                    forced_width = 25
                },
                count_textbox
            },
            left = 5,
            right = 5
        }
    )

    notification_center_button:buttons(
        awful.button(
            {},
            1,
            function()
                if not popup.visible or popup_clicked_on then
                    popup.visible = not popup.visible
                end
                popup_clicked_on = popup.visible
            end
        )
    )
    notification_center_button:connect_signal("mouse::enter", function()
        if not popup_clicked_on then
            update_notification_center()
            popup.visible = true
        end
    end)
    notification_center_button:connect_signal("mouse::leave", function()
        if not popup_clicked_on then
            popup.visible = false
        end
    end)

    notification_center_header = wibox.widget{
        widget = wibox.container.margin,
        {
            widget = wibox.container.background,
            {
                widget = wibox.widget.textbox,
                text = 'Notification Center',
                font = beautiful.system_font .. 'Bold 16',
                align = 'center',
                valign = 'center',
                forced_height = 40,
                forced_width = 400
            },
            shape = gears.shape.rectangle,
            shape_border_width = beautiful.border_width + 1,
            shape_border_color = beautiful.border_normal
        },
        margins = 5
    }

    local function create_filter_widget(filter_name)
        log('Start function create_filter_widget | arg:', filter_name)
        filter_widget = wibox.widget{
            widget = wibox.container.margin,
            clickable_container(
                {
                    widget = wibox.widget.textbox,
                    text = filter_name,
                    font = beautiful.system_font .. '12',
                    align = 'center',
                    valign = 'center'
                },
                {
                    border_width = beautiful.border_width_reduced,
                    border_color = beautiful.border_focus
                }
            ),
            margins = 5,
            forced_width = 200,
            forced_height = 40
        }

        filter_widget:buttons(
            awful.button(
                {},
                1,
                function()
                    current_filter = filter_name
                    log('Set var:current_filter =', current_filter)
                end
            )
        )

        return filter_widget
    end

    local filter_box_widget = wibox.widget{
        layout = wibox.layout.fixed.vertical,
        notification_center_header,
        {
            layout = wibox.layout.fixed.horizontal,
            create_filter_widget('All'),
            create_filter_widget('X')
        },
        {
            layout = wibox.layout.fixed.horizontal,
            create_filter_widget('Telegram'),
            create_filter_widget('Misc')
        }
    }

    local num_pages = {}
    local current_page = 1
    local function create_page_widget()
        log('Start function create_page_widget')
        local num_pages = wibox.widget{
            widget = wibox.widget.textbox,
            text = current_page .. ' / ' .. 1,
            align = 'center',
            valign = 'center',
            forced_width = 40
        }

        local left_arrow = button_widget('half_arrow_left')
        left_arrow:buttons(
            awful.button(
                {},
                1,
                function()
                    current_page = current_page - 1
                    num_pages.text = current_page .. ' / ' .. 1
                    log('Update num_pages.text = ', num_pages.text)
                end
            )
        )
        local right_arrow = button_widget('half_arrow_right')
        right_arrow:buttons(
            awful.button(
                {},
                1,
                function()
                    current_page = current_page + 1
                    num_pages.text = current_page .. ' / ' .. 1
                    log('Update num_pages.text = ', num_pages.text)
                end
            )
        )

        local page_widget = wibox.widget{
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    left_arrow,
                    margins = 9
                },
                num_pages,
                {
                    widget = wibox.container.margin,
                    right_arrow,
                    margins = 9
                }
            },
            forced_height = 40
        }

        return page_widget
    end

    local function create_trash_widget()
        log('Start function create_trash_widget')
        local select_checkbox = wibox.widget{
            widget = wibox.widget.checkbox,
            checked = false,
            forced_height = 20,
            forced_width = 20
        }
        select_checkbox:buttons(
            awful.button(
                {},
                1,
                function()
                    select_checkbox.checked = not select_checkbox.checked
                    if select_checkbox.checked then
                        bg = '#ff000066'
                    else
                        bg = '#00000000'
                    end
                    gears.debug.dump(notification_rows,nil,2)
                    for _, notification_body in ipairs(notification_rows) do
                        notification_body.bg = bg
                        if select_checkbox.checked then
                            table.insert(delete_queue, notification_body.identifier)
                        end
                    end
                    if not select_checkbox.checked then
                        delete_queue = {}
                    end
                end
            )
        )
        select_checkbox:connect_signal(
            'mouse::enter',
            function(self)
                self.bg = beautiful.border_normal
            end
        )
        select_checkbox:connect_signal(
            'mouse::leave',
            function(self)
                self.bg = beautiful.checkbox_bg
            end
        )

        select_checkbox_widget = wibox.widget{
            widget = wibox.container.margin,
            select_checkbox,
            top = 10,
            bottom = 10
        }

        local trash_button = button_widget('trash_icon')
        trash_button:buttons(
            awful.button(
                {},
                1,
                nil,
                function()
                    log('Clicked trash_icon')
                    select_checkbox.checked = false
                    delete_notifications()
                    update_notification_center()
                end
            )
        )

        trash_button_widget = wibox.widget{
            widget = wibox.container.margin,
            trash_button,
            forced_height = 40,
            forced_width = 40,
            left = 0,
            right = 5,
            top = 1,
            bottom = 1
        }

        trash_widget = wibox.widget{
            layout = wibox.layout.fixed.horizontal,
            select_checkbox_widget,
            trash_button_widget
        }

        return trash_widget
    end

    local utils_row = wibox.widget{
        widget = wibox.container.margin,
        {
            layout = wibox.layout.align.horizontal,
            create_page_widget(),
            nil,
            create_trash_widget()
        },
        forced_width = 400,
        forced_height = 40
    }

    function update_notification_limited_queue()
        log('Start update_notification_limited_queue')
-- -- --Add argument to filter selecter filter from queue
-- -- --Revise number of notifications displayed
        for i = 1, 6 do
            notification_limited_queue[i] = notification_queue[i]
        end
    end

    function delete_notifications()
        log('Start delete_notifications')
        for _, d_identifier in ipairs(delete_queue) do
            for i = #notification_queue, 1, -1 do
                if notification_queue[i].identifier == d_identifier then
                    log('Remove notification identifier', d_identifier)
                    table.remove(notification_queue, i)
                    update_queue = true
                    break
                end
            end
        end
        delete_queue = {}
        gears.debug.dump(notification_queue)
    end

    function update_notification_center()
        if not update_queue then
            return
        end
        log('Start update_notification_center')
        update_notification_limited_queue()
        for i = 0, #notification_rows do
            notification_rows[i] = nil
        end
        for index, notification in ipairs(notification_limited_queue) do
-- -- --Substitute 'time' for 'time ago'
-- -- --Make checkbox button work -> signal to all visible notifications
-- -- --Make Trash button work
-- -- --Manipute notification_queue{,limited} tables
            local notification_text = wibox.widget{
                widget = wibox.widget.textbox,
                text = notification.text,
                font = beautiful.system_font .. '10',
                align = 'center',
                valign = 'center',
                forced_height = 60,
                forced_width = 340
            }

            local notification_time = wibox.widget{
                widget = wibox.widget.textbox,
                text = notification.time,
                font = beautiful.system_font .. '9',
                align = 'center',
                valign = 'center',
                forced_height = 20,
                forced_width = 60
            }

            local notification_body = wibox.widget{
                widget = wibox.container.background,
                clickable_container(
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            widget = wibox.container.background,
                            {
                                widget = wibox.container.place,
                                {
                                    layout = wibox.layout.fixed.vertical,
                                    {
                                        widget = wibox.widget.imagebox,
                                        image = notification.icon,
                                        forced_height = 60,
                                        forced_width = 60
                                    },
                                    notification_time
                                },
                                valign = 'center'
                            },
                            shape = gears.shape.rectangle,
                            shape_border_width = beautiful.border_width_reduced,
                            shape_border_color = beautiful.border_focus
                        },
                        {
                            layout = wibox.layout.fixed.vertical,
                            {
                                widget = wibox.widget.textbox,
                                text = notification.title,
                                font = beautiful.system_font .. 'Bold 12',
                                align = 'center',
                                valign = 'center',
                                forced_height = 20,
                                forced_width = 340
                            },
                            notification_text
                        }
                    },
                    {
                        border_width = beautiful.border_width_reduced,
                        border_color = beautiful.border_normal
                    }
                ),
                bg = '#00000000',
                identifier = notification.identifier
            }
            notification_body:buttons(
                gears.table.join(
                    awful.button(
                        {},
                        3,
                        function()
                            log('Add notification identifier', notification.identifier, 'to delete_queue')
                            table.insert(delete_queue, notification.identifier)
                            notification_body.bg = '#ff000066'
                            gears.debug.dump(delete_queue)
                        end
                    ),
                    awful.button(
                        {},
                        4,
                        function()
                            notification_text.forced_height = 60
                        end
                    ),
                    awful.button(
                        {},
                        5,
                        function()
                            notification_text.forced_height = notification_text:get_height_for_width(340)
                        end
                    )
                )
            )
-- -- --    Notification body signals: red delete/scroll expand/change border hover
            notification_rows[index] = notification_body
            log('Created notification object identified by', notification.identifier)
        end
        popup:setup(
            {
                layout = wibox.layout.fixed.vertical,
                filter_box_widget,
                utils_row,
                notification_rows
            }
        )
        update_queue = false
    end

    function naughty.config.notify_callback(args)
        update_queue = true
        args.time = os.date("%H:%M:%S")
        all_notif_counter = all_notif_counter + 1
-- -- --Add args.filter according to args.title
        table.insert(notification_queue, 1, {
            title = args.title or args.appname,
            text = args.text or "",
            icon = args.icon or icons.notification_icon,
-- -- --Add icon substitution for icon=file:///tmp...
            time = args.time,
            identifier = all_notif_counter
        })
        if popup.visible then
            update_notification_center()
        end
        notif_counter = notif_counter + 1
        count_textbox.text = notif_counter
        log('Received notification identified by', all_notif_counter)
        return args
    end

    return notification_center_button
end

return Notification_center

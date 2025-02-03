local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')

local icons = require('theme.icons')
local button_widget = require('widget.material.button-widget')
local clickable_container = require('widget.material.clickable-container')
local json = require('widget.utils.json')

local TODO_LIST = gears.filesystem.get_xdg_cache_home() .. 'awesome/todo-list.json'

local function Todo_widget(s)
    local screen_width = s.geometry.width
    local update_todo_list
    local todo_list_filtered_queue = {}
    local todo_list_limited_queue = {}
    local update_queue = true
    local number_of_rows = 8
    local current_filter = 'All'
    local todo_list = {}

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

    local todo_widget_button = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                widget = wibox.container.place,
                {
                    widget = wibox.widget.imagebox,
                    image = icons.checkbox_icon
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
    local popup_clicked_on
    todo_widget_button:buttons(
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
    todo_widget_button:connect_signal("mouse::enter", function()
        if not popup_clicked_on then
            awful.spawn.easy_async(
                'cat ' .. TODO_LIST,
                function(stdout)
                    todo_list = json.decode(stdout)
                    update_todo_list()
                end
            )
            popup.visible = true
        end
    end)
    todo_widget_button:connect_signal("mouse::leave", function()
        if not popup_clicked_on then
            popup.visible = false
        end
    end)

    local function create_filter_widget(filter_name)
        local filter_widget = clickable_container(
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
        )

        local constrained_filter_widget = wibox.widget{
            widget = wibox.container.margin,
            filter_widget,
            margins = 5,
            forced_width = 200,
            forced_height = 40
        }

        local stacked_filter_widget = wibox.widget{
            layout = wibox.layout.stack,
            constrained_filter_widget,
            {
                widget = wibox.container.place,
                {
                    widget = wibox.container.margin,
                    muted_indicator,
                    right = 10,
                },
                valign = 'center',
                halign = 'right',
                forced_height = 20
            }
        }

        filter_widget:buttons(
            awful.button(
                {},
                1,
                function()
                    current_filter = filter_name
                    update_queue = true
                    update_todo_list()
                end
            )
        )

        return stacked_filter_widget
    end

    local add_ticker_button = button_widget('plus_icon')

    local popup_header = wibox.widget{
        widget = wibox.container.margin,
        {
            widget = wibox.container.background,
            {
                layout = wibox.layout.align.horizontal,
                add_ticker_button,
                {
                    widget = wibox.widget.textbox,
                    text = 'ToDo List',
                    font = beautiful.system_font .. 'Bold 16',
                    align = 'center',
                    valign = 'center'
                },
                {
                    widget = wibox.container.margin,
                    {
                        widget = wibox.widget.imagebox,
                        image = icons.checkbox_icon
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

    local filters = {
        'All', 'Notes', 'USP', 'Appointment', 'AwesomeWM', 'Crypto'
    }

    local filter_box_widget = wibox.widget{
        layout = wibox.layout.fixed.vertical,
        popup_header,
        {
            layout = wibox.layout.fixed.horizontal,
            create_filter_widget('All'),
            create_filter_widget('Notes')
        },
        {
            layout = wibox.layout.fixed.horizontal,
            create_filter_widget('USP'),
            create_filter_widget('Appointment')
        },
        {
            layout = wibox.layout.fixed.horizontal,
            create_filter_widget('AwesomeWM'),
            create_filter_widget('Crypto')
        }
    }

    local num_pages = {}
    local current_page = 1
    local page_limit = 1
    local function update_page()
        page_limit = math.ceil(#todo_list_filtered_queue/number_of_rows)
        num_pages.text = current_page .. ' / ' .. page_limit
    end

    local function create_page_widget()
        num_pages = wibox.widget{
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
                    if current_page > 1 then
                        current_page = current_page - 1
                        update_queue = true
                        update_todo_list()
                    end
                end
            )
        )
        local right_arrow = button_widget('half_arrow_right')
        right_arrow:buttons(
            awful.button(
                {},
                1,
                function()
                    if current_page < page_limit then
                        current_page = current_page + 1
                        update_queue = true
                        update_todo_list()
                    end
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

    local delete_items
    local function create_trash_widget()
        local trash_button = button_widget('trash_icon')
        trash_button:buttons(
            awful.button(
                {},
                1,
                nil,
                function()
                    delete_items()
                    update_todo_list()
                end
            )
        )

        local trash_button_widget = wibox.widget{
            widget = wibox.container.margin,
            trash_button,
            forced_height = 40,
            forced_width = 40,
            left = 0,
            right = 5,
            top = 1,
            bottom = 1
        }

        return trash_button_widget
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

    local widget_rows = {
        layout = wibox.layout.fixed.vertical
    }

    local function setup_todo_widget()
        popup:setup(
            {
                layout = wibox.layout.fixed.vertical,
                filter_box_widget,
                utils_row,
                widget_rows
            }
        )
    end

    local update_todo_list_limited_queue
    function update_todo_list_limited_queue()
        todo_list_filtered_queue = {}
        todo_list_limited_queue = {}

        for i, todo in ipairs(todo_list) do
            todo.identifier = i
        end

        awful.spawn.with_shell(string.format("echo '%s' > %s", json.encode(todo_list), TODO_LIST))

        if current_filter == 'All' then
            todo_list_filtered_queue = todo_list
        else
            for _, todo in ipairs(todo_list) do
                if todo.filter == current_filter then
                    table.insert(todo_list_filtered_queue, todo)
                end
            end
        end

        table.sort(todo_list_filtered_queue, function(a, b)
            return a.unix > b.unix
        end)

        local start_index = (current_page - 1) * number_of_rows + 1
        local end_index = start_index + number_of_rows -1

        for i = start_index, end_index do
            if todo_list_filtered_queue[i] then
                table.insert(todo_list_limited_queue, todo_list_filtered_queue[i])
            end
        end
        if #todo_list_filtered_queue > 0 and #todo_list_limited_queue == 0 then
            current_page = current_page - 1
            update_todo_list_limited_queue()
        end
    end

    local delete_queue = {}
    function delete_items()
        for _, identifier in ipairs(delete_queue) do
            for i = #todo_list, 1, -1 do
                if todo_list[i].identifier == identifier then
                    table.remove(todo_list, i)
                    update_queue = true
                    break
                end
            end
        end
        delete_queue = {}
        awful.spawn.with_shell(string.format("echo '%s' > %s", json.encode(todo_list), TODO_LIST))
    end

    function update_todo_list()
        if not update_queue then
            return
        end
        update_todo_list_limited_queue()
        update_page()

        for i = 0, #widget_rows do
            widget_rows[i] = nil
        end

        for i, todo in ipairs(todo_list_limited_queue) do
            local date_text = wibox.widget{
                widget = wibox.widget.textbox,
                text = todo.due_date,
                font = beautiful.system_font .. '9',
                align = 'center',
                valign = 'center',
                forced_width = 80,
                forced_height = 12
            }
            local filter_text = wibox.widget{
                widget = wibox.widget.textbox,
                text = todo.filter,
                font = beautiful.system_font .. 'mono bold 9',
                align = 'right',
                valign = 'center',
                forced_width = 75,
                forced_height = 12
            }
            local todo_text = wibox.widget{
                widget = wibox.widget.textbox,
                text = todo.entry,
                font = beautiful.system_font .. '10',
                align = 'center',
                valign = 'center',
                forced_height = 50
            }

            local todo_body = wibox.widget{
                widget = wibox.container.background,
                clickable_container(
                    wibox.widget{
                        layout = wibox.layout.fixed.vertical,
                        {
                            widget = wibox.container.place,
                            {
                                layout = wibox.layout.align.horizontal,
                                forced_width = 394,
                                date_text,
                                nil,
                                filter_text
                            },
                            align = 'center',
                            valign = 'bottom',
                            forced_height = 15
                        },
                        todo_text
                    },
                    {
                        border_width = beautiful.border_width_reduced,
                        border_color = beautiful.border_normal,
                        enter_border_color = beautiful.border_focus
                    }
                ),
                bg = '#00000000'
            }
            todo_body:buttons(
                gears.table.join(
                    awful.button(
                        {},
                        3,
                        function()
                            table.insert(delete_queue, todo.identifier)
                            todo_body.bg = '#ff000066'
                        end
                    ),
                    awful.button(
                        {},
                        4,
                        function()
                            todo_text.forced_height = 50
                        end
                    ),
                    awful.button(
                        {},
                        5,
                        function()
                            todo_text.forced_height = math.max(todo_text:get_height_for_width(400), 50)
                        end
                    )
                )
            )

            widget_rows[i] = todo_body
        end
        setup_todo_widget()
        update_queue = false
    end

    local function date_to_unix(date)
        local day, month, year = date:match("(%d%d)/(%d%d)/(%d%d%d%d)")
        if day and month and year then
            return os.time({day = tonumber(day), month = tonumber(month), year = tonumber(year)})
        end
        return 0
    end

    add_ticker_button:buttons(
        awful.button(
            {},
            1,
            function()
                local prompt = awful.widget.prompt()
                local prompt_row = wibox.widget{
                    widget = wibox.container.margin,
                    prompt.widget,
                    left = 10,
                    right = 10,
                    top = 2,
                    bottom = 2
                }

                table.insert(widget_rows, prompt_row)
                setup_todo_widget()

                awful.prompt.run{
                    prompt       = "<b>New Item: </b>",
                    bg           = beautiful.bg_color,
                    bg_cursor    = beautiful.fg_color,
                    textbox      = prompt.widget,
                    exe_callback = function(input_text)
                        due_date, filter, entry = input_text:match('^([^%s]+)%s([^%s]+)%s(.+)$')
                        if due_date == '' or filter == '' or entry == '' then
                            return
                        else
                            if not gears.table.hasitem(filters, filter) then
                                naughty.notify{
                                    title = 'Todo Widget',
                                    text = 'Invalid Filter!'
                                }
                                return
                            end
                            if due_date == 'today' then
                                due_date = os.date('%d/%m/%Y')
                            end
                        end

                        awful.spawn.easy_async(
                            'cat ' .. TODO_LIST,
                            function(stdout)
                                todo_list = json.decode(stdout)
                                table.insert(
                                    todo_list,
                                    {
                                        due_date = due_date,
                                        filter = filter,
                                        entry = entry,
                                        unix = date_to_unix(due_date)
                                    }
                                )
                                awful.spawn.easy_async_with_shell(
                                    string.format("echo '%s' > %s", json.encode(todo_list), TODO_LIST),
                                    function()
                                        update_queue = true
                                        update_todo_list()
                                    end
                                )
                            end
                        )
                    end,
                    done_callback = function()
                        prompt_row.visible = false
                    end
                }
            end
        )
    )

    if not gears.filesystem.file_readable(TODO_LIST) then
        awful.spawn.easy_async(string.format([[bash -c "dirname %s | xargs mkdir -p && echo '{}' > %s"]],
        TODO_LIST, TODO_LIST))
    end

    awful.spawn.easy_async(
        'cat ' .. TODO_LIST,
        function(stdout)
            todo_list = json.decode(stdout)
            update_todo_list()
        end
    )

    return todo_widget_button
end
return Todo_widget

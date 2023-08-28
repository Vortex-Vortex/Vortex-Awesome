local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')
local icons     = require('theme.icons')
local json      = require("widget.json-lua.json")

local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')
local add_button = require('widget.material.add-button')
local close_button = require('widget.material.close-button')
local down_button = require('widget.material.down-button')
local up_button = require('widget.material.up-button')

local HOME = os.getenv('HOME')
local STORAGE = HOME .. '/.cache/awmw/todo-widget/todos.json'

local GET_TODO_ITEMS = 'bash -c "cat ' .. STORAGE .. '"'

local update_widget


local popup = awful.popup{
    ontop   = true,
    visible = false,
    shape   = gears.shape.rectangle,
    x       = 1470,
    y       = 50,
    maximum_width = 400,
    border_width  = beautiful.border_width,
    border_color  = beautiful.border_focus,
    widget = {}
}

local rows = {
    layout = wibox.layout.fixed.vertical
}

local count_textbox = wibox.widget{
    widget = wibox.widget.textbox,
    font   = 'Roboto Mono bold 11',
    text   = 0
}

local todo_widget = clickable_container(wibox.widget{
    {
        {
            {
                {
                    widget = wibox.widget.imagebox,
                    image  = icons.checkbox,
                    forced_height = 20,
                    forced_width  = 20
                },
                widget = wibox.container.place,
                valign = center
            },
            count_textbox,
            layout  = wibox.layout.fixed.horizontal,
            spacing = 4
        },
        widget  = wibox.container.margin,
        margins = 4
    },
    widget = wibox.container.background,
    shape  = gears.shape.rectangle
})

local function update_counter(todos)
    local todo_count = 0
    for _,p in ipairs(todos) do
        if not p.status then
            todo_count = todo_count + 1
        end
    end
    count_textbox.text = todo_count
end

local add_button = add_button()

local first_row = wibox.widget{
    {
        {
            text  = 'ToDo',
            font  = 'Roboto Mono bold 12',
            align = 'center',
            forced_width  = 350,
            forced_height = 40,
            widget        = wibox.widget.textbox
        },
        {
            add_button,
            widget = wibox.container.margin,
            forced_height = 40,
            forced_width = 40,
            margins = dpi(7)
        },
        spacing = 8,
        layout  = wibox.layout.fixed.horizontal
    },
    bg = beautiful.bg_normal,
    shape              = gears.shape.rectangle,
    shape_border_color = beautiful.border_normal,
    shape_border_width = beautiful.border_width + 1,
    widget = wibox.container.background
}

local function create_checkbox(args)
    return wibox.widget{
        widget        = wibox.widget.checkbox,
        checked       = args.status,
        color         = beautiful.border_focus,
        paddings      = 2,
        shape         = gears.shape.circle,
        forced_width  = 20,
        forced_height = 20,
        check_color   = beautiful.check_color
    }
end

local function update_widget(stdout)
    local file = json.decode(stdout)
    if file == nil or file == '' then
        file = {}
    end
    update_counter(file.todo_items)

    for i = 0, #rows do
        rows[i] = nil
    end

    table.insert(rows, first_row)

    for i, todo_item in ipairs(file.todo_items) do
        local checkbox = create_checkbox({ status = todo_item.status })
        checkbox:connect_signal("button::press", function(c)
            c.checked          = not c.checked
            todo_item.status   = not todo_item.status
            file.todo_items[i] = todo_item
            awful.spawn.easy_async_with_shell("echo '" .. json.encode(file) .. "' > " .. STORAGE, function ()
                update_counter(file.todo_items)
            end)
        end)
        checkbox:connect_signal("mouse::enter", function(c)
            c:set_bg(beautiful.border_semi)
        end)
        checkbox:connect_signal("mouse::leave", function(c)
            c:set_bg(beautiful.bg_normal)
        end)

        local trash_button = close_button()
        trash_button:connect_signal("button::press", function()
            table.remove(file.todo_items, i)
            awful.spawn.easy_async_with_shell("echo '" .. json.encode(file) .. "' > " .. STORAGE, function()
                awful.spawn.easy_async(GET_TODO_ITEMS, function(items)
                    update_widget(items)
                end)
            end)
        end)

        local move_up = wibox.widget{
            up_button(),
            widget = wibox.container.margin,
            forced_height = 14,
            forced_width  = 14,
            margins       = dpi(0)
        }
        move_up:connect_signal("button::press", function()
            local temp           = file.todo_items[i]
            file.todo_items[i]   = file.todo_items[i-1]
            file.todo_items[i-1] = temp
            awful.spawn.easy_async_with_shell("echo '" .. json.encode(file) .. "' > " .. STORAGE, function()
                awful.spawn.easy_async(GET_TODO_ITEMS, function(items)
                    update_widget(items)
                end)
            end)
        end)

        local move_down = wibox.widget{
            down_button(),
            widget = wibox.container.margin,
            forced_height = 14,
            forced_width  = 14,
            margins       = dpi(0)
        }
        move_down:connect_signal("button::press", function()
            local temp           = file.todo_items[i]
            file.todo_items[i]   = file.todo_items[i+1]
            file.todo_items[i+1] = temp
            awful.spawn.easy_async_with_shell("echo '" .. json.encode(file) .. "' > " .. STORAGE, function()
                awful.spawn.easy_async(GET_TODO_ITEMS, function(items)
                    update_widget(items)
                end)
            end)
        end)

        local move_buttons = {
            layout = wibox.layout.fixed.vertical
        }
        if i == 1 and #file.todo_items > 1 then
            table.insert(move_buttons, move_down)
        elseif i == #file.todo_items and #file.todo_items > 1 then
            table.insert(move_buttons, move_up)
        elseif #file.todo_items > 1 then
            table.insert(move_buttons, move_up)
            table.insert(move_buttons, move_down)
        end

        local row = wibox.widget{
            {
                {
                    {
                        checkbox,
                        valign = 'center',
                        layout = wibox.container.place,
                    },
                    {
                        {
                            text   = todo_item.todo_item,
                            align  = 'left',
                            widget = wibox.widget.textbox
                        },
                        left   = 10,
                        layout = wibox.container.margin
                    },
                    {
                        {
                            move_buttons,
                            valign = 'center',
                            layout = wibox.container.place,
                        },
                        {
                            {
                                trash_button,
                                widget = wibox.container.margin,
                                forced_height = 20,
                                forced_width  = 20,
                                margins       = dpi(1)
                            },
                            valign = 'center',
                            layout = wibox.container.place,
                        },
                        spacing = 8,
                        layout = wibox.layout.align.horizontal
                    },
                    spacing = 8,
                    layout = wibox.layout.align.horizontal
                },
                margins = 8,
                layout = wibox.container.margin
            },
            widget = clickable_container(
                nil,
                {
                    leave = beautiful.bg_primary_subtle
                }
            ),
            bg = beautiful.bg_primary_subtle,
            shape              = gears.shape.rectangle,
            shape_border_color = beautiful.border_secondary,
            shape_border_width = beautiful.border_width - 1
        }
        row:connect_signal("mouse::enter", function(c)
            c.shape_border_color = beautiful.border_focus
            c.shape_border_width = beautiful.border_width
        end)
        row:connect_signal("mouse::leave", function(c)
            c.shape_border_color = beautiful.border_secondary
            c.shape_border_width = beautiful.border_width - 1
        end)

        table.insert(rows, row)
    end
    popup:setup(rows)
end

add_button:connect_signal("button::press", function()
    local prompt = awful.widget.prompt()
    local prompt_row = wibox.widget{
        {
            {
                prompt.widget,
                layout = wibox.layout.align.horizontal,
                spacing = 8
            },
            layout = wibox.container.margin,
            margins = 8
        },
        widget = wibox.container.background,
        bg = beautiful.bg_normal
    }

    table.insert(rows, prompt_row)

    awful.prompt.run{
        prompt       = "<b>New item</b>: ",
        bg           = beautiful.bg_normal,
        bg_cursor    = beautiful.fg_normal,
        textbox      = prompt.widget,
        exe_callback = function(input_text)
            if not input_text or #input_text == 0 then
                return
            end
            awful.spawn.easy_async(GET_TODO_ITEMS, function(stdout)
                local file = json.decode(stdout)
                table.insert(
                    file.todo_items,
                    {
                        todo_item = input_text,
                        status = false
                    }
                )
                awful.spawn.easy_async_with_shell("echo '" .. json.encode(file) .. "' > " .. STORAGE, function()
                    awful.spawn.easy_async(GET_TODO_ITEMS, function(items)
                        update_widget(items)
                    end)
                end)
            end)
        end
    }
    popup:setup(rows)
end)

local popup_clicked_on = false
todo_widget:buttons(
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
        )
    )
)
todo_widget:connect_signal("mouse::enter", function()
    if not popup_clicked_on then
        popup.visible = true
    end
end)
todo_widget:connect_signal("mouse::leave", function()
    if not popup_clicked_on then
        popup.visible = false
    end
end)

if not gears.filesystem.file_readable(STORAGE) then
    awful.spawn.easy_async(string.format([[bash -c "dirname %s | xargs mkdir -p && echo '{\"todo_items\":{}}' > %s"]],
    STORAGE, STORAGE))
end

awful.spawn.easy_async(GET_TODO_ITEMS, function(stdout) update_widget(stdout) end)
return todo_widget

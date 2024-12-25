local wibox = require('wibox')

local function build_container(...)
    local widget, args = ...
    local args = args or {}

    local enter_bg = args.enter or '#ffffff22'
    local leave_bg = '#ffffff00'
    local click_bg = args.click or "#ffffff44"
    local widget_shape = args.shape or gears.shape.rectangle

    local old_cursor, old_wibox

    local container = wibox.widget{
        widget = wibox.container.background,
        widget,
        shape = widget_shape
    }

    container:connect_signal(
        'mouse::enter',
        function()
            container.bg = enter_bg
            local w = _G.mouse.current_wibox
            if w then
                old_cursor, old_wibox = w.cursor, w
                w.cursor = 'hand1'
            end
        end
    )

    container:connect_signal(
        'mouse::leave',
        function()
            container.bg = leave_bg
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end
    )

    container:connect_signal(
        'mouse::press',
        function()
            container.bg = click_bg
        end
    )

    container:connect_signal(
        'mouse::release',
        function()
            container.bg = enter_bg
        end
    )
    return container
end

return build_container

local wibox = require('wibox')

function build(...)
    widget, args = ...

    local enter_bg = '#ffffff22'
    local leave_bg = '#ffffff00'
    local click_bg = '#ffffff33'

    if args ~= nil then
      enter_bg = args.enter or '#ffffff22'
      leave_bg = args.leave or '#ffffff00'
      click_bg = args.click or '#ffffff33'
    end

    local old_cursor, old_wibox
    local container = wibox.widget{
        widget,
        widget = wibox.container.background
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
        'button::press',
        function()
            container.bg = click_bg
        end
    )

    container:connect_signal(
        'button::release',
        function()
            container.bg = enter_bg
        end
    )

    return container
end

return build

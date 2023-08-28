local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local dpi = require('beautiful').xresources.apply_dpi

    -- Date
local date = wibox.widget.textclock(
    '<span font="Roboto Mono bold 11">%d.%m.%Y</span>'
)

    -- Add a calendar
local cal_main = {
    fg_color = beautiful.fg_normal,
    bg_color = beautiful.bg_normal,
    border_width = beautiful.border_width,
    border_color = beautiful.border_focus
}

local cal_header = {
    fg_color = beautiful.fg_normal,
    bg_color = beautiful.bg_normal,
    border_width = beautiful.border_width + 1,
    border_color = beautiful.border_normal
}

local cal_weekday = {
    fg_color = beautiful.fg_normal,
    bg_color = beautiful.bg_normal,
    border_width = beautiful.border_width - 1,
    border_color = beautiful.border_secondary,
    padding = 12,
}

local cal_normal = {
    fg_color = beautiful.fg_normal,
    bg_color = beautiful.bg_primary_subtle,
    border_width = beautiful.border_width - 1,
    border_color = beautiful.border_secondary,
    padding = 12,
}

local cal_focus = {
    fg_color = beautiful.bg_normal,
    bg_color = beautiful.bg_primary_blatant,
    border_width = beautiful.border_width - 1,
    border_color = beautiful.border_focus,
    padding = 12
}


local month_calendar = awful.widget.calendar_popup.month({
    screen        = s,
    start_sunday  = true,
    week_numbers  = false,
    style_month   = cal_main,
    style_header  = cal_header,
    style_weekday = cal_weekday,
    style_normal  = cal_normal,
    style_focus   = cal_focus
})

month_calendar:attach(date)

local calendar_widget = wibox.container.margin(date, dpi(13), dpi(15))

return calendar_widget

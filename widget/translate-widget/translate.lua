local awful               = require('awful')
local gears               = require('gears')
local beautiful           = require('beautiful')
local wibox               = require('wibox')
local icons               = require('theme.icons')
local naughty             = require('naughty')

local TRANSLATE_CMD = "trans -b -s %s -t %s '%s'"


local function extract(text)
    local word, lang = text:match('^(.+)%s(%a%a%a%a)$')

    if word ~= nil and lang ~= nil then
        lang1 = lang:sub(1, 2)
        lang2 = lang:sub(3)
    end
    return word, lang1, lang2
end

local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title  = 'Translate Shell',
        text   = message
    }
end

local popup = awful.popup{
    ontop   = true,
    visible = false,
    shape   = gears.shape.rectangle,
    width   = 400,
    border_width  = beautiful.border_width,
    border_color  = beautiful.border_focus,
    widget = {}
}
awful.placement.top(popup, { margins = {top = 40}})

local function translate(to_translate, source, target)
    local cmd = string.format(TRANSLATE_CMD, source, target, to_translate)

    awful.spawn.easy_async(cmd, function(stdout, stderr)
        if stderr ~= '' then
            show_warning(stderr)
        end
        stdout = stdout:gsub("^%s+\n*", "")
        stdout = stdout:gsub("\n*%s*$", "")

        popup:setup{
            widget = wibox.container.margin,
            color   = beautiful.bg_normal,
            margins = 0,
            {
                widget = wibox.container.background,
                bg           = beautiful.bg_normal,
                forced_width = 400,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 8,
                    {
                        layout = wibox.container.place,
                        valign = 'center',
                        {
                            widget = wibox.widget.imagebox,
                            image         = icons.translate,
                            forced_width  = 72,
                            forced_height = 72,
                            resize        = true
                        }
                    },
                    {
                        widget = wibox.container.margin,
                        top = 10,
                        {
                            layout = wibox.layout.fixed.vertical,
                            spacing = 5,
                            {
                                widget = wibox.container.background,
                                bg                 = beautiful.bg_primary_subtle,
                                shape              = gears.shape.rectangle,
                                shape_border_color = beautiful.border_semi,
                                shape_border_width = beautiful.border_width,
                                forced_width       = 248,
                                {
                                    widget = wibox.container.margin,
                                    bottom = 3,
                                    {
                                        widget = wibox.widget.textbox,
                                        valign = 'center',
                                        align  = 'center',
                                        markup = '<span font="Roboto Bold 15">' .. lang1 .. '-' .. lang2 .. '</span>'
                                    }
                                }
                            },
                            {
                                widget = wibox.widget.textbox,
                                markup = '<span color="#FFFFFF" font="Roboto Bold 12">' .. lang1 .. ':  ' .. to_translate .. '</span>'
                            },
                            {
                                widget = wibox.widget.textbox,
                                markup = '<span color="#FFFFFF" font="Roboto Bold 12">' .. lang2 .. ':  ' .. stdout .. '</span>'
                            }
                        }
                    }
                }
            }
        }

        popup.visible = true
        popup:buttons(awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    awful.spawn.with_shell("echo -n '" .. stdout .. "' | xclip -selection clipboard")
                    popup.visible = false
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.spawn.with_shell("echo -n '" .. to_translate .."' | xclip -selection clipboard")
                    popup.visible = false
                end
            )
        ))
    end)
end

local prompt = awful.widget.prompt()
local input_widget = wibox{
    screen          = mouse.screen,
    visible         = false,
    expand          = true,
    ontop           = true,
    width           = 300,
    height          = 50,
    max_widget_size = 500,
    bg              = beautiful.bg_normal,
    shape           = gears.shape.rectangle,
    border_width    = beautiful.border_width,
    border_color    = beautiful.border_focus,
}

input_widget:setup{
    widget = wibox.container.margin,
    margins = 8,
    {
        prompt,
        widget = wibox.container.background,
        bg = beautiful.bg_normal
    }
}

local function launch()
    awful.placement.top(input_widget, { margins = {top = 40}, parent = awful.screen.focused()})
    input_widget.visible = true

    awful.prompt.run{
        prompt = "<b>Translate</b>: ",
        textbox = prompt.widget,
        history_path = gears.filesystem.get_dir('cache') .. '/translate_history',
        bg_cursor = beautiful.bg_normal,
        exe_callback = function(text)
            if not text or #text == 0 then return end
            local to_translate, lang1, lang2 = extract(text)
            if not to_translate or #to_translate==0 or not lang1 or #lang1 == 0 or not lang2 or #lang2 == 0 then
                naughty.notify{
                    preset = naughty.config.presets.critical,
                    title = 'Translate Widget Error',
                    text = 'Language is not provided',
                }
                return
            end
            translate(to_translate, lang1, lang2)
        end,
        done_callback = function()
            input_widget.visible = false
        end
    }
end

return {
    launch = launch
}

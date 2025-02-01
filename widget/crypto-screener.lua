local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')

local icons = require('theme.icons')
local button_widget = require('widget.material.button-widget')
local clickable_container = require('widget.material.clickable-container')
local json = require('widget.utils.json')

local function Crypto_screener_widget(s)
    local screen_width = s.geometry.width
    local update_functions = {}

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

    local crypto_screener_widget = clickable_container(
        wibox.widget{
            widget = wibox.container.margin,
            {
                widget = wibox.container.place,
                {
                    widget = wibox.widget.imagebox,
                    image = icons.bitcoin_icon
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
    crypto_screener_widget:buttons(
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
    crypto_screener_widget:connect_signal("mouse::enter", function()
        if not popup_clicked_on then
            popup.visible = true
        end
    end)
    crypto_screener_widget:connect_signal("mouse::leave", function()
        if not popup_clicked_on then
            popup.visible = false
        end
    end)

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
                    text = 'Crypto Screener',
                    font = beautiful.system_font .. 'Bold 16',
                    align = 'center',
                    valign = 'center'
                },
                {
                    widget = wibox.container.margin,
                    {
                        widget = wibox.widget.imagebox,
                        image = icons.bitcoin_icon
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

    local tickers = {}
    local widget_rows = {
        layout = wibox.layout.fixed.vertical,
        id = 'widget_layout'
    }

    local function update_screener_widget()
        popup:setup(
            {
                layout = wibox.layout.fixed.vertical,
                popup_header,
                widget_rows
            }
        )
    end

    local update_tickers_argument, get_tickers_data

    local function create_ticker_row(ticker, reference_price, reference_label)
        table.insert(tickers, ticker)
        local current_price_widget = wibox.widget{
            widget = wibox.widget.textbox,
            text = '$' .. reference_price,
            font = beautiful.system_font .. '12',
            align = 'center',
            valign = 'center',
            forced_width = 115
        }
        reference_label = reference_label or '$' .. reference_price
        local reference_price_widget = wibox.widget{
            widget = wibox.widget.textbox,
            text = reference_label,
            font = beautiful.system_font .. '12',
            align = 'center',
            valign = 'center',
            forced_width = 115
        }
        local percentage_change = wibox.widget{
            widget = wibox.widget.textbox,
            text = '0.00%',
            font = beautiful.system_font .. 'bold 11',
            align = 'center',
            valign = 'center',
            forced_width = 60
        }
        local remove_ticker_button = button_widget('x_icon')

        if not update_functions[ticker] then
            update_functions[ticker] = {}
        end

        local update_func = function(new_price)
            current_price_widget.text = '$' .. string.format('%.2f', new_price)
            local percentage = ((tonumber(new_price) - reference_price) / reference_price) * 100
            percentage_change.text = string.format('%.2f%%', percentage)
        end

        table.insert(update_functions[ticker], update_func)

        local row = wibox.widget{
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.background,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            widget = wibox.container.margin,
                            remove_ticker_button,
                            forced_width = 18,
                            left = 2,
                            top = 11,
                            bottom = 11
                        },
                        {
                            widget = wibox.widget.textbox,
                            text = ticker,
                            font = beautiful.system_font .. 'bold 12',
                            align = 'center',
                            valign = 'center',
                            forced_width = 80
                        }
                    },
                    shape = gears.shape.rectangle,
                    shape_border_width = beautiful.border_width_reduced,
                    shape_border_color = beautiful.border_focus
                },
                {
                    widget = wibox.container.background,
                    reference_price_widget,
                    shape = gears.shape.rectangle,
                    shape_border_width = beautiful.border_width_reduced,
                    shape_border_color = beautiful.border_normal
                },
                {
                    widget = wibox.container.background,
                    current_price_widget,
                    shape = gears.shape.rectangle,
                    shape_border_width = beautiful.border_width_reduced,
                    shape_border_color = beautiful.border_normal
                },
                {
                    widget = wibox.container.background,
                    percentage_change,
                    shape = gears.shape.rectangle,
                    shape_border_width = beautiful.border_width_reduced,
                    shape_border_color = beautiful.border_focus
                },
            },
            left = 5,
            right = 5,
            forced_height = 40
        }

        remove_ticker_button:buttons(
        awful.button(
            {},
            1,
            function()
                table.remove(tickers, gears.table.hasitem(tickers, ticker))
                if update_functions[ticker] then
                    for i, func in ipairs(update_functions[ticker]) do
                        if func == update_func then
                            table.remove(update_functions[ticker], i)
                            break
                        end
                    end
                    if #update_functions[ticker] == 0 then
                        update_functions[ticker] = nil
                    end
                end

                table.remove(widget_rows, gears.table.hasitem(widget_rows, row))
                update_tickers_argument()
                update_screener_widget()
            end
        )
    )

        table.insert(widget_rows, row)
        update_tickers_argument()
        update_screener_widget()
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
                update_screener_widget()

                awful.prompt.run{
                    prompt       = "<b>New Ticker: </b>",
                    bg           = beautiful.bg_color,
                    bg_cursor    = beautiful.fg_color,
                    textbox      = prompt.widget,
                    exe_callback = function(input_text)
                        ticker, price, label = string.match(input_text, '^([A-Z]+)%s([%d%.]+)%s?(.*)$')
                        if ticker and price then
                            create_ticker_row(ticker, tonumber(price), label ~= '' and label or nil)
                            get_tickers_data()
                        end
                    end,
                    done_callback = function()
                        prompt_row.visible = false
                    end
                }
            end
        )
    )

    local tickers_argument = ''
    function update_tickers_argument()
        tickers_argument = ''
        local tickers_table = {}
        local seen = {}
        for i, ticker in ipairs(tickers) do
            if not seen[ticker] then
                table.insert(tickers_table, ticker)
                seen[ticker] = true
            end
            tickers_argument = '["' .. table.concat(tickers_table, '","') .. '"]'
        end
    end

    function get_tickers_data()
        if tickers_argument == '' then return end
        awful.spawn.easy_async(
            string.format([[curl -gs 'https://api.binance.com/api/v3/ticker/price?symbols=%s']], tickers_argument),
            function(stdout)
                data = json.decode(stdout)
                for _, ticker_data in ipairs(data) do
                    if update_functions[ticker_data.symbol] then
                        for _, func in ipairs(update_functions[ticker_data.symbol]) do
                            func(ticker_data.price)
                        end
                    end
                end
            end
        )
    end

    local function create_daily_close(ticker)
        awful.spawn.easy_async(
            string.format([[curl -gs 'https://api.binance.com/api/v3/klines?symbol=%s&interval=1d&limit=1']], ticker),
            function(stdout)
                data = json.decode(stdout)
                create_ticker_row(ticker, tonumber(data[1][2]), 'Daily Open')
            end
        )
    end

    create_daily_close('BTCUSDT')

    gears.timer{
        timeout = 60,
        autostart = true,
        call_now = true,
        callback = function()
            get_tickers_data()
        end
    }

    return crypto_screener_widget
end
return Crypto_screener_widget

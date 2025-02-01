#!/bin/bash

urlencore() {
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-à-üÀ-Üã-ũ]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    LC_COLLATE=$old_lc_collate
}

icons_location="$HOME/.config/awesome/theme/icons/logos/"

# First entry = png name
entries=(
    "arch,linux,wiki,manual"
    "awesomewm,manual,.awm"
    "bash,manual,.bsh"
    "bybit,exchange,bitcoin,.bbt"
    "chatgpt,.gpt"
    "gemini,google,.gem"
    "github,.gh"
    "gmail,google,mail,.gm"
    "jstris,tetris,game,.js"
    "jupiterweb,usp,.jw"
    "lua,manual,.lua"
    "maps,google,.maps"
    "minesweeper,game,.mn"
    "moodle,usp,.mdl"
    "onepiece,.op"
    "proton,mail,.pm,.pt"
    "sudoku,game,.sdk"
    "tetrio,tetris,game,.ttr"
    "tradingview,bitcoin,.tv"
    "whatsapp,.wp"
    "x,twitter,.tw,.x"
    "youtube,google,.yt"
)

chosen=$(for prompt in "${entries[@]}"; do
    echo -en "${prompt}\0icon\x1f${icons_location}${prompt/,*}.png\n"
    done | rofi -config ~/.config/awesome/theme/rofi/internet.rasi -dmenu -i -p "Internet: ")

case "${chosen/,*}" in
    "arch")
        site=wiki.archlinux.org
        ;;
    "awesomewm")
        site=awesomewm.org/doc/api/
        ;;
    "bash")
        site=www.gnu.org/software/bash/manual/bash.html
        ;;
    "bybit")
        site=bybit.com
        ;;
    "chatgpt")
        site=chat.openai.com
        ;;
    "gemini")
        site=gemini.google.com
        ;;
    "github")
        site=github.com
        ;;
    "gmail")
        site=mail.google.com
        ;;
    "jstris")
        site=jstris.jezevec10.com
        ;;
    "jupiterweb")
        site=uspdigital.usp.br/jupiterweb/
        ;;
    "lua")
        site=www.lua.org/manual/5.4/
        ;;
    "maps")
        site=maps.google.com
        ;;
    "minesweeper")
        site=minesweeper.online
        ;;
    "moodle")
        site=edisciplinas.usp.br/
        ;;
    "onepiece")
        site=tcbscans.me
        ;;
    "proton")
        site=mail.proton.me
        ;;
    "sudoku")
        site=sudoku.com
        ;;
    "tetrio")
        site=tetr.io
        ;;
    "tradingview")
        site=tradingview.com
        ;;
    "whatsapp")
        site=web.whatsapp.com
        ;;
    "x")
        site=x.com
        ;;
    "youtube")
        site=youtube.com
        ;;
    '\s'*|'/s'*)
        engine=$(cut -d' ' -f 2 <(echo "$chosen"))
        case "${engine}" in
            "gg")
                searchEngine='https://www.google.com/search?q='
                ;;
            "st")
                searchEngine='https://www.startpage.com/do/search?query='
                ;;
            "dd")
                searchEngine='https://duckduckgo.com/?q='
                ;;
            "yh")
                searchEngine='https://search.yahoo.com/search?p='
                ;;
            "bg")
                searchEngine='https://www.bing.com/search?q='
                ;;
            *)
                exit
                ;;
        esac
        query=$(cut -d' ' -f 3- <(echo "$chosen"))
        xdg-open "${searchEngine}$(urlencode "${query}")"
        exit
        ;;
    '\y'*|'/y'*)
        searchEngine="https://www.youtube.com/results?search_query="
        query=$(cut -d' ' -f 2- <(echo "$chosen"))
        xdg-open "${searchEngine}$(urlencode "${query}")"
        exit
        ;;
    [a-zA-Z0-9]*)
        xdg-open "https://www.startpage.com/do/search?query=$(urlencode "${chosen}")"
        exit
        ;;
esac
[[ -n "$site" ]] && xdg-open "https://${site}"

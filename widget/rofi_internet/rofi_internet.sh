#!/bin/bash

declare -a icons_prompt=()

icons_location="$HOME/.config/awesome/theme/icons/Logos/"

urlencode() {
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

# Here should be the png name only:
key_value_pair=(
    "arch"
    "x,twitter,.tw,.x"
    "tradingview,.tv"
    "youtube,.yt"
    "whatsapp,.wp"
    "github,.gh"
    "chatgpt,.gpt"
    "gemini,bard"
    "gmail,.gm"
    "proton,.pm"
    "onepiece,.op"
    "tetris,.js,game"
    "minesweeper,.mn,game"
    "sudoku,game"
    "tetrio,game"
    "lua,script"
    "bash,script"
    "awesome,script"
    "bybit"
)

chosen=$(for prompt in "${key_value_pair[@]}"; do
    echo -en "${prompt}\0icon\x1f${icons_location}${prompt/,*/}.png\n"
done | rofi -config ~/.config/awesome/theme/internet.rasi \
           -dmenu \
           -p "Internet: ")
case "${chosen/,*/}" in
    "arch")
        site=wiki.archlinux.org
        ;;
    "x")
        site=x.com
        ;;
    "tradingview")
        site=tradingview.com
        ;;
    "youtube")
        site=youtube.com
        ;;
    "whatsapp")
        site=web.whatsapp.com
        ;;
    "github")
        site=github.com
        ;;
    "chatgpt")
        site=chat.openai.com
        ;;
    "gemini")
        site=gemini.google.com
        ;;
    "gmail")
        site=mail.google.com
        ;;
    "proton")
        site=mail.proton.me
        ;;
    "onepiece")
        site=tcbscans.com
        ;;
    "tetris")
        site=jstris.jezevec10.com
        ;;
    "minesweeper")
        site=minesweeper.online
        ;;
    "sudoku")
        site=sudoku.com
        ;;
    "tetrio")
        site=tetr.io
        ;;
    "lua")
        site=www.lua.org/manual/5.4/
        ;;
    "bash")
        site=www.gnu.org/software/bash/manual/bash.html
        ;;
    "awesome")
        site=awesomewm.org/doc/api/
        ;;
    "bybit")
        site=bybit.com
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

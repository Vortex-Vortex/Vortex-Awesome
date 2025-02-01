#!/bin/bash

mkdir -p ~/.local/share/rofi && touch ~/.local/share/rofi/rofi_trans_history
IFS='|' read choice prompt <<< "$({ echo -en "Translate\0permanent\x1ftrue\n"; while read line; do echo -en "${line}\0permanent\x1ftrue\n"; done < <(tac ~/.local/share/rofi/rofi_trans_history); } | rofi -config ~/.config/awesome/theme/rofi/translate-query.rasi -dmenu -p 'Translate:' -format 's|f')"

[[ -z $choice ]] && exit
if [[ $choice == "Translate" ]]; then
    to_hist=true
else
    prompt="$choice"
fi

IFS='-' read source target <<< "${prompt/* }"
if [[ -z "$prompt" || "$prompt" =~ ^[[:space:]]+$ ]]; then
    notify-send 'Translate-rofi' 'Failed to Parse Prompt!'
    exit
elif [[ ! "$prompt" =~ .*-.* ]]; then
    source=
    target=pt
    prompt="$prompt "
elif [[ -n $source ]]; then
    [[ "$prompt" == "$source-$target" ]] && source= && target=
    target=${target:-pt}
fi
result="$(trans $source:${target:-pt} "${prompt% *}" -no-ansi -no-autocorrect && ${to_hist:-false} && echo $prompt >> ~/.local/share/rofi/rofi_trans_history)"
rofi -config ~/.config/awesome/theme/rofi/translate-result.rasi -dmenu -mesg "$result" && echo -n "$(trans -b $source:${target:-pt} "${prompt% *}")" | xclip -selection clipboard


local config_dir = require('gears.filesystem').get_configuration_dir()
local home_dir = os.getenv('HOME')

return {
    default = {
        rofi = 'rofi -config ~/.config/awesome/theme/rofi/sidebar.rasi -show drun',
        rofi_emoji = 'rofi -show emoji -config ~/.config/awesome/theme/rofi/emoji.rasi  -emoji-format \'{emoji}\' -emoji-mode copy',
        rofi_calc = 'rofi -show calc -modi calc -no-show-match -no-sort -automatic-save-to-history -config ~/.config/awesome/theme/rofi/calc.rasi -calc-command',
        rofi_internet = 'sh ' .. config_dir .. 'widget/rofi/internet.sh',
        rofi_translate = 'sh ' .. config_dir .. 'widget/rofi/translate.sh',
        browser = 'waterfox',
        terminal = 'terminator',
        social = 'telegram-desktop',
        files = 'nemo',
        coding = 'kate',
        edit = 'rnote',
        music = 'pragha',
        lock = 'sh ' .. config_dir .. 'widget/scripts/lock',
        quake = 'alacritty --title QuakeTerminal',
        screenshot = 'flameshot screen --region all -p ~/Pictures',
        region_screenshot = 'flameshot gui --clipboard -p ~/Pictures',
        pip_screenshot = 'flameshot gui --pin',
        ocr_screenshot = 'sh ' .. config_dir .. 'widget/scripts/crop-ocr',
        qr_screenshot = 'sh ' .. config_dir .. 'widget/scripts/crop-qr',
        color_picker = 'xcolor --format hex --preview-size 255 --scale 10 | tr -d "\n" | xclip -selection clipboard',
        custom_script = 'sh ' .. config_dir .. 'widget/scripts/custom-awm'
    },
    run_on_startup = {
        'numlockx on',
        'setxkbmap br',
        'nm-applet --indicator',
        'picom --vsync --config ' .. home_dir .. '/.config/awesome/configuration/picom.conf',
        'lxsession',
        'xmodmap -e "add mod3 = Scroll_Lock"',
        'flameshot'
    }
}

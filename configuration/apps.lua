local filesystem = require('gears.filesystem')

-- local rofi_command = 'rofi -combi-modi window,drun -show combi -modi combi'
local rofi_command = 'rofi -show drun'

return{
    -- List of apps to start by default
    default = {
        rofi = rofi_command,
        rofi_emoji = 'rofi -show emoji -config ~/.config/awesome/theme/emoji.rasi  -emoji-format \'{emoji}\' -emoji-mode copy',
        rofi_calc = 'rofi -show calc -modi calc -no-show-match -no-sort -config ~/.config/awesome/theme/calc.rasi',
        rofi_internet = 'sh /home/vortex/.config/awesome/widget/rofi_internet/rofi_internet.sh',
        lock = 'sh /home/vortex/.config/i3lock-blur/lock.sh',
        terminal = 'terminator',
        code = 'terminator',
        browser = 'waterfox',
        editor = 'kate',
        social = 'telegram-desktop',
        game = rofi_command,
        files = 'nemo',
        music = 'pragha',
        quake = 'alacritty --title QuakeTerminal',
        notes = 'rnote',
        screenshot = 'flameshot screen -p ~/Pictures',
        region_screenshot = 'flameshot gui --clipboard -p ~/Pictures',
        delayed_screenshot = 'flameshot screen -p ~/Pictures -d 5000',
        pip_screenshot_1 = 'mkdir /tmp/png; flameshot gui -p /tmp/png/',
        ocr_screenshot = '/home/vortex/Scripts/crop-ocr',
        color_picker = 'xcolor --format hex --preview-size 255 --scale 10 | tr -d "\n" | xclip -selection clipboard'
    },

    -- List of apps to open at startup
    run_on_start_up = {
        'numlockx on',
        'nm-applet --indicator',
--         'pasystray',
        'setxkbmap br',
        'picom --config ' .. filesystem.get_configuration_dir() .. '/configuration/picom.conf',
        'lxsession',
        "xmodmap -e 'add mod3 = Scroll_Lock'",
        'flameshot',
        'feh --randomize --bg-fill ~/.wallpapers/*',
    }
}

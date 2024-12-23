local config_dir = require('gears.filesystem').get_configuration_dir()

return {
    default = {
        rofi = 'rofi -show drun',
        browser = 'waterfox',
        terminal = 'terminator',
        social = 'telegram-desktop',
        files = 'nemo',
        coding = 'kate',
        edit = 'rnote',
        music = 'pragha'
    },
    run_on_startup = {
        'numlockx on'
    }
}

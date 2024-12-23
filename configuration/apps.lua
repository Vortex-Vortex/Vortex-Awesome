local config_dir = require('gears.filesystem').get_configuration_dir()

return {
    default = {
        terminal = 'terminator'
    },
    run_on_startup = {
        'numlockx on'
    }
}

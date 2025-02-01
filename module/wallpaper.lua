local awful = require('awful')
local gears = require('gears')

local home = os.getenv('HOME')
gears.timer{
    timeout = 600,
    autostart = true,
    call_now = true,
    callback = function()
        awful.screen.connect_for_each_screen(
            function(s)
                awful.spawn.easy_async_with_shell(
                    'ls -1 ~/.wallpapers | shuf -n1',
                    function(stdout)
                        gears.wallpaper.maximized(home .. '/.wallpapers/' .. string.gsub(stdout, '\n', ''), s)
                    end
                )
            end
        )
    end
}

local awful = require('awful')
local gears = require('gears')
local apps = require('configuration.apps')

local to_spawn = {}
local timeout = 0
local function add_to_queue(cmd, times, properties, ignore_timer)
    times = times or 1
    for i = 1, times do
        -- Necessary timeout in order to spawn correctly on tags
        timeout = ignore_timer and timeout or timeout + 0.5
        table.insert(to_spawn, {
            cmd = cmd,
            timeout = ignore_timer and 0 or timeout,
            properties = properties
        })
    end
end

local function run_queue()
    for _, spawn in ipairs(to_spawn) do
        local findme = spawn.cmd:match('^(%w+)%s*')
        awful.spawn.easy_async_with_shell(
            'pgrep -u $USER -x ' .. findme,
            function(stdout)
                if stdout == '' then
                    gears.timer{
                        timeout = spawn.timeout,
                        autostart = true,
                        single_shot = true,
                        callback = function()
                            awful.spawn(spawn.cmd, spawn.properties)
                        end
                    }
                end
            end
        )
    end
end

for _, app in ipairs(apps.run_on_startup) do
    add_to_queue(app, nil, nil, true)
end

add_to_queue('waterfox', 1, { tag = "1" }, true)
add_to_queue('terminator -r spawn_on_2', 3, { tag = "2" })
add_to_queue('telegram-desktop', 1, { tag = "3" }, true)
add_to_queue('pragha ' .. os.getenv('HOME') .. '/Music', 1, { tag = "8" }, true)
add_to_queue('nemo', 3, { tag = "5" })

gears.timer.delayed_call(run_queue)

local awful = require('awful')
local apps  = require('configuration.apps')

local function run_once(cmd, arg_string)
    if not arg_string then
        local findme = cmd
        local firstspace = cmd:find(' ')

        if firstspace then
            findme = cmd:sub(0, firstspace - 1)
        end
        awful.spawn.with_shell(
            string.format(
                'pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd
            )
        )
    else
        awful.spawn.with_shell("pgrep -f -u $USER -x '" .. cmd .. " ".. arg_string .."' || (" .. cmd .. " " .. arg_string .. ")",1)
    end
end

for _, app in ipairs(apps.run_on_start_up) do
    run_once(app)
end


run_once("waterfox --class=SpawnOn1")
run_once("terminator -r SpawnOn2 & terminator -r SpawnOn2 & terminator -r SpawnOn2")
run_once("pragha /home/vortex/Music")
run_once("nemo --class=SpawnOn5 & nemo --class=SpawnOn5 & nemo --class=SpawnOn5")
run_once("telegram-desktop")


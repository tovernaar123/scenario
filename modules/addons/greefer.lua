local Event = require 'utils.event'
local station_name_changer = 
function(event)
    game.print("hi") 
end

Event.add(defines.events.on_player_joined_game,station_name_changer)

local Mini_games = require 'expcore.Mini_games'
local surface
local start  = function ()
    surface = game.surfaces["Race game"]
    local car =  surface.create_entity{name="car", position={-80, -140},force=game.connected_players[1].force}
    car.set_driver(game.connected_players[1])


end


local race = Mini_games.new_game("Race_game")
race:add_map("Race game",-80,-140)
race:add_start_function(start)
local Mini_games = require 'expcore.Mini_games'
local surface
local start  = function ()
    surface = game.surfaces["Race game"]
    local done = 0
    for i, player in ipairs(game.connected_players) do
        local pos
        if (done % 2 == 0) then
            pos = {-85, -132+done*5}
        else
            pos = {-75,132+done*5}
        end
        local car =  surface.create_entity{name="car", position=pos,force=game.connected_players[1].force}
        car.set_driver(game.connected_players[1])
    end

end


local race = Mini_games.new_game("Race_game")
race:add_map("Race game",-80,-140)
race:add_start_function(start)
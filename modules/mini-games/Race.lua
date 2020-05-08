local Mini_games = require 'expcore.Mini_games'
local surface = {}
local gates = {}
local areas = {}


local start  = function ()
    surface[1] = game.surfaces["Race game"]
    local done_left = 0
    local done_right = 0
    local left = true
    for i, player in ipairs(game.connected_players) do
        local pos
        if (left) then
            pos = {-85, -132-done_left*5}
            done_left = done_left +1
            left = false
        else
            pos = {-75,-132-done_right*5}
            done_right = done_right +1
            left = true
        end
        local car =  surface[1].create_entity{name="car", direction= defines.direction.south, position=pos,force="player"}
        car.set_driver(game.connected_players[i])
    end
    
    areas[1] = surface[1].get_script_areas("gate_1")[1].area
    areas[2] = surface[1].get_script_areas("gate_2")[1].area
    areas[3] = surface[1].get_script_areas("gate_3")[1].area
    areas[4] = surface[1].get_script_areas("gate_4")[1].area


end

local turn = function (event)
        
end


local race = Mini_games.new_game("Race_game")
race:add_map("Race game",-80,-140)
race:add_start_function(start)
race:add_var(surface)
race:add_var(gates)
race:add_var(areas)
--race:add_event(defines.on_player_changed_position,turn)
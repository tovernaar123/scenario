local Mini_games = require 'expcore.Mini_games'
local Event = require 'utils.event'
local Token = require 'utils.token'
local task =  require 'utils.task'
local surface = {}
local gates = {}
local areas = {}
local player_progress = {}
local cars = {}
local fuel = {}
local variables = {}
local race = Mini_games.new_game("Race_game")
local token_for_car



local  function setup_gates()
    areas[1] = surface[1].get_script_areas("gate_1_box")[1].area
    areas[2] = surface[1].get_script_areas("gate_2_box")[1].area
    areas[3] = surface[1].get_script_areas("gate_3_box")[1].area
    areas[4] = surface[1].get_script_areas("gate_4_box")[1].area
    local gate_boxes = {}
    gate_boxes[1] = surface[1].get_script_areas("gate_1")[1].area
    gate_boxes[2] = surface[1].get_script_areas("gate_2")[1].area
    gate_boxes[3] = surface[1].get_script_areas("gate_3")[1].area
    gate_boxes[4] = surface[1].get_script_areas("gate_4")[1].area

    --gate
    gates[1] = surface[1].find_entities_filtered{area = gate_boxes[1], name = "gate"} 
    gates[2] = surface[1].find_entities_filtered{area = gate_boxes[2], name = "gate"} 
    gates[3] = surface[1].find_entities_filtered{area = gate_boxes[3], name = "gate"} 
    gates[4] = surface[1].find_entities_filtered{area = gate_boxes[4], name = "gate"} 
end

local start  = function (args)
    surface[1] = game.surfaces["Race game"]
    local done_left = 0
    local done_right = 0
    local left = true
    fuel[1] = args[1]
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
        local car =  surface[1].create_entity{name="car", direction= defines.direction.north, position=pos,force="player"}
        car.set_driver(game.connected_players[i])
        car.get_fuel_inventory().insert({name=fuel[1], count=100})
        cars[car.get_driver().player.name] = car
    end
    
    setup_gates()

    race:add_var(surface)
    race:add_var(gates)
    race:add_var(variables)
    race:add_var(areas)
    race:add_var(player_progress)
    race:add_var(cars)
    race:add_var(fuel)
end

local stop  = function ()
    for i, car in ipairs(cars) do
        car.destroy()
    end
end


local function insideBox(box , pos)
    local x1 = box.left_top.x
    local y1 = box.left_top.y
    local x2 = box.right_bottom.x
    local y2 = box.right_bottom.y

    local px = pos.x
    local py = pos.y
    return px >= x1 and px <= x2 and py >= y1 and py <= y2; 
end 


local player_move = function (event)
    local player = game.players[event.player_index]
    local pos = player.position 
    local name = player.name
    for i, box in ipairs(areas) do
        if insideBox(box,pos) then
            local progress = player_progress[name]
            if not progress then
                player_progress[name] = 1
                progress = 1
            end 
            if progress >= i then 
                for i, gate in ipairs(gates[i]) do 
                    gate.request_to_open(gate.force,100)
                        
                end
                if progress == i and progress ~= 5 then
                    player_progress[name] = player_progress[name] + 1
                else 
                if progress == 5 then
                    player_progress[name] = 1
                end
            end
            end   
        end
    end
end

local respawn_car = function()
    local player = variables[1]
    local car =  surface[1].create_entity{name="car", direction= defines.direction.north , position=variables[2],force="player"}
    car.set_driver(player)
    car.orientation = variables[3]
    car.get_fuel_inventory().insert({name=fuel[1], count=100})   
    cars[variables[1].name] = car
end


token_for_car = Token.register(
    respawn_car
)
race:add_var_global(token_for_car)


local car_destroyed = function (event)
    local dead_car = event.entity 
    if dead_car.name == 'car' then
        variables[1] = dead_car.get_driver().player
        variables[2] = dead_car.position
        variables[3] = dead_car.orientation
        task.set_timeout_in_ticks(180,token_for_car)
        --Event.add_removable_nth_tick(180, token_for_car)
    end
end


race:add_map("Race game",-80,-140)
race:add_start_function(start)
race:add_stop_function(stop)
race:add_event(defines.events.on_player_changed_position,player_move)
race:add_event(defines.events.on_entity_died,car_destroyed)
race:add_option(1)

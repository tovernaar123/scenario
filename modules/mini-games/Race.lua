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

local function insideBox(box , pos)
    local x1 = box.left_top.x
    local y1 = box.left_top.y
    local x2 = box.right_bottom.x
    local y2 = box.right_bottom.y

    local px = pos.x
    local py = pos.y
    return px >= x1 and px <= x2 and py >= y1 and py <= y2; 
end 

local player_progress = {}

local turn = function (event)
    local player = game.players[event.player_index]
    local pos = player.position 
    local name = player.name
    for i, box in ipairs(areas) do
        if insideBox(box,pos) then
            if not player_progress[name] then
                player_progress[name] = 1
            else 
                if player_progress[name] >= i then 
                    for i, gate in ipairs(gates[i]) do 
                        game.print("open")
                        gate.request_to_open(gate.force,100)
                        
                    end
                    if player_progress[name] == i then
                        player_progress[name] = player_progress[name] + 1
                    end
                    if player_progress[name] == 5 then
                        player_progress[name] = 1
                    end
                end
            end   
        end
    end
end


local race = Mini_games.new_game("Race_game")
race:add_map("Race game",-80,-140)
race:add_start_function(start)
race:add_var(surface)
race:add_var(gates)
race:add_var(areas)
race:add_var(player_progress)
race:add_event(defines.events.on_player_changed_position,turn)

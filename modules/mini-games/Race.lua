local Mini_games = require "expcore.Mini_games"
--local Event = require "utils.event"
local Token = require "utils.token"
local task = require "utils.task"
local Permission_Groups = require "expcore.permission_groups"
local Global = require 'utils.global' --Used to prevent desynicing.
local surface = {}
local gates = {}
local areas = {}
local player_progress = {}
local cars = {}
local fuel = {}
local variables = {}
local race = Mini_games.new_game("Race_game")
local token_for_car
local scores = {}
local laps = {}

local function setup_areas()
    areas[1] = surface[1].get_script_areas("gate_1_box")[1].area
    areas[2] = surface[1].get_script_areas("gate_2_box")[1].area
    areas[3] = surface[1].get_script_areas("gate_3_box")[1].area
    areas[4] = surface[1].get_script_areas("gate_4_box")[1].area
    local gate_boxes = {}
    gate_boxes[1] = surface[1].get_script_areas("gate_1")[1].area
    gate_boxes[2] = surface[1].get_script_areas("gate_2")[1].area
    gate_boxes[3] = surface[1].get_script_areas("gate_3")[1].area
    gate_boxes[4] = surface[1].get_script_areas("gate_4")[1].area

    variables["finsih"] = surface[1].get_script_areas("finsish_line")[1].area

    --gate
    gates[1] = surface[1].find_entities_filtered {area = gate_boxes[1], name = "gate"}
    gates[2] = surface[1].find_entities_filtered {area = gate_boxes[2], name = "gate"}
    gates[3] = surface[1].find_entities_filtered {area = gate_boxes[3], name = "gate"}
    gates[4] = surface[1].find_entities_filtered {area = gate_boxes[4], name = "gate"}
end


Global.register({
    surface = surface,
    gates = gates,
    variables = variables,
    areas = areas,
    player_progress = player_progress,
    cars = cars,
    scores = scores,
    laps = laps,
    fuel = fuel
},function(tbl)
    surface = tbl.surface
    gates = tbl.gates
    variables = tbl.variables
    areas = tbl.areas
    player_progress = tbl.player_progress
    cars = tbl.cars
    scores = tbl.scores
    laps = tbl.laps
    
end)

local start = function(args)
    surface[1] = game.surfaces["Race game"]
    variables["done_left"] = 0
    variables["done_right"] = 0
    variables["left"] = true
    variables["error_game"] = nil
    fuel[1] = args[1]
    variables["laps"] = tonumber(args[2])
    if not variables["laps"] then 
        variables["error_game"] = "No laps set"
    end
    if not game.item_prototypes[fuel[1]] then
        variables["error_game"] = "wrong fuel"
    end

    for i, player in ipairs(game.connected_players) do
        local pos
        if (variables["left"]) then
            pos = {-85, -126 + variables["done_left"] * 5}
            variables["done_left"] = variables["done_left"] + 1
            variables["left"] = false
        else
            pos = {-75, -126 + variables["done_right"] * 5}
            variables["done_right"] = variables["done_right"] + 1
            variables["left"] = true
        end
        local car =
            surface[1].create_entity {
            name = "car",
            direction = defines.direction.north,
            position = pos,
            force = "player"
        }
        if not variables["error_game"] then
            car.set_driver(game.connected_players[i])
            car.get_fuel_inventory().insert({name = fuel[1], count = 100})
        end
        cars[player.name] = car
    end

    setup_areas()

    if variables["error_game"] then
        Mini_games.error_in_game(variables["error_game"])
    end
end

local stop = function()
    for i, car in pairs(cars) do
        car.destroy()
    end
    for i,player in ipairs(game.connected_players) do
        if not player.character then
            player.create_character()
        end 
    end
end

local function insideBox(box, pos)
    local x1 = box.left_top.x
    local y1 = box.left_top.y
    local x2 = box.right_bottom.x
    local y2 = box.right_bottom.y

    local px = pos.x
    local py = pos.y
    return px >= x1 and px <= x2 and py >= y1 and py <= y2
end

local player_move = function(event)
    local player = game.players[event.player_index]
    local pos = player.position
    local name = player.name
    local found_match = false
    for i, box in ipairs(areas) do
        if insideBox(box, pos) then
            local progress = player_progress[name]
            if i ~= 5 then
                if progress == i or progress - 1 == i then
                    found_match = true
                    for i, gate in ipairs(gates[i]) do
                        gate.request_to_open(gate.force, 100)
                    end
                    if progress == i and progress ~= 5 then
                        player_progress[name] = player_progress[name] + 1
                    end
                end
            end
        end
    end
    if not found_match then
        if insideBox(variables["finsih"], pos) then
            if player_progress[name] then 
                if player_progress[name] == 5 then
                    player_progress[name] = 1
                    if laps[name] then
                        laps[name] = laps[name] + 1
                    else
                        laps[name] = 1 
                    end
                    player.print(laps[name])
                    local finsihed = false
                    if laps[name] >= variables["laps"] then
                        cars[name].destroy()
                        cars[name] = nil
                        player.character.destroy()
                        finsihed = true
                        if  scores[name].totale_time then
                            scores[name].totale_time = math.round(scores[name].totale_time + (game.tick - scores[name].time),4)
                        else
                            scores[name].totale_time = math.round((game.tick - scores[name].time)/60,4)
                        end
                        game.print(name.." Has finshed "..variables["laps"].." laps in "..scores[name].totale_time.." seconds"..".")
                        if scores[1] then
                            scores[1] =  scores[1] + 1
                        else
                            scores[1] = 1
                        end
                        if scores[1] >= #game.connected_players then
                            Mini_games.stop_game()
                        end
                    end
                    if not finsihed then
                        local time = tostring(math.round((game.tick - scores[name].time)/60,4))
                        if scores[name].totale_time then
                            scores[name].totale_time = scores[name].totale_time + (game.tick - scores[name].time)/60
                        else
                            scores[name].totale_time =  (game.tick - scores[name].time)/60
                        end
                        scores[name].time = game.tick
                        game.print(name.." Has lapped in: "..time.." seconds. Lap "..laps[name].."/"..variables["laps"]..".")
                    end
                end
            else
                scores[name] = {}
                scores[name].time = game.tick
                player_progress[name] = 1
            end
        end
    end
end

local stop_invins = function()
    variables[5].force = "player"
end

local kill_biters = function()
    local biters = surface[1].find_enemy_units(variables[2], 3, "player")
    for i, biter in ipairs(biters) do
        biter.destroy()
    end
end

local function invisabilty(car)
    car.force = "enemy"
    local biters = surface[1].find_enemy_units(variables[2], 50, "player")
    for i, biter in ipairs(biters) do
        biter.set_command({type = defines.command.flee, from = car})
    end
end

local token_for_stop_invins = Token.register(stop_invins)

local token_for_kill_biters = Token.register(kill_biters)


local respawn_car = function()
    local player = variables[1]
    local car =
        surface[1].create_entity {
        name = "car",
        direction = defines.direction.north,
        position = variables[2],
        force = "player"
    }
    car.set_driver(player)
    car.orientation = variables[3]
    car.get_fuel_inventory().insert({name = fuel[1], count = 100})
    cars[variables[1].name] = car

    Permission_Groups.set_player_group(player, variables[4])
    invisabilty(car)

    variables[5] = car
end

token_for_car = Token.register(respawn_car)


local car_destroyed = function(event)
    local dead_car = event.entity
    if dead_car.name == "car" then
        local player = dead_car.get_driver().player
        variables[1] = player
        variables[2] = dead_car.position
        variables[3] = dead_car.orientation
        variables[4] = Permission_Groups.get_group_from_player(player).name
        Permission_Groups.set_player_group(player, "out_car")
        task.set_timeout_in_ticks(180, token_for_car)
        task.set_timeout_in_ticks(190, token_for_kill_biters)
        task.set_timeout_in_ticks(480, token_for_stop_invins)
    end
end

local player_invisabilty = function(event)
    for i, player in ipairs(game.connected_players) do
        if  game.connected_players[i].character then
            game.connected_players[i].character.health = 500
        end
    end
end

local function back_in_car(event)
    local player = game.players[event.player_index]
    if not player.vehicle then
        local car = cars[player.name]
        if car then
            car.set_driver(player)
        end
    end
end

race:add_map("Race game", -80, -140)
race:add_start_function(start)
race:add_stop_function(stop)
race:add_event(defines.events.on_tick, player_invisabilty)
race:add_event(defines.events.on_player_changed_position, player_move)
race:add_event(defines.events.on_entity_died, car_destroyed)
race:add_event(defines.events.on_player_driving_changed_state, back_in_car)
race:add_option(2)

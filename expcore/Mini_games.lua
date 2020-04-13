local Token = require 'utils.token' 
local Event = require 'utils.event'
local Commands = require 'expcore.commands'
require 'config.expcore-commands.auth_runtime_disable' --required to load befor running the script


local Mini_games = {
    mini_games={},
    _prototype={},
}

local started_game = {}

local Global = require 'utils.global' --Used to prevent desynicing.
Global.register({
    started_game = started_game 
},function(tbl)
    started_game = tbl.started_game
end)





local function internal_error(success,error_message)
    if not success then
        game.print("Their is an error please contact the admins, error: "..error_message)
        log(error_message)
    end
end


function Mini_games.new_game(name)
    local mini_game = setmetatable({
        name=name,
        events = {},
        commands = {},
        start_function= nil,
        stop_function = nil,
    }, {
        __index= Mini_games._prototype
    })
    Mini_games.mini_games[name] = mini_game
    return mini_game
end

function Mini_games._prototype:add_start_function(start_function)

    self.start_function = start_function   
end

function Mini_games._prototype:add_stop_function(start_function)
    self.start_function = start_function    
end

function Mini_games._prototype:add_command(command_name)
    self.commands[#commands + 1] = command_name
    Commands.disable(command_name)
end


function Mini_games._prototype:add_event(event_name,func) 
    local handler = Token.register(
        func
    )
    self.events[#self.events+1] = {handler,event_name}
     
end


function Mini_games.start_game(name)
    local mini_game = Mini_games.mini_games[name]

    if mini_game == nil then
        error("This mini_game does not exsit")
    end

    if started_game[1] == name then
        error("This game is already running")
    end
    if started_game[1] then
        Mini_games.stop_game(started_game[1])
    end


    started_game[1] = name
    for i,value  in ipairs(mini_game.events) do 
        local handler = value[1]
        local event_name = value[2]
        Event.add_removable(event_name,handler)
    end
    
    for i,command_name  in ipairs(mini_game.commands) do 
        Commands.enable(command_name)
    end

    local start_func = mini_game.start_function
    if start_func then 
        local success, err = pcall(start_func)
        internal_error(success,err)
    end
end


function Mini_games.stop_game(name)
    local mini_game = Mini_games.mini_games[name]
    if mini_game == nil then
        error("This mini_game does not exsit")
    end
    if started_game[1] ~= name  then
        error("This mini_game is not running")
    end
    
    started_game[1] = nil
    for i,value  in ipairs(mini_game.events) do 
        local handler = value[1]
        local event_name = value[2]
        Event.remove_removable(event_name, handler)
    end

    for i,command_name  in ipairs(mini_game.commands) do 
        Commands.disable(command_name)
    end

    local stop_func = Mini_games.mini_games[name].stop_function
    if stop_func then
        local success, err =  pcall(stop_func)
        internal_error(success,err)
    end
end


return Mini_games
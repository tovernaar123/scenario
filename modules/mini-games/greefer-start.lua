local Commands = require 'expcore.commands'
local Event = require 'utils.event' --- @dep utils.event
local Permission_Groups = require 'expcore.permission_groups'
require 'config.expcore-commands.parse_general'

local greefers = {}
local good_players = {}
local is_started = false
local votes = {}
local who_voted = {}
local out = {}
local cought =0
local Time = 0


local function reset_all()
    is_started = false
    greefers = {}
    good_players = {}
    votes = {}
    who_voted = {}
    out = {}
    cought = 0
    Time = 0
    for i, player in pairs(game.players) do
        if player.admin then
            Permission_Groups.set_player_group(player,"Admin") 
        else
            Permission_Groups.set_player_group(player,"Guest")
        end
    end 
    
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function tell_players()
    for i, player in ipairs(greefers) do
        player.print("You are the greefer, stop the good-guys from finishing the goal.")
    end

    for i, player in ipairs(good_players) do
        player.print("You are a good-guy, finish the goal.")
    end
end

Commands.new_command('start','Command to start greefer game.')
    :add_param('amount_of_greefers',false,'number')
    :add_param('time_in_min',false,'number')
    :register(
        function(player,amount_of_greefers,time,raw)
            local online = #game.players
            if online < amount_of_greefers then 
                return Commands.error("Thats to many greefers.") 
            end

            reset_all()
            is_started = true

            Time = 60*60*time -- time in ticks
            for i, player in pairs(game.players) do
                good_players[i] = player 
            end

            local amount_tries = 100
            for i = 1 ,amount_of_greefers do 
            if amount_tries > 0 then    
                    local random = math.random(1,online)
                    local greefer = game.players[random]
                    if not has_value(greefers, greefer) then
                        greefers[i] = greefer
                        good_players[random] = nil
                    else
                        i = i-1
                        amount_tries = amount_tries-1
                    end
                end
            end

            cought = #greefers
            tell_players()

        end)

Commands.new_command('add','Command to add a greefer.')
        :add_param('amount_of_greefers',false,'number')
        :register(
            function(player,amount_of_greefers,raw)
                if is_started then
                    local amount_tries = 100
                    for i = 1 ,amount_of_greefers do 
                        if amount_tries > 0 then    
                            local random = math.round(math.random(1,#game.players))
                            local greefer = game.players[random]
                            if not has_value(greefers, greefer) then
                                greefers[i] = greefer
                                good_players[random] = nil
                            else
                                i = i-1
                                amount_tries = amount_tries-1
                            end
                        end
                    end
                    tell_players()
                else 
                    return Commands.error("Please use /start first.")
                end
            end)

Commands.new_command('vote','Command to vote out the greefers.')
    :add_param('name_of_greefer',false)
    :register(
        function(player,name_of_greefer,raw)
            if  not is_started then
                return Commands.error("The game is not started use /start (amountofgreefers time).") 
            end
            if game.players[name_of_greefer] == nil then
                return Commands.error("Please use a in-game name for the parrameter.") 
            end
            if  out[name_of_greefer] ~= true then 
                return Commands.error("This player is already out.") 
            end
            if out[player.name] == true then
                return Commands.error("You cant vote when you are out.")
            end
            if who_voted[player.name] ~= nil then
                votes[who_voted[player.name]] = votes[who_voted[player.name]]-1
            end

            local voted = votes[name_of_greefer]
            if voted ~= nil then 
                voted = voted + 1
            else 
                voted = 1
            end

            votes[name_of_greefer] = voted
            who_voted[player.name] = name_of_greefer
            local required_votes = math.round((#game.players-#out)/2)

            if votes[name_of_greefer] >= required_votes then
                local the_one = game.players[name_of_greefer]
                out[name_of_greefer] = true
                Permission_Groups.set_player_group(the_one,"Voted_out")
                if has_value(greefers,the_one) then
                    game.print(name_of_greefer.." Was a greefer and has been voted out! All votes have been reset.")
                else
                    game.print(name_of_greefer.." Was NOT a greefer but has been voted out! All votes have been reset.")
                end
                if cought > 1 then
                    game.print("Their are "..cought.." greefers left.")
                    cought = cought-1
                else 
                    game.print("Their are 0 greefers left VICTORY!")
                    reset_all()
                end
                votes = {}
                who_voted = {}
            else
                game.print(name_of_greefer.." has "..votes[name_of_greefer].." out of "..required_votes.." to be kicked.")
            end
        end)

Commands.new_command('win','Command to call out a win for the good guys.')
    :register(function(player,raw)
        if is_started then
            game.print("VICTORY!!!, the greefers where:")
            for i, player in ipairs(greefers) do
                game.print(player.name)
            end
            reset_all()
        else 
            return Commands.error("The game is not started use /start (amountofgreefers time).")
        end
    end)

Commands.new_command('time_left','Command to call out a win for the good guys.')
    :register(function(player,raw)
        if is_started then
            player.print("You have "..tostring(math.round(Time/3600)).." more minutes.")
        else 
            return Commands.error("The game is not started use /start (amountofgreefers time).") 
        end
    end)

Event.add(defines.events.on_tick, function(event)
    if is_started then
        Time = Time -1
        if Time < 1 then  
            game.print("The good-guys have lost, use /start to start a new round")
            for i, player in ipairs(greefers) do
                game.print(player.name.." Was a greefer.")
            end
            reset_all()
        end
    end
end)
local Commands = require 'expcore.commands'
local Event = require 'utils.event' --- @dep utils.event
local Permission_Groups = require 'expcore.permission_groups'
require 'config.expcore-commands.parse_general'
--[[
    This is the code for the greefer game.
    In short their are a number of greefer that need to stop the good-guys for finishing the goal.
    But the greefer shood be suttle as they can be voted out bye anyone with /vote.
    To start the game smiply do /start number_of_greefers time_to_reach_goal.
--]]



local greefers = {} --all the greefers
local votes = {} --all the votes
local who_voted = {} --the people who voted
local out = {} -- all the players that were voted out


local Table_for_varibaibels = { 
    started = false, --Check if /start has been used.
    Time = 0, --The time left in ticks.
    cought = 0, -- Used to determine how many players where found to be greefer.
}

local function reset_all() -- Resets all tables and vars so /start can be used again.
    Table_for_varibaibels["started"] = false
    greefers = {}
    votes = {}
    who_voted = {}
    out = {}
    Table_for_varibaibels["cought"] = 0
    Table_for_varibaibels["Time"] = 0
    for i, player in pairs(game.connected_players) do
        if player.admin then
            Permission_Groups.set_player_group(player,"Admin") 
        else
            Permission_Groups.set_player_group(player,"Guest")
        end
    end 
    
end

local function has_value (tab, val) -- Checks if a table has a value.
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end



local function tell_players() --Tells the players if they are greefer or a good-guy.
    local done = {}
    for i, player in ipairs(greefers) do
      done[player.index] = true
      player.print("You are the greefer, stop the good-guys from finishing the goal.")
    end
    
    for index,player in pairs(game.connected_players) do
      if not done[index] then
        player.print("You are a good-guy, finish the goal.")
      end
    end
end



local Global = require 'utils.global' --Used to prevent desynicing.
Global.register({
  Table_for_varibaibels = Table_for_varibaibels, 
  votes = votes,
  who_voted = who_voted, 
  out = out,  
  greefers = greefers,
},function(tbl)
  Table_for_varibaibels = tbl.Table_for_varibaibels
  votes = tbl.votes 
  who_voted = tbl.who_voted 
  out = tbl.out  
  greefers = tbl.greefers
end)
Commands.new_command('start','Command to start greefer game.') --Used to start the game (always needs to be run first).
    :add_param('amount_of_greefers',false,'number')
    :add_param('time_in_min',false,'number')
    :register(function(player,amount_of_greefers,time,raw)
            local online = #game.connected_players
            game.print(online)
            if online < amount_of_greefers then 
                return Commands.error("Thats to many greefers.") 
            end

            reset_all()
            Table_for_varibaibels["started"] = true

            Table_for_varibaibels["Time"] = 3600*time -- time in ticks
            -- for i, player in pairs(game.connected_player) do
            --     good_players[i] = player 
            -- end

            local i = 0

            while i < amount_of_greefers do 
                local random = math.random(1,online)
                local greefer = game.connected_players[random]
                if not has_value(greefers, greefer) then
                  i = i + 1
                  greefers[i] = greefer
                end
            end

            Table_for_varibaibels["cought"] = #greefers
            tell_players()

        end)

Commands.new_command('add','Command to add a greefer.') --Adds a greefer (admin only).
        :add_param('amount_of_greefers',false,'number')
        :register(function(player,amount_of_greefers,raw)
                if Table_for_varibaibels["started"] then
                    local online = #game.connected_players
                    local i = 0

                    while i < amount_of_greefers do 
                        local random = math.random(1,online)
                        local greefer = game.connected_players[random]
                        if not has_value(greefers, greefer) then
                            i = i + 1
                            greefers[i] = greefer
                            Table_for_varibaibels["cought"] = Table_for_varibaibels["cought"] +1
                        end
                    end
                    tell_players()
                else 
                    return Commands.error("Please use /start first.")
                end
            end)

--Used to vote peopol out.
Commands.new_command('vote','Use /vote to vote out players that you think are greefers.')
    :add_param('name_of_greefer',false)
    :register(
        function(player,name_of_greefer,raw)
            name_of_greefer = tostring(name_of_greefer)
            if  not Table_for_varibaibels["started"] then
                return Commands.error("The game is not started use /start (amountofgreefers time).") 
            end
            if not game.players[name_of_greefer] or not game.players[name_of_greefer].connected then
                return Commands.error("Please use a in-game name for the parrameter.") 
            end
            if  out[name_of_greefer] == true then 
                return Commands.error("This player is already out.") 
            end
            if out[player.name] == true then
                return Commands.error("You cant vote when you are out.")
            end
            local who = who_voted[player.name]
            if who ~= nil then
                votes[who] = votes[who] - 1
            end

            local voted = votes[name_of_greefer]
            if voted ~= nil then 
                voted = voted + 1
            else 
                voted = 1
            end

            votes[name_of_greefer] = voted
            who_voted[player.name] = name_of_greefer
            local required_votes = math.round((#game.connected_players-#out)/2)

            if votes[name_of_greefer] >= required_votes then
                local the_one = game.players[name_of_greefer]
                out[name_of_greefer] = true
                Permission_Groups.set_player_group(the_one,"Voted_out")
                if has_value(greefers,the_one) then
                    game.print(name_of_greefer.." Was a greefer and has been voted out! All votes have been reset.")
                    if Table_for_varibaibels["cought"] > 1 then
                        game.print("Their are "..Table_for_varibaibels["cought"].." greefers left.")
                        Table_for_varibaibels["cought"] = Table_for_varibaibels["cought"]-1
                    else 
                        game.print("There are 0 griefers left VICTORY, you still had ".. math.ceil(Table_for_varibaibels["Time"]/3600).." minutes left.")
                        reset_all()
                    end
                else
                    game.print(name_of_greefer.." Was NOT a greefer but has been voted out! All votes have been reset.")
                end
                votes = {}
                who_voted = {}
            else
                game.print(name_of_greefer.." has "..votes[name_of_greefer].." out of "..required_votes.." to be kicked.")
            end
        end)

--Used to win the game after goal has been done (admin only).
Commands.new_command('win','Command to call out a win for the good guys.')
    :register(function(player,raw)
        if Table_for_varibaibels["started"] then
            game.print("VICTORY!!!, the greefers where:")
            for i, player in ipairs(greefers) do
                game.print(player.name)
            end
            reset_all()
        else 
            return Commands.error("The game is not started use /start (amountofgreefers time).")
        end
    end)

--Shows the time left.
Commands.new_command('time_left','Command to call out a win for the good guys.')
    :register(function(player,raw)
        if Table_for_varibaibels["started"] then
            player.print("You have "..math.ceil(Table_for_varibaibels["Time"]/3600).." more minutes.")
        else 
            return Commands.error("The game is not started use /start (amountofgreefers time).") 
        end
    end)

--Shows all votes.
Commands.new_command('all_votes','Command to see all votes.')
    :register(function(player,raw)
        for i,num in pairs(votes) do
            player.print(i.." Has"..num.." Votes")
        end

    end)
--Clears all votes.
Commands.new_command('clear_votes','Command to clear all votes.')
    :register(function(player,raw)
        votes = {}
        who_voted = {}

    end)

--Handles time and print when time is up.    
Event.on_nth_tick(300,function(event)
    if Table_for_varibaibels["started"] then
        Table_for_varibaibels["Time"] = Table_for_varibaibels["Time"] -300
        if Table_for_varibaibels["Time"] < 1 then  
            game.print("The good-guys have lost, use /start to start a new round")
            for i, player in ipairs(greefers) do
                game.print(player.name.." Was a greefer.")
            end
            reset_all()
        end
    end
end)

--runs when player leaves.
Event.add(defines.events.on_player_left_game,
function(event)
    local found_player = false
    local  player_left = game.players[event.player_index]
    for i, player in ipairs(greefers) do
        if player == player_left then
            found_player = true
            Table_for_varibaibels["cought"] = Table_for_varibaibels["cought"] -1
            game.print(player_left.name" Was a greefer!")
        end
    end
    if not found_player then 
        for i, player in pairs(out) do
            if i == player_left.name then
                out[i] = nil
                found_player = true
                game.print(player_left.name.." Was out.")
            end
        end
    end
    if not found_player then 
        game.print(player_left.name.." Was a good guy.")
    end

    local who = who_voted[player_left.name]
    if who ~= nil then
        votes[who] = votes[who] - 1
        who_voted[player_left.name] = nil
    end

    



end)

--runs when player joins
Event.add(defines.events.on_player_joined_game,
function(event)
    local  player = game.players[event.player_index]
    player.print("Welcome to the minigame [color=red] griefer TTT [/color] to start the game us ''/start [time] [griefer amount]. \n use /vote [suspect name] to vote out the player that you think is the griefer. \n /add is used to add a random griefer. \n With /time_left you can see how much time you still have to finish your goal. ")
end)
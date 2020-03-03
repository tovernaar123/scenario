local Commands = require 'expcore.commands'
require 'config.expcore-commands.parse_general'
local greefers = {}
local good_players = {}
local is_started = false



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

Commands.new_command('start','command to start greefer game')
    :add_param('amount_of_greefers',false,'number')
    :register(
        function(player,amount_of_greefers,raw)
            is_started = true
            greefers = {}

            
            for i, player in pairs(game.players) do
                good_players[i] = player 
            end
            game.print(#good_players.." amountf")

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

            game.print(#good_players.." amount")

            tell_players()

        end)

Commands.new_command('add','command to add a greefer')
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

Commands.new_command('vote','command to vote out the greefers')
    :add_param('name_of_greefer',false)
    :register(
        function(player,name_of_greefer,raw)
            if game.players[name_of_greefer] ~= nil then
            else 
                Commands.error("Please use a in-game name for the parrameter.") 
            end
        end)
local Commands = require 'expcore.commands'
require 'config.expcore-commands.parse_general'
local greefers = {}
Commands.new_command('start','command to start greefer game')
    :add_param('amount_of_greefers',false,'number')
    :register(
        function(player,amount_of_greefers,raw)
            greefers = {}
            --game.print(#game.players)

            for i = 1 ,amount_of_greefers do 
                greefers[i] = game.players[math.round(math.random(1,#game.players))]
            end
            game.print(#greefers.." amount")
            for i, player in pairs(greefers) do
               player.print("you are the greefer")
            end
        end)
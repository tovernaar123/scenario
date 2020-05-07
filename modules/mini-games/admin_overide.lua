local Mini_games = require 'expcore.Mini_games'
local Commands = require 'expcore.commands'




Commands.new_command('stop','Command to call out a win for the good guys.')
:add_param('name_of_game',false)
:register(function(player,name_of_game,raw)
    Mini_games.stop_game(name_of_game)
end)


Commands.new_command('start','Command to call out a win for the good guys.')
:add_param('name_of_game',false)
:register(function(player,name_of_game,raw)
    Mini_games.start_game(name_of_game)
end)
local Mini_games = require 'expcore.Mini_games'
local Commands = require 'expcore.commands'


local mini_game = Mini_games.new_game("test")
mini_game:add_start_function(function()
    game.print("started") 
end)
mini_game:add_event(defines.events.on_built_entity,function(event)
    game.print("event")
end)
Commands.new_command('test','Command to call out a win for the good guys.')
:register(function(player,raw)
    Mini_games.start_game("test")
end)

Commands.new_command('stop','Command to call out a win for the good guys.')
:register(function(player,raw)
    Mini_games.stop_game("test")
end)

local Mini_games = require 'expcore.Mini_games'


local game = Mini_games.new_game("Race_game")
game:add_map("Race game",-80,-140)
game:add_event(defines.events.on_player_joined_game,function(arg1)
    local  player = game.players[event.player_index]
    player.print("hi")
end)
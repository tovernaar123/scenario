/c  local start = {226,-30}
    local End = {447,222}
    local size = 32
    for x=start[1],End[1],size do
        for y=start[2],End[2],size do
            local biters = game.surfaces["Race game"].get_entities_with_force({x/32,y/32}, "enemy")
            for i, biter in pairs(biters) do
                if biter.type == 'unit' then
                    biter.set_command({type=defines.command.wander,ticks_to_wait=1})
                end
              
            end
        end
    end

/interface player.selected.damage(1, "player")
      --biter.set_command({type=defines.command.attack_area,destination={351,100},radius=100})
      game.print(#biters)
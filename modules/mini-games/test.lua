local surface = game.player.surface
local entities = surface.find_entities_filtered{area = area}
for k, wall in pairs(entities) do
    wall.minable  =false 
    wall.destructible = false
end

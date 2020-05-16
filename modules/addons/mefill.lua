local Event = require 'utils.event' --- @dep utils.event
local ammo = {
    "uranium-rounds-magazine",  -- importent to have at top so it will pick the best one
    "piercing-rounds-magazine",
    "firearm-magazine"
}


--Supporter
local function mefill(event)
    local player =  game.players[event.player_index]
    if player then
        local entity = event.created_entity 
        if entity.type == 'ammo-turret' then
            local inv = player.get_main_inventory()
            local turret_inv = entity.get_inventory(defines.inventory.turret_ammo)
            for i,ammo in ipairs(ammo) do 
                local ammo_found = inv.get_item_count(ammo)
                if ammo_found ~= 0 then
                    -- todo remove on item stack https://lua-api.factorio.com/latest/LuaInventory.html#LuaInventory.remove
                    game.print("found")
                    break 
                end
            end
        end
    end
end




Event.add(defines.events.on_built_entity,mefill)
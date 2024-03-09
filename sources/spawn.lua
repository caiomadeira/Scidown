#include "sources/prefab.lua"
#include "sources/utils.lua"
#include "sources/commons/constants.lua"
#include "../settings.lua"

--[[
**************************************************************
PopulateSpace()

--------------------------------------------------------------
Populate scene with celestial bodies with random spawn
**************************************************************
]]--


function PopulateWorldWith(EntityGroup) -- EntityGroup as world properties prefab
    print("[+] PopulateSpace() Called")
    -- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    -- LOCAL CONTROL VARIABLES FOR SPAWN RULES
    -- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    local maxEntityAmount = 5;
    local minDistFromPlayer = 40;
    local entityPrefabBuffer = {  }; -- Store all entities (remember to use gargagecollector() to remove this buffer from memory)

    -- Check ifs EntityGroup table is not nill
    if (EntityGroup ~= nil) then 
        -- 1. Iterate over the entities, get the prefab and select someone to spawn
        for _, v in pairs(EntityGroup) do
            for k2, _ in pairs(v) do -- Iterate again over the properties
                if k2 == 'prefab' then -- Check if the entity has a prefab key
                    table.insert(entityPrefabBuffer, v) -- add to buffer
                end
            end
        end

        -- 2. Iterate over entity prefab buffer and select prefabs to spawn
        -- based in count
        local rangeSpawnValues = { 'LOW', 'MEDIUM', 'HIGH'}
        for i=1, maxEntityAmount do
            for j=1, #rangeSpawnValues do
                CreateCelestialBody(entityPrefabBuffer[i], true, rangeSpawnValues[j])
            end
        end
    end
end

function RandomPosition(rangeInterval)
    local x, y, z;
    local pos;

    -- World constants values
    if rangeInterval == 'HIGH' then
        x = math.random(-200, 240) -- width min max
        y = math.random(-20, 130) -- height min max
        z = math.random(-260, 260) -- depth min max
    elseif rangeInterval == 'MEDIUM' then
        x = math.random(-120, 200)
        y = math.random(-80, 110)
        z = math.random(-120, 240)
    elseif rangeInterval == 'LOW' then
        x = math.random(-300, 300)
        y = math.random(-50, 100)
        z = math.random(-300 / 3, 300)
    else
        x = math.random(-80, 80)
        y = math.random(-20, 120)
        z = math.random(-80, 80)
    end

    pos = Vec(x, y, z)

    print("[+] RandomPosition: RandomPosition: ", VecStr(pos))
    return pos;
end
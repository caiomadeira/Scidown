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

        -- Check if 

        -- 2. Iterate over entity prefab buffer and select prefabs to spawn
        -- based in count
        local rangeSpawnValues = { 'LOW', 'MEDIUM', 'HIGH'}
        for i=1, maxEntityAmount do
            CreateCelestialBody(entityPrefabBuffer[i], true, rangeSpawnValues[i])
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

function SpawnPlayer(where)
    local t
    if where == 'zero' then
        t = Transform(Vec(Player.SpawnPoints.zero[1],
                            Player.SpawnPoints.zero[2],
                            Player.SpawnPoints.zero[3]), 
                            QuatEuler(0, 0, 0))
        SetPlayerSpawnTransform(t)

    elseif where == 'safehouse' then
        t = Transform(Vec(Player.SpawnPoints.safehouse[1],
                            Player.SpawnPoints.safehouse[2],
                            Player.SpawnPoints.safehouse[3]), 
                            QuatEuler(0, 0, 0))
        SetPlayerSpawnTransform(t)

    elseif where == 'testLocation' then
        t = Transform(Vec(Player.SpawnPoints.testLocation[1],
                            Player.SpawnPoints.testLocation[2],
                            Player.SpawnPoints.testLocation[3]), 
                            QuatEuler(0, 0, 0))
        SetPlayerSpawnTransform(t)
    else
        DebugPrint("Error: 'where' param passed is not allowed.")
    end
end

function SpawnStructure(structure)
    local prefabXml;
    local spawnTransform;

    if structure == 'safehouse' then
        prefabXml = CreateXMLPrefab(Building.safehouse.ground)
        spawnTransform = Transform(ConvertStrToTable(Building.safehouse.ground.pos))
        Spawn(prefabXml, spawnTransform, true)

        prefabXml = CreateXMLPrefab(Building.safehouse.base)
        spawnTransform = Transform(ConvertStrToTable(Building.safehouse.base.pos))
        Spawn(prefabXml, spawnTransform, true)
    end
end

function SpawnVehicle(vehicle)
    Spawn(vehicle.xmlPath, Transform(Vec(11.0, 8.3, 5.7), Vec(0.0, 0.0, 0.0)))
    
    -- Check if the vehicle was created
    local checkVehicle = FindVehicle(vehicle.tag)
    if checkVehicle ~= 0 then
        DebugPrint(":::::::::::::::::[" .. Vehicle.spaceship.name .. "] CREATED ::::::::::::::::::::::")
        DebugPrint("VEHICLE INSTANCE NUM >> " .. tostring(checkVehicle))
        DebugPrint("VEHICLE TRANSFORM >> " .. TransformStr(GetVehicleTransform(checkVehicle)))
        DebugPrint("PLAYER TRANSFORM >> " .. TransformStr(GetPlayerTransform()))
        DebugPrint("::::::::::::::::::::::::::::::::::::::::::")
    else
        DebugPrint(":::::::::::::::::ERROR: [" .. Vehicle.spaceship.name .. "] NOT CREATED ::::::::::::::::::::::")
    end
end
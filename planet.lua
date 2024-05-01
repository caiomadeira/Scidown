#include "sources/environment.lua"
#include "sources/player.lua"
#include "sources/utils.lua"
#include "sources/world.lua"
#include "sources/prefab.lua"
#include "sources/vehicle/vehicle.lua"
#include "sources/registry.lua"
#include "sources/particles.lua"
#include "sources/debug.lua"
#include "sources/spawn.lua"
#include "settings.lua"

local player

function init()
    print("::::::::::::::::::::::::::::::::::::::::")
    print("::::::::::::::::::::::::::::::::::::::::")
    print("::::::::::   PLANET 1 SCENE      :::::::")
    print("::::::::::::::::::::::::::::::::::::::::")
    print("::::::::::::::::::::::::::::::::::::::::")
    SetString("level.name", 'planet1')
    if GetString("level.name") == 'planet1' then
        player = Player:new(nil)
        player:init()
        CreateBaseTerrain()
        SpawnPlayer('planet_sky')
        SpawnVehicle(Vehicle.spaceship, Transform(Vec(5.0, 40.0, 10.0), Vec(0.0, 0.0, 0.0)))
        DriveSpaceship()
    end
    --RemoveEntitiesFromScene()
end

function tick(dt)
    player:tick(dt)
    VehicleTick()
end

function update(dt)
    player:update(dt)
end


function RemoveEntitiesFromScene()
    local bodies_to_rm = {  }
    local body;
    for i=1, #CONSTANTS.TAGS do
        body = FindBody(CONSTANTS.TAGS[i], true)
        table.insert(bodies_to_rm, body[i])
        --Delete(body[i])
    end

    for i=1, #bodies_to_rm do
        print("body" .. bodies_to_rm[i] .. "removed")
    end
end

function CreateBaseTerrain()
    print("BASE TERRAIN")
    local prefabXml = CreateXMLPrefab(Building.planet.ground)
    local spawnTransform = Transform(ConvertStrToTable(Building.planet.ground.pos))
    Spawn(prefabXml, spawnTransform, true)
end

function DriveSpaceship()
    local v = FindVehicle(Vehicle.spaceship.tag, true)
    if v ~= nil then
        SetPlayerVehicle(v)
        return 1
    else
        return 0
    end
end
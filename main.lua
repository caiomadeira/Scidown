#include "sources/enviroment.lua"
#include "sources/player.lua"
#include "sources/utils.lua"
#include "sources/world.lua"
#include "sources/prefab.lua"
#include "sources/vehicle.lua"
#include "sources/registry.lua"

frame = 0

function init()
    DebugPrint("init main.lua")
    loadCustomEnvironment(1, false)
    PlayerInit()
    SetupRegistry()
    -- CreateDynamicPlanet()
    -- CreateXMLPrefab(Prefabs.moon2, true)
    -- CreateXMLPrefab(Prefabs.moon3Voxbox, true)
    -- SpawnPrefab(Prefabs.moon2)
    -- SpawnPrefab(Prefabs.moon3Voxbox)
    -- SpawnSafeHouse()


    -- SpawnObjectAccordingPlayerPos(Prefabs.moon2, 50, 50, 50)
    -- SpawnObjectAccordingPlayerPos(Prefabs.moon3Voxbox, 70, 20, 20)
    SpawnSpaceShip(Vehicles.SpaceshipSmall1)
end

function tick()
    PlayerTick()
    VehicleTick()
end

function update(dt)
    -- DebugPlayer()
    PlayerUpdate(dt)

--[[ 
    if Player.isInVehicle then
        DebugPrint("> Player is in vehicle")
        -- SPACESHIP CONTROLS
        if InputDown("up") then
            local vehicle = GetPlayerVehicle()
            --DebugPrint("> GetPlayerVehicle handle: " .. tostring(vehicle))
            --DebugPrint("> GetPlayerVehicle handle: " .. tostring(vehicle))
            --DebugPrint("> FindBody(spaceship_small1): " .. tostring(FindBody(Vehicles.SpaceshipSmall1.name, true)))
            shape = FindBody("spaceship_small1")
            DebugPrint(">> shape: " .. tostring(shape))
            local transform = Transform(Vec(20, 29, 20), QuatEuler(0, 90, 0))
            SetShapeLocalTransform(shape, transform)
            DebugPrint("FORWARD PRESSED")
        end
    else
        DebugPrint("x Player is NOT in vehicle")
    end
     ]]--
end
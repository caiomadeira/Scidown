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
    SpawnSpaceShip(Vehicles.suv1)
end

function tick()
    PlayerTick()

    -- PART OF SPACESHIP CONTROLS LOGIC
    IsPlayerInVehicle()

    if Player.isInVehicle then
        --local vehicle = GetPlayerVehicle()
        --local vehicleTransform = GetBodyTransform(vehicle)
       --DebugPrint("> Player is in vehicle")
       -- DebugPrint("VEHICLE HANDLE: " .. vehicle)
       -- DebugPrint("VEHICLE INITIAL TRANSFORM: " .. TransformStr(vehicleTransform))

        -- SPACESHIP CONTROLS
        if InputDown("up") then
            DebugPrint("FORWARD PRESSED")
            local t = Transform(Vec(50, 50, 50), QuatEuler(0, 90, 0))
            SetPlayerTransform(t)
        end

        if InputDown('space') then
            --vehicleTransform.pos = VecAdd(vehicleTransform.pos, Vec(100, 10, 100))
            --SetBodyTransform(vehicle, vehicleTransform)
            --DebugPrint("VEHICLE NEW TRANSFORM: " .. TransformStr(vehicleTransform))
            DebugPrint("SPACE PRESSED")
        end

    else
        --DebugPrint("x Player is NOT in vehicle")
    end
end

function update(dt)
    -- DebugPlayer()
    PlayerUpdate(dt)
end
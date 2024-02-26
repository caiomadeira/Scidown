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
    -- PrintRegistryKeys("game.player.tool")
    DisablePlayerDefaultTools()

    --SpaceShipCameraMovement()
end

function update(dt)
    -- DebugPlayer()
    PlayerUpdate(dt)
end
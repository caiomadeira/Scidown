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


    SpawnObjectAccordingPlayerPos(Prefabs.moon2, 40, 70, 80)
    SpawnObjectAccordingPlayerPos(Prefabs.planet1, 70, 20, 20)
    SpawnSpaceShip(Vehicles.SpaceshipSmall1)
    -- CreateCustomCelestialBody(CelestialBodyConfig.STAR)

    star = {
        name = 'moon1',
        tags = 'moon1',
        pos = '0.0 0.0 0.9',
        rot = "0 0 0",
        desc ="A beatiful moon",
        texture = "30",
        blendtexture = "10",
        density = "100",
        strength = "100",
        collide = "true",
        prop = "true", -- allows to create a dynamic body
        size = "40 39 40",
        brush ="MOD/assets/models/star.vox",
        material = "rock",
        color = '0.72 0.12 0.32',
    }

    CreateStar(star)

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
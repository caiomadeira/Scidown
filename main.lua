#include "sources/enviroment.lua"
#include "sources/player.lua"
#include "sources/utils.lua"
#include "sources/world.lua"
#include "sources/prefab.lua"

frame = 0

function init()
    DebugPrint("init main.lua")
    loadCustomEnvironment(1, false)
    SpawnPlayer('safehouse')
    -- CreateDynamicPlanet()
    --CreateXMLPrefab(Prefabs.moon2, true)
    --CreateXMLPrefab(Prefabs.moon3Voxbox, true)
    SpawnPrefab(Prefabs.moon2)
    SpawnPrefab(Prefabs.moon3Voxbox)
    GetWorldSize()
end

function tick()
    PlayerTick()
end

function update(dt)
    PlayerUpdate(dt)
end

--[[
-- Calls it in update(dt)
-- Maybe should i use this like a blackhole proximity effect?
-- To make a crazy effect i need to increment frame = frame + 1 and call to tick()
function crazyGravityEffect(frame)
    SetPlayerVelocity(VecAdd(GetPlayerVelocity(), Vec(0, 10*frame, 0)))
end
]]--
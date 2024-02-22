#include "enviroment.lua"
#include "player.lua"
#include "utils.lua"

frame = 0

function init()
    DebugPrint("init main.lua")
    loadCustomEnvironment(1, true)
    SpawnPlayer('safehouse')
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
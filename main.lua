#include "enviroment.lua"
#include "player.lua"
#include "utils.lua"

frame = 0

canJump = false

function init()
    DebugPrint("init main.lua")
    loadCustomEnvironment(1, true)
end

function tick()
    if InputPressed("jump") then
        DebugPrint("[+] Jump Pressed")
        canJump = true
    elseif InputReleased("jump") then
        DebugPrint("[+] Jump Released")
        canJump = false
    end
end

function update(dt)
    debugPlayerTransform()

    if canJump then
        playerJumpGravity(dt, 10)
    else
        playerJumpGravity(dt, 0)
    end
end

--[[
-- Calls it in update(dt)
-- Maybe should i use this like a blackhole proximity effect?
-- To make a crazy effect i need to increment frame = frame + 1 and call to tick()
function crazyGravityEffect(frame)
    SetPlayerVelocity(VecAdd(GetPlayerVelocity(), Vec(0, 10*frame, 0)))
end
]]--
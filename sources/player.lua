#include "utils.lua"

Player = {
    canJump = false,
    jumpMaxVelocity= 10,
    jumpMinVelocity = 0,
    maxJumpHeight = 4,
}

-- ::::::::::::::::::::::::::::::::::::::
--  LIFE CYCLE FUNCTIONS
-- ::::::::::::::::::::::::::::::::::::::

function PlayerTick()
    if InputPressed("jump") then
        DebugPrint("[+] Jump Pressed")
        Player.canJump = true
    elseif InputReleased("jump") then
        DebugPrint("[+] Jump Released")
        Player.canJump = false
    end
end

function PlayerUpdate(dt)
    -- DebugPlayer()
    if Player.canJump then
        PlayerJumpGravity(dt, Player.jumpMaxVelocity)
    else
        PlayerJumpGravity(dt, Player.jumpMinVelocity)
    end
end

-- ::::::::::::::::::::::::::::::::::::::
--  PLAYER MODULE FUNCTIONS
-- ::::::::::::::::::::::::::::::::::::::

function PlayerJumpGravity(dt, jumpVelocityMultiplier)
    local playerY = GetPlayerTransform().pos[2]
    -- DebugPrint("Player Pos Y: " .. tostring(playerY))
    local y = dt * jumpVelocityMultiplier
    local pVelocity = GetPlayerVelocity()
    local sumVec = VecAdd(pVelocity,  Vec(0, y, 0))

    if playerY > Player.maxJumpHeight then
        -- DebugPrint("Player height has reached maximum height.")
        SetPlayerVelocity(VecAdd(pVelocity,  Vec(0, 0, 0)))
    else
        SetPlayerVelocity(sumVec)
    end
end

function SpawnPlayer(where)
    if where == 'zero' then
        local t = Transform(Vec(0.0, 0.0, 0.0), QuatEuler(0, 0, 0))
        SetPlayerSpawnTransform(t)

    elseif where == 'safehouse' then
        local t = Transform(Vec(0.0, 0.0, -1.0), QuatEuler(0, 90, 0))
        SetPlayerSpawnTransform(t)
    else
        DebugPrint("Error: 'where' param passed is not allowed.")
    end
end


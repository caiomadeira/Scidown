#include "utils.lua"
#include "registry.lua"
#include "spawn.lua"

-- Meta Class 
Player = {
    State = {
        isInVehicle = false,
    },

    Status = {
        disableAllWeapons = false,
        canRegenerate = false,
    },

    Movement = {
        canJump = false,
        gravityAffects = false,
        jumpMaxVelocity= 10,
        jumpMinVelocity = 0,
        maxJumpHeight = 4,
    },

    SpawnPoints = {
        zero = {0.0, 0.0, 0.0},
        safehouse = { 8.0, 0.0, -14.0},
        testLocation = { 50.0, 25.0, 23.0 }
    }
}

-- Derived class method new
function Player:new(o)
    o = o or {  }
    setmetatable(o, self)
    self.__index = self
    self.canJump = not self.gravityAffects
    return o;
end

-- ************************************
-- **** START LIFE CYCLE FUNCTIONS ****
-- ************************************
-- Derived class method init
function Player:init()
    if self.canRegenerate then
        SetPlayerRegenerationState(true)
    else
        SetPlayerRegenerationState(false)
    end
    SpawnPlayer('safehouse')
end


-- Derived class method tick
function Player:tick(dt)
    -- Gravity Jump
    if self.Movement.gravityAffects then
        if InputPressed("jump") then
            Player.Movement.canJump = true
        elseif InputReleased("jump") then
            Player.Movement.canJump = false
        end
    else
        -- Make gravity floating logic here
    end
    PlayerJumpGravity(dt)

    -- Run Speed
    if InputDown("shift") then
        SetPlayerWalkingSpeed(8.0)
    else
        SetPlayerWalkingSpeed(4.0)
    end
end

-- Derived class method update
function Player:update(dt)
    print("dt", dt)
    if Player.Status.disableAllWeapons then
        DisablePlayerDefaultTools() -- Need to be called in tick or update
    end
end

-- ************************************
-- **** END LIFE CYCLE FUNCTIONS ****
-- ************************************

-- Derived class method jump
function PlayerJumpGravity(dt)
    local playerY = GetPlayerTransform().pos[2]
    local pVelocity = GetPlayerVelocity()

    if playerY > Player.Movement.maxJumpHeight then
        SetPlayerVelocity(VecAdd(pVelocity,  Vec(0, 0, 0)))
    else
        SetPlayerVelocity(VecAdd(pVelocity,  Vec(0, dt * 10, 0)))
    end
end
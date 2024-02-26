#include "utils.lua"
#include "registry.lua"

Player = {
    canJump = false,
    jumpMaxVelocity= 10,
    jumpMinVelocity = 0,
    maxJumpHeight = 4,
    isInVehicle = false,
    SpawnPoints = {
        zero = {0.0, 0.0, 0.0},
        safehouse = { 8.0, 0.0, -14.0},
        testLocation = { 50.0, 25.0, 23.0 }
    }
}

-- ::::::::::::::::::::::::::::::::::::::
--  LIFE CYCLE FUNCTIONS
-- ::::::::::::::::::::::::::::::::::::::

-- Standard configuration for player
function PlayerInit()
    PlayerInventory()
    --SetPlayerSpawnTool("gun")
    SetPlayerRegenerationState(false) -- disable regeneration for player
    -- Spawn Player in some point of World
    SpawnPlayer('safehouse')
end

function PlayerTick()
    if InputPressed("jump") then
        --DebugPrint("[+] Jump Pressed")
        Player.canJump = true
    elseif InputReleased("jump") then
        --DebugPrint("[+] Jump Released")
        Player.canJump = false
    end

     -- Walking speed
    if InputDown("shift") then
		SetPlayerWalkingSpeed(8.0)
	else
		SetPlayerWalkingSpeed(4.0)
    end
    -- DebugPrint(GetPlayerWalkingSpeed())
end

function PlayerUpdate(dt)
    if Player.canJump then
        PlayerJumpGravity(dt, Player.jumpMaxVelocity)
    else
        PlayerJumpGravity(dt, Player.jumpMinVelocity)
    end
end

-- ::::::::::::::::::::::::::::::::::::::
--  PLAYER MODULE FUNCTIONS
-- ::::::::::::::::::::::::::::::::::::::

function PlayerInventory()
    --DisablePlayerDefaultTools()
end


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
    local t
    if where == 'zero' then
        t = Transform(Vec(Player.SpawnPoints.zero[1],
                            Player.SpawnPoints.zero[2],
                            Player.SpawnPoints.zero[3]), 
                            QuatEuler(0, 0, 0))
        SetPlayerSpawnTransform(t)

    elseif where == 'safehouse' then
        t = Transform(Vec(Player.SpawnPoints.safehouse[1],
                            Player.SpawnPoints.safehouse[2],
                            Player.SpawnPoints.safehouse[3]), 
                            QuatEuler(180, 0, 0))
        SetPlayerSpawnTransform(t)

    elseif where == 'testLocation' then
        t = Transform(Vec(Player.SpawnPoints.testLocation[1],
                            Player.SpawnPoints.testLocation[2],
                            Player.SpawnPoints.testLocation[3]), 
                            QuatEuler(0, 0, 0))
        SetPlayerSpawnTransform(t)
    else
        DebugPrint("Error: 'where' param passed is not allowed.")
    end
end

function DebugPlayer()
    DebugPrint(":::::::: PLAYER DEBUG :::::::::")
    local playerTransform = GetPlayerTransform()
    local pVelocity = GetPlayerVelocity()
    DebugPrint("[>] Player Transform: " .. TransformStr(playerTransform))
    DebugPrint("[>] Player Velocity: ".. VecStr(pVelocity))
    DebugPrint(":::::::: END PLAYER DEBUG :::::::::")
  end

  function IsPlayerInVehicle()
     local currentVehicle = GetPlayerVehicle()
     if currentVehicle ~= 0 then -- Vehicle handle may be different of 0 // return 0 if the player is not in vehicle
        Player.isInVehicle = true
     else
        Player.isInVehicle = false
     end
     return currentVehicle
end
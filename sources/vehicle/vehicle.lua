#include "sources/commons/constants.lua"
#include "sources/player.lua"
#include "sources/utils.lua"

--[[ 
Vehicle = {
    spaceship = {
        name = 'spaceship_small1',
        type = 'FLY',
        xmlPath = CONSTANTS.PREFAB.VEHICLES.SPACESHIP_SMALL1,
        voxPath = CONSTANTS.VOX.VEHICLES.SPACESHIP_SMALL1,
        velocity = 50,
        tag='spaceship'
    },
}
]]

-- Meta Class

Vehicle = {
    spaceship = {
        name = 'spaceship_small1',
        type = 'FLY',
        tag='spaceship',
        xmlPath = CONSTANTS.PREFAB.VEHICLES.SPACESHIP_SMALL1,
        voxPath = CONSTANTS.VOX.VEHICLES.SPACESHIP_SMALL1,
        velocity = 50,
    }
}


-- Call this in main tick()
function VehicleTick() 
    -- This functions of Player class controls the variable Player.isInVehicle
    IsPlayerInVehicle() -- this functions should be called in any tick or update of player class not here makes it confusing

    if Player.isInVehicle then
        print("> Player is in vehicle")
        -- FLY INPUT
        if Vehicle.spaceship.type == 'FLY' then
            print("[+] VEHICLE HAS FLY INPUT")
            if string.find(Vehicle.spaceship.name, 'spaceship') then
                print("[+] The vehicle is a spaceship.")
                -- SpaceshipControls()
                SpaceshipControls2()
            end
        end
    else
        print("x Player is NOT in vehicle")
    end
end

function SpaceshipCamera(currentVehiclePos, vehicleBody, vehicleTransform, vehicleVelocity)
    local mouseDx = InputValue("mousedx");
    local mouseDy = InputValue("mousedy");
    local cameraDistance = 7; --magic number for camera distance 
    local fov; -- Not implemented yet
    local playerTransform = GetPlayerTransform()
    local directionCam; -- target3

    -- Vehicle Camera Position Change
    if vehicleBody ~= 0 then
        --cameraDistance = math.clamp(cameraDistance - InputValue("mousewheel"), 1, 20)
        fov = TransformToParentPoint(vehicleTransform, Vec(0, cameraDistance / 2.2, cameraDistance))
        playerTransform.pos = fov;
        playerTransform.rot = vehicleTransform.rot
        SetCameraTransform(playerTransform)
    end

    if not directionCam or (VecLength(vehicleVelocity) > 1) then
        directionCam = currentVehiclePos
    end

    -- Camera mouse x y follows
    if (mouseDx ~= 0 or mouseDy ~= 0 or InputDown('left') or InputDown('right')) then
        local distance = 0.02;
        local dirX = -mouseDy*(distance/5);
        local dirY = -mouseDx*(distance/5);
        local dirZ = DxorDy(InputDown('left'), InputDown('right'), distance*2) -- Use to change camera transform based in key input 
        directionCam = VecAdd(directionCam, TransformToParentVec(vehicleTransform, Vec(dirX, dirY, dirZ)))
        SetBodyAngularVelocity(vehicleBody, VecScale(VecSub(directionCam, currentVehiclePos), 10))
    else
        directionCam = nil
        SetBodyAngularVelocity(vehicleBody, Vec(0, 0, 0))
    end
end

function SpaceshipControls2()
    local direction; -- target2
    local distance = InputDown('shift') and 6 or 2 -- dist
    local vehicleBody = GetVehicleBody(GetPlayerVehicle())
    local vehicleTransform = GetBodyTransform(vehicleBody)
    local vehicleVelocity = GetBodyVelocity(vehicleBody)
    local currentVehiclePos = vehicleTransform.pos

    -- Camera 
    SpaceshipCamera(currentVehiclePos, vehicleBody, vehicleTransform, vehicleVelocity)

    if vehicleBody ~= 0 then
        if not direction or (VecLength(vehicleVelocity) > 1) then
            direction = currentVehiclePos
        end
    
        if InputDown('up') then
            distance = InputDown('ctrl') and distance / 2 or distance
            direction = VecAdd(direction, TransformToParentVec(vehicleTransform, Vec(0, 0, -distance)))
            SetBodyVelocity(vehicleBody, VecScale(VecSub(direction, currentVehiclePos), 10))
        end
    end
end



--[[
function SpaceshipControls()
    local direction = Vec(0, 0, 0)
    local velocity;
    local speed = 8;
    local customSpeed = 1
    local scroll
    --local currentVehicle = GetPlayerVehicle()
    -- You need to get the BODY OF THE CURRENT VEHICLE
    local currentBodyVehicle = FindBody(Vehicle.spaceship.tag, true)
    local vehicleTransform = GetVehicleTransform(FindVehicle(Vehicle.spaceship.tag, true))
    if currentBodyVehicle ~= 0 then
        print("currentBodyVehicle: ", currentBodyVehicle)
        if InputDown("up")  then
            direction[3] = -1
        end

        if InputDown("down") then
            direction[3] = 1
        end

        if InputDown("left") then
            direction[1] = -1
        end

        if InputDown("right") then
            direction[1] = 1
        end
        direction = TransformToParentVec(vehicleTransform, Vec(direction[1], direction[2], direction[3]))

        -- SPACE AND CTRL this two values need to be called after direction - TransformToParentVec(....)
        -- because we reset the direction[2]
        if(InputDown("space")) then
            direction[2] = 1
        end

        if(InputDown("ctrl")) then
            direction[2] = -1
        end

        if(InputDown("shift")) then
            local impulse = Vec(direction[1], 0, 0)
            if (GetBodyVelocity(currentBodyVehicle) == Vec(0, 0, 0)) then
                ApplyBodyImpulse(currentBodyVehicle, 
                GetBodyTransform(currentBodyVehicle), impulse)
            end
        end
        -- Normalize direction
        if(VecLength(direction) > 0) then
            direction = VecNormalize(direction)
        end

        print("Direction Transform: ", dump(direction))
        print("Vehicle Transform: ", dump(vehicleTransform))

        -- Set velocity
        velocity = VecScale(direction, speed)
        velocity[2] = velocity[2] + 0.166666698455811
        SetBodyVelocity(currentBodyVehicle, velocity)
    end
end
]]--
function SpawnVehicle(vehicle)
    local playerPos = GetPlayerTransform().pos
    local spawnT = Transform(Vec(1.0, playerPos[2], 1.0))
    Spawn(vehicle.xmlPath, spawnT)
    
    -- Check if the vehicle was created
    local vehicle = FindVehicle(Vehicle.spaceship.name)
    if vehicle ~= 0 then
        DebugPrint(":::::::::::::::::[" .. Vehicle.spaceship.name .. "] CREATED ::::::::::::::::::::::")
        DebugPrint("VEHICLE INSTANCE NUM >> " .. tostring(vehicle))
        DebugPrint("VEHICLE TRANSFORM >> " .. TransformStr(GetVehicleTransform(vehicle)))
        DebugPrint("PLAYER TRANSFORM >> " .. TransformStr(GetPlayerTransform()))
        DebugPrint("::::::::::::::::::::::::::::::::::::::::::")
    else
        DebugPrint(":::::::::::::::::RRROR: [" .. Vehicle.spaceship.name .. "] NOT CREATED ::::::::::::::::::::::")
    end
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

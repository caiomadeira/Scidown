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
                SpaceshipControls()
            end
        end
    else
        print("x Player is NOT in vehicle")
    end
end

function SpaceshipControls()
    local direction = Vec(0, 0, 0)
    local velocity;
    local speed = 8;
    local customSpeed = 1
    local lastScroll = -1
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

        -- SPACE AND CTRL this two values need to be called after direction - TransformToParentVec(....)
        -- because we reset the direction[2]
        if(InputDown("space")) then
            direction[2] = 1
        end

        if(InputDown("ctrl")) then
            direction[2] = -1
        end

        if(InputDown("shift")) then
            scroll = InputValue("mousewheel")

            if math.abs(scroll) > 0 then
                lastScroll = GetTime()
                customSpeed = math.clamp(customSpeed + scroll, 1, 10)
            end
            
            speed = 15 + customSpeed * customSpeed
        else
            speed = 8
        end
        -- Normalize direction
        if(VecLength(direction) > 0) then
            direction = VecNormalize(direction)
        end

        direction = TransformToParentVec(vehicleTransform, Vec(direction[1], direction[2], direction[3]))
        print("Direction Transform: ", dump(direction))
        print("Vehicle Transform: ", dump(vehicleTransform))

        -- Set velocity
        velocity = VecScale(direction, speed)
        velocity[2] = velocity[2] + 0.166666698455811
        SetBodyVelocity(currentBodyVehicle, velocity)
    end
end

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
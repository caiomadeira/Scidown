Vehicles = {
    vehicleInput = 'NONE',
    SpaceshipSmall1 = {
        name = 'spaceship_small1',
        xmlPath = "MOD/assets/models/ships/spaceship_small1.xml",
        voxPath = "MOD/assets/models/ships/spaceship_small1.vox",
        velocity = 50,
        tag='spaceship'
    },

    suv1 = {
        name = 'suv1',
        xmlPath = "MOD/assets/models/suv/suv1.xml",
        voxPath = "MOD/assets/models/suv/suv1.vox",
        velocity = 50,
        tag='car'
    }
}

-- Vehicle Debug
function DebugVehicle(vehicle)
    DebugPrint("HANDLE VEHICLE INPUT PROPERTY: " .. Vehicles.vehicleInput)
    DebugPrint("Is car broken? " .. tostring(IsBodyBroken(vehicle)))
end

-- Call this in main tick()
function VehicleTick() 
    local multiplier = 50
    local velocityImpulseLimit = 15000

    -- PART OF VEHICLE CONTROLS LOGIC
    IsPlayerInVehicle()

    if Player.isInVehicle then
        -- DebugPrint("> Player is in vehicle")
        local currentVehicle = FindBody("spaceship", true)
        SetVehicleInput(currentVehicle)

        -- SPACESHIP INPUT
        if Vehicles.vehicleInput == 'SPACESHIP_INPUT' then
            SpaceShipInput(multiplier, velocityImpulseLimit, currentVehicle)
        end
    else
        ---DebugPrint("x Player is NOT in vehicle")
    end
end

local cameraXPos = 0
local cameraYPos = 0

function SpaceShipCameraMovement()
    DebugPrint(":::::::::: SPACESHIP MOVEMENT :::::::::::")
    cameraXPos = cameraXPos + InputValue("camerax")
    cameraYPos = cameraYPos + InputValue("cameray")
    --DebugPrint("CameraX Pos: " ..tostring(cameraXPos))
    DebugPrint("CameraY Pos: " ..tostring(cameraYPos))
    DebugPrint(":::::::::::::::::::::::::::::::::::::::::")
end

function SpaceShipInput(multiplier, velocityImpulseLimit, currentVehicle)
    -- SPACESHIP CONTROLS
    local currentVehiclePos = GetBodyTransform(currentVehicle).pos
    local pos = Vec(currentVehiclePos[1], currentVehiclePos[2], currentVehiclePos[3])
    local impulse
    -- DebugPrint("Position body : " .. VecStr(pos))

    -- INCREASE Y/ FLY UP
    if InputDown("space") then
        frame = frame + 1 * multiplier
        -- The impulse apply impulse based in world coordinates 
        -- so, this works with Y 
        impulse = Vec(0, 1 + frame, 0) -- Default 1.0 for y + frame count
        -- DebugPrint("Impulse Applied in Y : " .. VecStr(impulse))

        if impulse[2] < velocityImpulseLimit then -- Speed Control
            ApplyBodyImpulse(currentVehicle, pos, impulse)
        else 
            -- TODO: MAKE THE BODY STATIC IN AIR LIKE SUSPESION SYSTEM
            -- DebugPrint("Limit Reachd to Y")
            frame = 0 
        end

    -- DECREASE Z/ FLY FOWARD
    -- THIS IS DONT WORK THE IMPULSES MAKES THE DIRECTION BASED IN WORLD AND NOT VEHICLE POS
    elseif InputDown('up') then
       -- DebugPrint("GO FOWARD!!!!!!")
        frame = frame + 1 * multiplier
        impulse = Vec(0, 0, 1 - frame) -- decrease z making it move forward
        -- DebugPrint("Impulse Applied in X : " .. VecStr(impulse))
        -- velocityImpulseLimit = math.abs(0.52) * -1 -- Get absolute value of number (ignoring signal) and reverse it
        ApplyBodyImpulse(currentVehicle, pos, impulse)
    else
        -- TODO: RESET THE VELOCITY
        frame = 0
    end
end

function SetVehicleInput(vehicle)
    local hasSpaceshipTag = HasTag(vehicle, "spaceship")
    local hasCarTag = HasTag(vehicle, "car")
    if hasSpaceshipTag then
        Vehicles.vehicleInput = 'SPACESHIP_INPUT'
        -- DebugPrint("+ VEHICLE INPUT SET TO SPACESHIP")
    elseif hasCarTag then
        Vehicles.vehicleInput = 'CAR_INPUT'
       -- DebugPrint("+ VEHICLE INPUT SET TO CAR")
    else
        Vehicles.vehicleInput = 'NONE'
        -- DebugPrint("x VEHICLE INPUT SET TO NONE. PLAYER IS NOT IN VEHICLE")
    end
end


--[[
::::::::::::::::::::::::::::::::::
    SPECIFIC VEHICLES SPAWN
::::::::::::::::::::::::::::::::::
]]--

function SpawnSpaceShip(vehicle)
    -- SpawnObjectAccordingPlayerPos(Vehicles.SpaceshipSmall1.xmlPath, 50, 50, 50, true)
    local playerPos = GetPlayerTransform().pos
    Spawn(vehicle.xmlPath, 
    Transform(Vec(playerPos[1], playerPos[2], playerPos[3])))

    DebugPrint(":::::::::: VEHICLE SPAWNED ::::::::::::::::")
    local vehicle = FindVehicle(vehicle.name)

    DebugPrint("VEHICLE INSTANCE NUM >> " .. tostring(vehicle))
    DebugPrint("VEHICLE TRANSFORM >> " .. TransformStr(GetVehicleTransform(vehicle)))
    DebugPrint("PLAYER TRANSFORM >> " .. TransformStr(GetPlayerTransform()))

    DebugPrint("::::::::::::::::::::::::::::::::::::::::::")
end
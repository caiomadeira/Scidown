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
        DebugPrint("> Player is in vehicle")
        local currentVehicle = FindBody("spaceship", true)
        SetVehicleInput(currentVehicle)

        -- SPACESHIP INPUT
        if Vehicles.vehicleInput == 'SPACESHIP_INPUT' then
            local currentVehiclePos = GetBodyTransform(currentVehicle).pos
            local pos = Vec(currentVehiclePos[1], currentVehiclePos[2], currentVehiclePos[3])
            local impulse = Vec(0, 1 + frame, 0) -- Default 1.0 for y + frame count
    
            DebugPrint("Position body : " .. VecStr(pos))
            DebugPrint("Impulse Applied in Y : " .. VecStr(impulse))
    
            -- SPACESHIP CONTROLS
            if InputDown("space") then
                frame = frame + 1 * multiplier
                if impulse[2] < velocityImpulseLimit then
                    ApplyBodyImpulse(currentVehicle, pos, impulse)
                else 
                    -- TODO: MAKE THE BODY STATIC IN AIR LIKE SUSPESION SYSTEM
                    frame = 0 
                end
            else
                -- TODO: RESET THE VELOCITY
                frame = 0
            end
        end
    else
        DebugPrint("x Player is NOT in vehicle")
    end
end

function SetVehicleInput(vehicle)
    local hasSpaceshipTag = HasTag(vehicle, "spaceship")
    local hasCarTag = HasTag(vehicle, "car")
    if hasSpaceshipTag then
        Vehicles.vehicleInput = 'SPACESHIP_INPUT'
        DebugPrint("+ VEHICLE INPUT SET TO SPACESHIP")
    elseif hasCarTag then
        Vehicles.vehicleInput = 'CAR_INPUT'
        DebugPrint("+ VEHICLE INPUT SET TO CAR")
    else
        Vehicles.vehicleInput = 'NONE'
        DebugPrint("x VEHICLE INPUT SET TO NONE. PLAYER IS NOT IN VEHICLE")
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
Vehicles = {
    SpaceshipSmall1 = {
        name = 'spaceship_small1',
        xmlPath = "MOD/assets/models/ships/spaceship_small1.xml",
        voxPath = "MOD/assets/models/ships/spaceship_small1.vox"
    },

    suv1 = {
        name = 'suv1',
        xmlPath = "MOD/assets/models/suv/suv1.xml",
        voxPath = "MOD/assets/models/suv/suv1.xml"
    }
}

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
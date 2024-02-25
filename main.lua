#include "sources/enviroment.lua"
#include "sources/player.lua"
#include "sources/utils.lua"
#include "sources/world.lua"
#include "sources/prefab.lua"
#include "sources/vehicle.lua"
#include "sources/registry.lua"

frame = 0

function init()
    DebugPrint("init main.lua")
    loadCustomEnvironment(1, false)
    PlayerInit()
    SetupRegistry()
    -- CreateDynamicPlanet()
    -- CreateXMLPrefab(Prefabs.moon2, true)
    -- CreateXMLPrefab(Prefabs.moon3Voxbox, true)
    -- SpawnPrefab(Prefabs.moon2)
    -- SpawnPrefab(Prefabs.moon3Voxbox)
    -- SpawnSafeHouse()


    -- SpawnObjectAccordingPlayerPos(Prefabs.moon2, 50, 50, 50)
    -- SpawnObjectAccordingPlayerPos(Prefabs.moon3Voxbox, 70, 20, 20)
    SpawnSpaceShip(Vehicles.SpaceshipSmall1)
end

function tick()
    PlayerTick()

    if InputDown('space') then
        --frame = frame + 1
        --DebugPrint(frame)
    end
    --[[ 
    if InputDown('shift') then
        frame = frame + 1
        local currentVehicle = FindBody("spaceship_small1", true)
        DebugPrint("currentVehicle HANDLE>>> " .. tostring(currentVehicle))

        local pos = Vec(3 * frame,1,0)
        local imp = Vec(0,0,10)
        ApplyBodyImpulse(currentVehicle, pos, imp)
        DebugPrint("currentVehicle transform> " .. TransformStr(GetBodyTransform(currentVehicle)))
    end
    ]]--

    -- PART OF SPACESHIP CONTROLS LOGIC
    IsPlayerInVehicle(frame)

    if Player.isInVehicle then
        DebugPrint("> Player is in vehicle")

        local multiplier = 50
        local currentVehicle = FindShape("spaceship_small1", true)
        local currentPos = GetShapeLocalTransform(currentVehicle).pos

        --Shape transform in body local space
        local vehicleShapeTransform = GetShapeLocalTransform(currentVehicle)
        -- Body transaform in world space
        local vehicleBodyTransform = GetBodyTransform(GetShapeBody(currentVehicle))
        --Shape transform in world space
	    local vehicleShapeWorldTranform = TransformToParentTransform(vehicleBodyTransform, vehicleShapeTransform)


        local pos = Vec(currentPos[1] + frame, currentPos[2], currentPos[3])
        --local pos = Vec(currentPos[1] + frame, currentPos[2] + frame, currentPos[3])
        --local impulse = Vec(1, 1, 1)
        -- local pos = Vec(0.0, 0.0, 0)
        DebugPrint("Position body : " .. VecStr(pos))
        -- SPACESHIP CONTROLS
        if InputDown("space") then
            frame = frame + 1
            local transform = Transform(Vec(0, frame, 0), QuatEuler(0, 90, 0))
            --local pos = GetBodyTransform(currentVehicle)
            -- local pos = Vec(0, frame, 0)
            --local impulse = Vec(1, 1, 1)
            -- DebugPrint("Position body : " .. VecStr(pos))
            --DebugPrint("Impulse Applied: " .. VecStr(impulse))
            --SetBodyTransform(currentVehicle, pos)

            SetShapeLocalTransform(currentVehicle, transform)

            --if impulse[1] < 15000 then
                --DebugPrint("minor than 1000")
                --ApplyBodyImpulse(currentVehicle, pos, impulse)
                -- SetBodyTransform(currentVehicle, pos)
            --else 
                --frame = 0
            --end
        else
            frame = 0
            DebugPrint("frame is decresing: " .. tostring(frame))
        end
    else
        DebugPrint("x Player is NOT in vehicle")
    end

end

function update(dt)
    -- DebugPlayer()
    PlayerUpdate(dt)

--[[ 
    if Player.isInVehicle then
        DebugPrint("> Player is in vehicle")
        -- SPACESHIP CONTROLS
        if InputDown("up") then
            local vehicle = GetPlayerVehicle()
            --DebugPrint("> GetPlayerVehicle handle: " .. tostring(vehicle))
            --DebugPrint("> GetPlayerVehicle handle: " .. tostring(vehicle))
            --DebugPrint("> FindBody(spaceship_small1): " .. tostring(FindBody(Vehicles.SpaceshipSmall1.name, true)))
            shape = FindBody("spaceship_small1")
            DebugPrint(">> shape: " .. tostring(shape))
            local transform = Transform(Vec(20, 29, 20), QuatEuler(0, 90, 0))
            SetShapeLocalTransform(shape, transform)
            DebugPrint("FORWARD PRESSED")
        end
    else
        DebugPrint("x Player is NOT in vehicle")
    end
     ]]--
end
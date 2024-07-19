#include "sources/commons/constants.lua"
#include "sources/player.lua"
#include "sources/utils.lua"


chopperShootSound = LoadSound("chopper-shoot0.ogg")
chopperRocketSound = LoadSound("tools/launcher0.ogg")
machineGunMode = true

shootTimer = 0
weaponsEnabled = true


Vehicle = {
    spaceship = {
        name = 'spaceship_small1',
        type = 'FLY',
        tag='spaceship',
        xmlPath = CONSTANTS.PREFAB.VEHICLES.SPACESHIP_SMALL1,
        voxPath = CONSTANTS.VOX.VEHICLES.SPACESHIP_SMALL1,
        velocity = 50,
    },

    Status = {
        isDead = false,
    }
}

function SetCurrentVehicleParams()
    local vehicle = GetPlayerVehicle()
    if vehicle ~= nil then
        if HasTag(vehicle, "spaceship") then
            SetVehicleParam(vehicle, "strength", 200)
            SetVehicleParam(vehicle, "spring", 200)
            SetVehicleParam(vehicle, "damping", 200)
        end
    end
end

function DamageSystem() 
    SetCurrentVehicleParams()
    local vehicle = GetPlayerVehicle()

    if HasTag(vehicle, "customhealth") then
        if vehicle ~= nil then
            local health = GetVehicleHealth(vehicle)
            if health ~= nil then
                print("CONDITION>>>>>>", health)
                local broken = IsBodyBroken(vehicle)
                if health < 1 or broken == true then
                    SetVehicleHealth(vehicle, 1.0)
                end
            end
        end
    else
        print("no custom health found")
    end
end

-- "customhealth"
function CheckTag(tag)
    local vehicle = GetPlayerVehicle()
    if not HasTag(vehicle, tag) then
        SetTag(vehicle, tag)
    else
        print("Already had this tag.")
    end
end

-- Call this in main tick()
function VehicleTick() 
    CheckTag("customhealth")
    DamageSystem()
    if Player.State.isInVehicle then
        if Vehicle.spaceship.type == 'FLY' then
            SetupAircraftVehicle()
        end
    end
end

function SetupAircraftVehicle()
    if string.find(Vehicle.spaceship.name, 'spaceship') then
        if InputPressed("i") then machineGunMode = not machineGunMode end
        VehicleCondition(Vehicle.spaceship.tag)
        AircraftControl()
    end
end

-- Vehicle Condition
function VehicleCondition(vehicleTag)
    local health = GetVehicleHealth(FindVehicle(vehicleTag))
    -- print("Vehicle Health: ", health)
    if health == 0 then
        Vehicle.Status.isDead = true
    end
end

-- Spaceship weaponsEnabled
function VehicleWeapon()
    local vehicleBody = GetVehicleBody(GetPlayerVehicle())
    local vehicleTransform = GetBodyTransform(vehicleBody)
    local aimPosition;
    local spread;

    if not Vehicle.Status.isDead then
        if weaponsEnabled and InputDown("lmb") and shootTimer == 0 then
            if machineGunMode then
                PlaySound(chopperShootSound, vehicleTransform.pos, 5, false)
                aimPosition = TransformToParentPoint(vehicleTransform, Vec(0, 0, -1))
                spread = 0.07
            else
                PlaySound(chopperRocketSound, vehicleTransform.pos, 5, false)
                aimPosition = TransformToParentPoint(vehicleTransform, Vec(0, 0, -1))
                spread = 0.01
            end
            local pos = vehicleTransform.pos
            local dir = VecNormalize(VecSub(aimPosition, pos))
            dir[1] = dir[1] + (math.random()-0.5)*2*spread
            dir[2] = dir[2] + (math.random()-0.5)*2*spread
            dir[3] = dir[3] + (math.random()-0.5)*2*spread
            dir = VecNormalize(dir)
            pos = VecAdd(pos, VecScale(dir, 5))
            if machineGunMode then
                Shoot(pos, dir, "bullet")
                shootTimer = 0.1
            else
                Shoot(pos, dir, "rocket", 1)
                shootTimer = 0.33
            end
        end

        if shootTimer > 0 then
            shootTimer = shootTimer - GetTimeStep()
        else
            shootTimer = 0
        end
    end
end

function AircraftCamera(currentVehiclePos, vehicleBody, vehicleTransform, vehicleVelocity)
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

function AircraftControl()
    local direction; -- target2
    local distance = InputDown('shift') and 6 or 2 -- dist
    local vehicleBody = GetVehicleBody(GetPlayerVehicle())
    local vehicleVelocity = GetBodyVelocity(vehicleBody)
    local vehicleTransform = GetBodyTransform(vehicleBody)
    local currentVehiclePos = vehicleTransform.pos

    if not Vehicle.Status.isDead then
        -- Camera 
        AircraftCamera(currentVehiclePos, vehicleBody, vehicleTransform, vehicleVelocity)
        -- Weapon 
        VehicleWeapon()

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
end
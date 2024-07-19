#include "sources/environment.lua"
#include "sources/player.lua"
#include "sources/utils.lua"
#include "sources/world.lua"
#include "sources/prefab.lua"
#include "sources/vehicle/vehicle.lua"
#include "sources/registry.lua"
#include "sources/particles.lua"
#include "sources/debug.lua"
#include "sources/spawn.lua"
#include "settings.lua"

local dp;
local player;

isInPlanet = false


if MOD.DEBUG then
    dp = Debug:new(nil)
else
    print("Debug is disabled. local dp is nil.")
end

function init()
    print("::::::::::::::::::::::::::::::::::::::::")
    print("::::::::::::::::::::::::::::::::::::::::")
    print("::::::::::   INIT SCIDOWN MOD    :::::::")
    print("::::::::::::::::::::::::::::::::::::::::")
    print("::::::::::::::::::::::::::::::::::::::::")
    --SetLevelName('mainspace')
    print("LEVEL NAME: ", GetString("level.name"))
    player = Player:new(nil)
    player:init()
    if GetString("level.name") == 'planet1' then
        print("lvl name is planet1")
        isInPlanet = true
    else
        print("lvl name is NOT planet1")
        SpawnStructure('safehouse')
        SpawnPlayer('safehouse')
        SpawnVehicle(Vehicle.spaceship, Transform(Vec(11.0, 8.3, 5.7), Vec(0.0, 0.0, 0.0)))
        PopulateWorldWith(CelestialBodies) 
    end
end

-- ************************************
-- **** START LIFE CYCLE FUNCTIONS ****
-- ************************************
function tick(dt)
    if dp ~= nil then
        dp:worldDebug()
   end
    player:tick(dt)
    VehicleTick()
end

function update(dt)

    if GetString("level.name") ~= 'planet1' then
        CheckPlanetProximity()
    end

   if dp ~= nil then
        dp:flyMode()
   end
   player:update(dt)

end

function draw(dt)
    if dp ~= nil then
        dp:UIDebug()
    end
end
-- ************************************
-- **** END LIFE CYCLE FUNCTIONS ****
-- ************************************

function GetPlayerDistFromCelestialBody()
    local dist = { };
    for i=1, #CONSTANTS.TAGS do
        local celestialBodyShape = CreateBodyForShape("planet")
        local celestialShapeLocalTrans = GetShapeLocalTransform(celestialBodyShape).pos
        --print("celestialShapeLocalTrans:", dump(celestialShapeLocalTrans))
        DebugLine(GetPlayerTransform().pos, celestialShapeLocalTrans, 1, 1, 1)
        table.insert(dist, VecSub(GetPlayerTransform().pos, celestialShapeLocalTrans))
        -- print("[+] dist " .. CONSTANTS.TAGS[i] .. "[" .. i.. "]: " .. VecStr(dist))
    end
    -- print("distance: ", dump(dist))
    return dist;
end

-- ************************************
-- **** LOAD LEVEL ****
-- ************************************

function CheckPlanetProximity()
    local dist = GetPlayerDistFromCelestialBody()
    for i=1, #dist do
         local planetVec = dist[i]
         if planetVec[1] < 10 and planetVec[1] > 0 and isInPlanet == false then
             print("close: ", planetVec[1])
             StartLevel(Level.planet.name, Level.planet.prefab)
         end
    end
end
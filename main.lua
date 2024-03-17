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
    SpawnStructure('safehouse')
    SpawnPlayer('safehouse')
    player = Player:new(nil)
    player:init()
    SpawnVehicle(Vehicle.spaceship)
    PopulateWorldWith(CelestialBodies)
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
   if dp ~= nil then
        dp:flyMode()
   end
   player:update(dt)
   local dist = GetPlayerDistFromCelestialBody()
   for i=1, #dist do
        for k, v in pairs(dist[i]) do
            if k == 1 and v > 0 and v < 9 then
                print("value? ", v)
                print(k, "CLOSE ", v)
                DebugPrint("CLOSE")
                
            else
                print(k, "FAR ", v)
                DebugPrint("FAR")

            end
        end
   end
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
        local celestialBodyShape = CreateBodyForShape(CONSTANTS.TAGS[i])
        local celestialShapeLocalTrans = GetShapeLocalTransform(celestialBodyShape).pos
        --print("celestialShapeLocalTrans:", dump(celestialShapeLocalTrans))
        DebugLine(GetPlayerTransform().pos, celestialShapeLocalTrans, 1, 1, 1)
        table.insert(dist, VecSub(GetPlayerTransform().pos, celestialShapeLocalTrans))
        -- print("[+] dist " .. CONSTANTS.TAGS[i] .. "[" .. i.. "]: " .. VecStr(dist))
    end
    -- print("distance: ", dump(dist))
    return dist;
end
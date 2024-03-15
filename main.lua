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
    player = Player:new(nil)
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

end

function draw(dt)
    if dp ~= nil then
        dp:UIDebug()
    end
end
-- ************************************
-- **** END LIFE CYCLE FUNCTIONS ****
-- ************************************
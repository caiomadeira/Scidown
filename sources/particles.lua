#include "sources/prefab.lua"
#include "sources/commons/colors.lua"


function rnd(mi, ma) 
    return math.random(0, 1000) / 1000*(ma-mi)+mi
end

function AddParticleEffect() 
    local pos = Vec(0, 1, 0)
    local velocity = Vec(1, 5, -1)
    local duration = 1.0 -- particle lifetime in seconds
    ParticleReset()
    ParticleCollide(1)
    --ParticleGravity(-50)  
    ParticleTile(0) -- 5 fire  // 0 smoke

	ParticleEmissive(10)
    --ParticleCollide(0, 1)
	ParticleAlpha(0.2, 0.2)
	ParticleRotation(4)

    ParticleRadius(4) -- control size radius for spherical particles
	ParticleColor(1,1,0, 1,0,0)

    -- SpawnParticle(pos, velocity, duration)

    for i=1, 100 do
    	SpawnParticle(pos, Vec(rnd(-1, 1)), duration)
    end
end
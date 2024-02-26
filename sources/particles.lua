#include "sources/prefab.lua"
#include "sources/commons/colors.lua"


function AddParticleEffect() 
    local pos = Vec(0, 5, 0)
    local velocity = Vec(4, 4, 4)
    local duration = 10.0 -- particle lifetime in seconds
    ParticleType('fire')
	ParticleColor(1,1,0, 1,0,0)
    ParticleReset() -- Reset particles to default state
	-- ParticleEmissive(5, 2)

	ParticleRadius(0.4)

	SpawnParticle(pos, velocity, duration)
end
frame = 0

function init() -- CALLED WHEN THE SCRIPT INITIALIZES
    local Player = {
        pos = GetPlayerPos()
    }
    DebugPrint("init main.lua")
end

function tick()
    -- DebugPrint("Player Velocity: "..GetPlayerVelocity())
    frame = frame + 1
    defaultSpaceGravity(frame)
end

function defaultSpaceGravity(frame)
    SetPlayerVelocity(VecAdd(GetPlayerVelocity(), Vec(0, 50*frame, 0)))
end



--[[ Gravity function - back another time to this
function update(dt)
    bodies = FindBodies(nil,true)
    SetPlayerVelocity(VecAdd(GetPlayerVelocity(),Vec(0,dt*10,0)))
    for i in pairs(bodies) do
        local btrans = GetBodyTransform(bodies[i])
        if IsBodyActive(bodies[i]) then
            ApplyBodyImpulse(bodies[i],TransformToParentPoint(btrans,GetBodyCenterOfMass(bodies[i])),Vec(0,GetBodyMass(bodies[i])*dt*10,0))
        end
    end
end ]]--

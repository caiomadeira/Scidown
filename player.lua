function playerJumpGravity(dt, max_height)
    SetPlayerVelocity(VecAdd(GetPlayerVelocity(), Vec(0,dt * max_height, 0)))
end

function debugPlayerTransform()
    local playerTransformPos = GetPlayerTransform().pos
    DebugPrint("player transform: " .. TransformStr(playerTransform))

    for k, v in pairs(playerTransformPos) do
        DebugPrint("pos: " .. tostring(k) .. tostring(v))
    end
end


function spawnPlayer(where)
    if where == 'zero' then
        local t = Transform(Vec(0, 0, 0), QuatEuler(0, 0, 0))
        SetPlayerSpawnTransform(t)
    elseif where == nil then
        DebugPrint("Error ")
    end
end
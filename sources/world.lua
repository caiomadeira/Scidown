#include "sources/prefab.lua"
#include "sources/utils.lua"

World = {
    size = {
        width = 250,
        height = 10,
        depth = 250
    }
}

-- Spawn object according to the player's position

function SpawnObjectAccordingPlayerPos(object, xOffset, yOffset, zOffset, isXmlFile)
    DebugPrint(":::::::: SpawnObjectAccordingPlayerPos :::::::::")
    local pPos = GetPlayerTransform().pos
    local newPosX, newPosY, newPosZ

    -- POS X
    if pPos[1] >= 2 then
        newPosX = pPos[1] * xOffset
    else -- minor than zero
        newPosX = pPos[1] + xOffset
    end

    -- POS Y
    if pPos[2] >= 2 then
        newPosY = pPos[2] * yOffset
    else -- minor than zero
        newPosY = pPos[2] + yOffset
    end

    -- POS Z
    if pPos[3] >= 2 then
        newPosZ = pPos[3] * zOffset
    else -- minor than zero
        newPosZ = pPos[3] + zOffset
    end
    
    if isXmlFile then
        Spawn(object, Transform(Vec(newPosX, newPosY , newPosZ)), true, true)
    else
        object.pos = tostring(newPosX) .. " " .. tostring(newPosY) .. " " .. tostring(newPosZ) .. " " 
        DebugPrint(">> SPAWNED PREFAB " .. object.name .. " POS: " ..  object.pos)
        SpawnPrefab(object)
    end

    DebugPrint("::::::::::::::::::::::::::")
end
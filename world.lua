Prefabs = {

    -- ANOTHER WAY TO DECLARE PREFABS (NOT CURRENTLY SUPPORTED)
    moon1 = [=[
        <vox name="moon1" 
        tags="moon1" 
        pos="-9.4 0.0 -9.4" 
        file="MOD/assets/models/moon.vox" 
        scale="2" 
        color="0.84 0.23 0.23"/>
    ]=],

    moon2 = {
        type = 'vox',
        name = 'moon2',
        tags = 'moon2',
        pos = '-9.4 0.0 -9.4',
        file = 'MOD/assets/models/moon.vox',
        scale = '4',
        color = '0.84 0.23 0.23'
    }
}

-- TODO: Refactor this trash
function CreateXMLPrefab(properties, debug)
    local xmlTable = {  }
    count = 0;
    for key, value in pairs(properties) do
        count = count + 1
        if (tostring(key) == 'type') then
            xmlTable[1] = '<' .. value .. ''
        elseif (tostring(key) == 'name') then
            xmlTable[2] = " " .. key .. '=' .. '"' .. value .. '" '
        else
            xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '" '
        end 
        -- CHECK IF THE NEXT KEY IS EQUAL NIL (THE LAST IN ARRAY)
        if next(properties, key) == nil then
            xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '"/>'
        end
    end

    if debug then
        DebugPrint("::::::: XML STRUCTURE :::::::\n")
        DebugPrint(dump(xmlTable))
        DebugPrint("XML created.")
        DebugPrint(":::::::::::::::::::::\n")
    end
    
    return xmlTable
end

function SpawnPrefab(properties)
    local debug = true
    local xmlProperties = CreateXMLPrefab(properties)
    local xmlCombined = table.concat(xmlProperties, "")

	Spawn(xmlCombined, Transform(Vec(-9.4, 0.0 , -9.4)), true, true)

    if debug then
        DebugPrint("XML full string: " .. xmlCombined)
        DebugPrint("Prefab [" .. string.upper(properties.name)  .. "] spawned.")
    end
end
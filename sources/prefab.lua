Prefabs = {

    -- ANOTHER WAY TO DECLARE PREFABS (NOT CURRENTLY SUPPORTED. I JUST USED THIS FOR TEST)
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
    },
    
    -- 	<voxbox name="testvoxbox" tags="testvoxbox" pos="-6.5 2.9 0.0" rot="0 0 0" desc="desc" texture="20" blendtexture="10" density="10" strength="100" collide="true" prop="false" size="40 39 40" brush="MOD/assets/models/moon.vox" material="rock" color="0.92 0.91 0.61"/>
    moon3Voxbox = {
        type = 'voxbox',
        name = 'moon3_voxbox',
        tags = 'moon3_voxbox',
        pos = '0.0 0.0 0.9',
        rot = "0 0 0",
        desc ="desc",
        texture = "20",
        blendtexture = "10",
        density = "10",
        strength = "100",
        collide = "true",
        prop = "false",
        size = "40 39 40",
        brush ="MOD/assets/models/moon.vox",
        material = "rock",
        color = '0.92 0.91 0.61'
    }
}

-- TODO: Refactor this trash
function CreateXMLPrefab(properties, debug)
    local xmlTable = {  }
    count = 0;

    -- FOR VOX 
    for key, value in pairs(properties) do
        if (tostring(key) == 'type' and tostring(value) == 'vox') then
            count = count + 1
            if (tostring(key) == 'type') then
                xmlTable[1] = '<' .. value .. ''
            elseif (tostring(key) == 'name') then
                xmlTable[2] = " " .. key .. '=' .. '"' .. value .. '" '
            else
                -- CHECK IF THE NEXT KEY IS EQUAL NIL (THE LAST IN ARRAY)
                if next(properties, key) == nil then
                    xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '"/>'
                else
                    xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '" '
                end
            end 
        end
    end

    -- FOR VOXBOX 
    for key, value in pairs(properties) do
        if (tostring(key) == 'type' and tostring(value) == 'voxbox') then
            xmlTable[1] = '<' .. value .. ''
        elseif (tostring(key) == 'name') then
            xmlTable[2] = " " .. key .. '=' .. '"' .. value .. '" '
        else
            count = count + 1
            if next(properties, key) == nil then
                xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '"/>'
            else
                xmlTable[count] = " " .. key .. '=' .. '"' .. value .. '" '            
            end
        end
    end

    if debug then
        DebugPrint("::::::: XML STRUCTURE for " .. tostring(properties['name']) .. ":::::::\n")
        DebugPrint(dump(xmlTable))
        DebugPrint("XML created.")
        DebugPrint(":::::::::::::::::::::\n")
    end

    --for k, v in pairs(xmlTable) do
        --DebugPrint(tostring(k) .. ": " ..  tostring(v))
    --end    
    return xmlTable -- Return the table
end

function SpawnPrefab(properties, debug)
    local xmlProperties = CreateXMLPrefab(properties)
    local xmlCombined = table.concat(xmlProperties, "") -- Convert into a string

    -- Get Spawn Coordinates from prefab table
    local prefabCoord = {  }
    for k, v in pairs(properties) do
        if k == 'pos' then
            for num in v:gmatch("%S+") do -- Use gmatch "%S+" regex pattern to separate float numbers
                table.insert(prefabCoord, num)
            end
        end
    end
    Spawn(xmlCombined, Transform(Vec(prefabCoord[1], prefabCoord[2] , prefabCoord[3])), true, true)
	 --Spawn(xmlCombined, Transform(Vec(-9.4, 0.0 , -9.4)))
    if debug then
        DebugPrint("::::::: PREFAB COORD :::::::\n")
        DebugPrint(dump(prefabCoord))
        DebugPrint(":::::::::::::::::::::\n")
        DebugPrint("::::::: FEEDBACK :::::::\n")
        DebugPrint("XML full string: " .. xmlCombined)
        DebugPrint("Prefab [" .. string.upper(properties.name)  .. "] spawned.")
    end
end
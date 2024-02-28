--[[

The registry is a database of hierarchical global variables that is used both internally in the engine, for 
communication between scripts and as a way to save persistent data.

]]--


-- This function needs to be called in update() or tick()
function DisablePlayerDefaultTools()
	-- This function needs to be called in  update()
    --DebugPrint(":::::::: PLAYER TOOLS :::::::::")
	local list = ListKeys("game.tool")
	for i=1, #list do
		--DebugPrint(">> keys: " ..tostring(list[i]))
		SetBool("game.tool."..list[i]..".enabled", false)
	end
	SetString("game.player.tool", "gun") -- Set initial tool to gun
    --DebugPrint("::::::::::::::::::::::::::::::::::")
end

-- TODO: THIS FUNCTION MAY BE USEFUL IN FUTURE BECAUSE I GET THE CURRENT PLAYER TOOL
-- I NEED TO CALL THIS IN TICK() OR UPDATE() TO GET THE REAL TIME TOOL
function PrintRegistryKeys(registryNode)
    --DebugPrint(":::::::: LISTING KEYS FOR " .. registryNode .. " NODE :::::::::")
	local list = ListKeys(registryNode)
	for i=1, #list do 
		--DebugPrint(">> keys: " ..tostring(list[i]))
		if registryNode == "game.player.tool" then
			DebugPrint("Tool>: " .. GetString(registryNode))
		end
	end
    --DebugPrint("::::::::::::::::::::::::::::::::::")
end
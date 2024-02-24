--[[

The registry is a database of hierarchical global variables that is used both internally in the engine, for 
communication between scripts and as a way to save persistent data.

]]--

function SetupRegistry()
    DisablePlayerDefaultTools()

end

function DisablePlayerDefaultTools()
	local list = ListKeys("game.input")
	for i=1, #list do
		DebugPrint("Registry keys for game: " .. tostring(list[i]))
	end
end
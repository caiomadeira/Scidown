frame = 0

function init() -- CALLED WHEN THE SCRIPT INITIALIZES
    DebugPrint("init main.lua")
end

function tickFrame()
    frame = frame + 1
    DebugPrint("Frame: ".. frame)
end
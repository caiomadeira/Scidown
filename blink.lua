
function init() -- CALLED WHEN THE SCRIPT INITIALIZES
    testlight = FindLight('testlight')
    DebugPrint("handle light blink: ".. testlight)
end

function tick() -- IS LIKE A LOOP. ITS CALLED EVERY FRAME
    key = InputDown("L")
    SetLightEnabled(testlight, key)
end
ENABLE_UI_TESTS = true

function testUIInit()
    if ENABLE_UI_TESTS then
        DebugPrint("[+] Init UI Test Module")
        -- Test UI init functions goes here()
    end
end

function tick()
    if ENABLE_UI_TESTS then
        -- Test UI tick functions goes here()
    end
end

function update(dt)
    if ENABLE_UI_TESTS then
        -- Test UI update functions goes here()
    end
end
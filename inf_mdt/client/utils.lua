function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

function debugPrint(...)
    if not Config.debug then return end
    local args <const> = { ... }

    local appendStr = ''
    for _, v in ipairs(args) do
        appendStr = appendStr .. ' ' .. tostring(v)
    end
    local msgTemplate = '^3[%s]^0%s'
    local finalMsg = msgTemplate:format(GetCurrentResourceName(), appendStr)
    print(finalMsg)
end
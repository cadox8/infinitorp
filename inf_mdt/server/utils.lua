function generateIdentifier()
    local result = ''
    for i = 1, 4, 1 do
        result = result .. string.char(math.random(48, 57))
    end
    return result .. string.char(math.random(65, 90))
end
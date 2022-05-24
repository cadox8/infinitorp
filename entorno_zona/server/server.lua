ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent("zona:createZone")
AddEventHandler("zona:createZone", function(distance, type, msg, coords)
    local from = source
    local username = GetPlayerName(source)
    MySQL.Async.insert('insert into zona (username, distance, type, x, y, z, msg) values (@username, @distance, @type, @x, @y, @z, @msg)',
            { ['username'] = username, ['distance'] = distance, ['type'] = type, ['x'] = coords.x, ['y'] = coords.y, ['z'] = coords.z, ['msg'] = msg },
            function(insertId)
                TriggerClientEvent('zona:addData', -1, insertId, distance, msg, coords)
                TriggerClientEvent('chat:addMessage', from, {
                    color = { 5, 255, 255 },
                    multiline = true,
                    args = { 'Entorno de Zona creado con la id [' .. insertId .. '] para un rango de ' .. distance .. ' metros.' }
                })
            end
    )
end)

RegisterNetEvent('zona:deteleZone')
AddEventHandler('zona:deteleZone', function(id)
    local s = source -- Ok?
    local realId = tonumber(id)

    if realId then
        MySQL.Async.execute('delete from zona where id = @id', {
            ['@id'] = realId
        }, function(result)
            TriggerClientEvent('chat:addMessage', s, {
                color = { 255, 66, 66 },
                multiline = true,
                args = { 'Entorno Zona', ' Borrado el entorno con la ID ' .. id }
            })
            MySQL.Async.fetchAll('select * from zona', {}, function(data)
                if data ~= nil then
                    TriggerClientEvent('zona:sendData', -1, s, data)
                else
                    TriggerClientEvent('zona:sendData', -1, s, {  })
                end
            end)
        end)
    else
        TriggerClientEvent('chat:addMessage', s, {
            color = { 255, 66, 66 },
            multiline = true,
            args = { 'Entorno Zona', ' No existe la id ' .. id .. '. Comprueba que es un número' }
        })
    end
end)

RegisterNetEvent('zona:loadData')
AddEventHandler('zona:loadData', function()
    local s = source -- Ok?
    MySQL.Async.fetchAll('select * from zona', {}, function(result)
        if result ~= nil then
            TriggerClientEvent('zona:sendData', s, result)
        else
            TriggerClientEvent('zona:sendData', s, { })
        end
    end)
end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Comandos
RegisterCommand("zona", function(source, args, rawCommand)
    if args[1] == nil or args[2] == nil then
        TriggerEvent('chat:addMessage', {
            color = { 255, 66, 66 },
            multiline = true,
            args = { 'Entorno Zonas > ', ' Uso: /zona [distancia] [mensaje]' }
        })
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerEvent('inf_zona:createZone', source, xPlayer.getIdentifier(), args[1], concat(args), xPlayer.getCoords(true))
    end
end, false)

RegisterCommand("borrarzona", function(source, args, rawCommand)
    TriggerEvent('inf_zona:deleteZone', source, args[1])
end, true)

RegisterCommand("reloadzona", function(source, args, rawCommand)
    TriggerEvent('inf_zona:loadData', source)
end, false)

RegisterCommand("recargarzonas", function(source, args, rawCommand)
    TriggerEvent('inf_zona:loadData', -1)
end, true)
--


-- Eventos
RegisterNetEvent("inf_zona:createZone")
AddEventHandler("inf_zona:createZone", function(source, identifier, distance, msg, coords)
    MySQL.Async.insert('insert into zona (username, distance, x, y, z, msg) values (@username, @distance, @x, @y, @z, @msg)',
            { ['username'] = identifier, ['distance'] = distance, ['x'] = coords.x, ['y'] = coords.y, ['z'] = coords.z, ['msg'] = msg },
            function(insertId)
                TriggerClientEvent('inf_zona:loadData', -1)
                TriggerClientEvent('chat:addMessage', source, {
                    color = { 5, 255, 255 },
                    multiline = true,
                    args = { 'Entorno de Zona creado con la id [' .. insertId .. '] para un rango de ' .. distance .. ' metros.' }
                })
            end
    )
end)

RegisterNetEvent('inf_zona:deleteZone')
AddEventHandler('inf_zona:deleteZone', function(source, id)
    local realId = tonumber(id)

    if realId then
        MySQL.Async.execute('delete from zona where id = @id', {
            ['@id'] = realId
        }, function(result)
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 66, 66 },
                multiline = true,
                args = { 'Entorno Zona', ' Borrado el entorno con la ID ' .. id }
            })
            TriggerClientEvent('inf_zona:loadData', -1)
        end)
    else
        TriggerClientEvent('chat:addMessage', s, {
            color = { 255, 66, 66 },
            multiline = true,
            args = { 'Entorno Zona', ' No existe la id ' .. id .. '. Comprueba que es un número' }
        })
    end
end)

RegisterNetEvent('inf_zona:loadData')
AddEventHandler('inf_zona:loadData', function(source)
    MySQL.Async.fetchAll('select * from zona', {}, function(result)
        if result ~= nil then
            TriggerClientEvent('inf_zona:sendData', source, result)
        else
            TriggerClientEvent('inf_zona:sendData', source, { })
        end
    end)
end)

-- Utils
function concat(args)
    local i = 2
    local s = ''
    while args[i] do
        s = s .. ' ' .. args[i]
        i = i + 1
    end
    return s
end
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Data
RegisterCommand('mdt', function(source, args)
    TriggerClientEvent('mdt:open', source)
end)
--

-- Functions

--



-- Callbacks
ESX.RegisterServerCallback('mdt:loadPlayers', function(source, cb)
    MySQL.Async.fetchAll('select identifier, firstname, lastname, job')
end)

-- Events
RegisterServerEvent('mdt:checkIdentifier')
AddEventHandler('mdt:checkIdentifier', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("select identifier from users where idenfitier = @idd and (identificador is null or identificador = '')", {
        ['@idd'] = xPlayer.getIdentifier()
    }, function(result)
        for i = 1, #result, 1 do
            MySQL.Async.execute('update users set identificador = @ident where identifier = @id', {
                ['@ident'] = generateIdentifier(),
                ['@id'] = result[i].identifier
            }, function(ok)  end)
        end
    end)
end)
--
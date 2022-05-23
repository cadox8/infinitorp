ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('entornos:gunshotInProgress')
AddEventHandler('entornos:gunshotInProgress', function(street, source, playerGender1)
    local playerGender = 'Un Hombre'
    if playerGender1 == 5 then playerGender = 'Una Mujer' end

    sendNoti(source, Config.codes['disparos'].cod, Config.codes['disparos'].title, Config.codes['disparos'].blip, 'Hay un tiroteo en progreso! '.. playerGender ..' está disparando un arma', street)
end)

RegisterServerEvent('entornos:forzar')
AddEventHandler('entornos:forzar', function(source, veh)
    local primary = Config.colors[tostring(veh.primary)]
    local data = 'Vehiculo: ' .. veh.model .. '<br> Matrícula: ' .. veh.plate .. '<br> Color: ' .. primary

    sendNoti(source, Config.codes['forzar'].cod, Config.codes['forzar'].title, Config.codes['forzar'].blip, data, veh.street)
end)

RegisterServerEvent('entornos:vel')
AddEventHandler('entornos:vel', function(source, veh, velocity)
    local primary = Config.colors[tostring(veh.primary)]
    local data = 'Vehiculo: ' .. veh.model .. '<br> Color: ' .. primary .. '<br> A: ' .. velocity .. 'km/h'

    sendNoti(source, Config.codes['speed'].cod, Config.codes['speed'].title, Config.codes['speed'].blip, data, veh.street)
end)

RegisterServerEvent('entornos:entorno')
AddEventHandler('entornos:entorno', function(source, street, msg)
  sendChatMsgPolice(source, msg, street)
end)

RegisterServerEvent('entornos:socorro')
AddEventHandler('entornos:socorro', function(source, street, msg)
  sendChatMsgEms(source, msg, street)
end)

-- Exports
exports('vel', function(source, model, street, primary, velocity)
    primary = Config.colors[tostring(primary)]
    local data = 'Vehiculo: ' .. model .. '<br> Color: ' .. primary .. '<br> A: ' .. velocity .. 'km/h'

    sendNoti(source, Config.codes['speed'].cod, Config.codes['speed'].title, Config.codes['speed'].blip, data, street)
end)

exports('drug', function(source, msg, loc)
    sendNoti(source, Config.codes['drogas'].cod, Config.codes['drogas'].title, Config.codes['drogas'].blip, msg, loc)
end)

exports('store', function(source, msg, loc)
    sendNoti(source, Config.codes['atraco'].cod, Config.codes['atraco'].title, Config.codes['atraco'].blip, msg, loc)
end)

-- Functions
function sendNoti(source, cod, title, blip, msg, loc)
local xPlayers = ESX.GetPlayers()

for i=1, #xPlayers, 1 do
  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            local coords = GetEntityCoords(GetPlayerPed(source))
            local playerCoords = GetEntityCoords(GetPlayerPed(xPlayers[i]))
            TriggerClientEvent('entornos:near', xPlayers[i], coords, playerCoords, '[' .. source .. '] Se ha mandado un rol de entorno a la policía')
            if xPlayer.job.name == 'police' or xPlayer.getGroup() == 'admin' then
                TriggerClientEvent('entornos:notifications', xPlayers[i], title, cod, source, msg, loc)
                TriggerClientEvent('entornos:LSPDMarker', xPlayers[i], GetEntityCoords(GetPlayerPed(source)), source, blip)
            end
        end
    end
end

function sendChatMsgPolice(source, msg, loc)
local xPlayers = ESX.GetPlayers()

for i=1, #xPlayers, 1 do
  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            local coords = GetEntityCoords(GetPlayerPed(source))
            local playerCoords = GetEntityCoords(GetPlayerPed(xPlayers[i]))
            TriggerClientEvent('entornos:near', xPlayers[i], coords, playerCoords, '[' .. source .. '] Se ha mandado un rol de entorno a la policía')
            if xPlayer.job.name == 'police' or xPlayer.getGroup() == 'admin' then
                TriggerClientEvent('entornos:notifications', xPlayers[i], Config.codes['entorno'].title, Config.codes['entorno'].cod, source, table.concat(msg, " "), loc)
                TriggerClientEvent('entornos:LSPDMarker', xPlayers[i], GetEntityCoords(GetPlayerPed(source)), source, Config.codes['entorno'].blip)
            end
        end
    end
end

function sendChatMsgEms(source, msg, loc)
  local xPlayers = ESX.GetPlayers()

  for i=1, #xPlayers, 1 do
  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            local coords = GetEntityCoords(GetPlayerPed(source))
            local playerCoords = GetEntityCoords(GetPlayerPed(xPlayers[i]))
            TriggerClientEvent('entornos:near', xPlayers[i], coords, playerCoords, '[' .. source .. '] Se ha mandado un rol de entorno a los servicios médicos')
            if xPlayer.job.name == 'ambulance' or xPlayer.getGroup() == 'admin' then
                TriggerClientEvent('entornos:notificationsEms', xPlayers[i], Config.codes['ems'].title, Config.codes['ems'].cod, source, table.concat(msg, " "), loc)
                TriggerClientEvent('entornos:LSPDMarker', xPlayers[i], GetEntityCoords(GetPlayerPed(source)), source, Config.codes['ems'].blip)
            end
        end
    end
end

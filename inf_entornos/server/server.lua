ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('inf_entornos:gunshotInProgress')
AddEventHandler('inf_entornos:gunshotInProgress', function(street, weapon, source, playerType)
    local playerGender = 'Un Hombre'
    if playerType == 5 then playerGender = 'Una Mujer' end

    notification(source, Config.codes['disparos'].cod, Config.codes['disparos'].title, Config.codes['disparos'].blip, 'Hay un tiroteo en progreso! '.. playerGender ..' está disparando con un/una ' .. weapon, street)
end)

RegisterServerEvent('inf_entornos:forzar')
AddEventHandler('inf_entornos:forzar', function(source, veh)
    local data = 'Vehiculo: ' .. veh.model .. '<br> Matrícula: ' .. veh.plate .. '<br> Color: ' .. veh.color

    notification(source, Config.codes['forzar'].cod, Config.codes['forzar'].title, Config.codes['forzar'].blip, data, veh.street)
end)

RegisterServerEvent('inf_entornos:vel')
AddEventHandler('inf_entornos:vel', function(source, veh, velocity)
    local data = 'Vehiculo: ' .. veh.model .. '<br> Matrícula: ' .. veh.plate .. '<br> Color: ' .. veh.color .. '<br> A: ' .. velocity .. 'km/h'

    notification(source, Config.codes['speed'].cod, Config.codes['speed'].title, Config.codes['speed'].blip, data, veh.street)
end)

RegisterServerEvent('inf_entornos:entorno')
AddEventHandler('inf_entornos:entorno', function(source, street, msg)
    entorno(source, msg, street)
end)

RegisterServerEvent('inf_entornos:socorro')
AddEventHandler('inf_entornos:socorro', function(source, street, msg)
    notificationEms(source, msg, street)
end)

-- Exports
exports('vel', function(source, model, street, primary, velocity)
    primary = Config.colors[tostring(primary)]
    local data = 'Vehiculo: ' .. model .. '<br> Color: ' .. primary .. '<br> A: ' .. velocity .. 'km/h'

    notification(source, Config.codes['speed'].cod, Config.codes['speed'].title, Config.codes['speed'].blip, data, street)
end)

exports('drug', function(source, msg, loc)
    notification(source, Config.codes['drogas'].cod, Config.codes['drogas'].title, Config.codes['drogas'].blip, msg, loc)
end)

exports('store', function(source, msg, loc)
    notification(source, Config.codes['atraco'].cod, Config.codes['atraco'].title, Config.codes['atraco'].blip, msg, loc)
end)

-- Functions
function entorno(source, msg, loc)
    notification(source, Config.codes['entorno'].cod, Config.codes['entorno'].title, Config.codes['entorno'].blip, table.concat(msg, ' '), loc)
end

function notification(source, cod, title, blip, msg, loc)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            local coords = GetEntityCoords(GetPlayerPed(source))
            local playerCoords = xPlayer.getCoords(true)
            TriggerClientEvent('inf_inf_entornos:cerca', xPlayers[i], coords, playerCoords, '[' .. source .. '] Se ha mandado un rol de entorno a la policía')
            if xPlayers.job.name == 'police' or xPlayers.getGroup() == 'admin' then
                TriggerClientEvent('inf_entornos:notifications', xPlayers[i], title, cod, source, msg, loc)
                TriggerClientEvent('inf_entornos:LSPDMarker', xPlayers[i], coords, source, blip)
            end
        end
    end
end

function notificationEms(source, msg, loc)
  local xPlayers = ESX.GetPlayers()

  for i=1, #xPlayers, 1 do
  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            local coords = GetEntityCoords(GetPlayerPed(source))
            local playerCoords = GetEntityCoords(GetPlayerPed(xPlayers[i]))
            TriggerClientEvent('inf_entornos:near', xPlayers[i], coords, playerCoords, '[' .. source .. '] Se ha mandado un rol de entorno a los servicios médicos')
            if xPlayer.job.name == 'ambulance' or xPlayer.getGroup() == 'admin' then
                TriggerClientEvent('inf_entornos:notificationsEms', xPlayers[i], Config.codes['ems'].title, Config.codes['ems'].cod, source, table.concat(msg, " "), loc)
                TriggerClientEvent('inf_entornos:LSPDMarker', xPlayers[i], GetEntityCoords(GetPlayerPed(source)), source, Config.codes['ems'].blip)
            end
        end
    end
end

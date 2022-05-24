ESX = nil

local data = {}
local insideZone = -1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('chat:addSuggestion', '/zona', 'Crea un entorno de zona /zona [distancia] [mensaje]', {
    { name='distancia', help='La distancia a la que mensaje será mostrado' },
    { name='mensaje', help='El mensaje a ser mostrado' }
})
TriggerEvent('chat:addSuggestion', '/borarzona', 'Borra el entorno de zona /borrarzona [id]', {
    { name='id', help='El id del entorno a ser borrado' }
})
TriggerEvent('chat:addSuggestion', '/reloadzona', 'Recarga los entornos de zona para ti', {})
TriggerEvent('chat:addSuggestion', '/recargarzonas', 'Recarga los entornos de zona para todo el servidor', {})

--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if data ~= nil and data ~= {} then
            local pos = GetEntityCoords(PlayerPedId())

            for i = 1, #data, 1 do
                local zone = data[i]
                if pos ~= nil then
                    local distance = #(pos - zone.coords)
                    if insideZone == -1 then
                        if distance <= (tonumber(zone.distance) or 20) then
                            TriggerEvent('chat:addMessage', {
                                color = { 5, 255, 255 },
                                multiline = true,
                                args = { 'Entorno de Zona [' .. zone.id .. ']: ' .. zone.msg }
                            })
                            insideZone = zone.id
                        end
                    else
                        if insideZone == zone.id and (distance > (tonumber(zone.distance) or 20)) then
                            insideZone = -1
                        end
                    end
                end
            end
        else
            TriggerServerEvent('inf_zona:loadData')
            Citizen.Wait(1000)
        end
        Citizen.Wait(1500)
    end
end)
--

AddEventHandler('playerSpawned', function(spawn)
    Citizen.Wait(7000)
    TriggerServerEvent('inf_zona:loadData')
end)

RegisterNetEvent('inf_zona:sendData')
AddEventHandler('inf_zona:sendData', function(locations)
    data = {}
    for i = 1, #locations, 1 do
        table.insert(data, {
            id = locations[i].id,
            distance = locations[i].distance,
            coords = vector3(locations[i].x, locations[i].y, locations[i].z),
            msg = locations[i].msg
        })
    end
end)

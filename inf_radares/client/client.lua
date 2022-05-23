ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == PlayerPedId() then
            if PlayerData.job ~= nil and not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
                local ped = GetPlayerPed(-1)
                local coords = GetEntityCoords(ped)
                for i, v in ipairs(Config.radares) do
                    if #(vector3(v.x, v.y, v.z) - coords) < 20 and (v.z - coords.z <= 5) then
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local velocity = round(GetEntitySpeed(vehicle) * 3.6, 0)
                        local plate = GetVehicleNumberPlateText(vehicle)

                        if velocity > round(v.velocidad + (v.velocidad * Config.margen), 0) then
                            SetNuiFocus(false,false)
                            SendNUIMessage({type = 'openSpeedcamera'})
                            TriggerServerEvent('radares:multa', GetPlayerServerId(PlayerId()), velocity, v.velocidad, plate)
                            Citizen.Wait(200)
                            SendNUIMessage({type = 'closeSpeedcamera'})

                            -- Comprobación de velocidad y aviso

                            if velocity >= Config.aviso or velocity >= Config.avisoFuera then
                                local vehicleData = vehicleData()
                                TriggerServerEvent('radares:aviso', GetPlayerServerId(PlayerId()), vehicleData, velocity)
                            end
                        end
                        Citizen.Wait(1500)
                        break
                    end
                end
            end
        end
    end
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function vehicleData()
    local player = GetPlayerPed(PlayerId())

    local vehicle = GetVehiclePedIsIn(player, false)
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    local playerCoords = GetEntityCoords(PlayerPedId())
    local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local street = GetStreetNameFromHashKey(streetName)

    local plate = GetVehicleNumberPlateText(vehicle)

    local primary, secondary = GetVehicleColours(vehicle)

    local color = Config.colors[tostring(primary)] .. ' nacarado ' .. Config.colors[tostring(secondary)]

    -- Posición de carretera
    if crossingRoad ~= 0 then
        street = GetStreetNameFromHashKey(streetName) .. ' con ' .. GetStreetNameFromHashKey(crossingRoad)
    end

    -- Prevenir modelos NULL
    if model == 'NULL' then model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) end

    return { model = model, street = street, color = color, plate = plate }
end
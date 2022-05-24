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
                    if #(vector3(v.x, v.y, v.z) - coords) < 20 then
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local velocity = round(GetEntitySpeed(vehicle) * 3.6, 0)
                        local plate = GetVehicleNumberPlateText(vehicle)

                        if velocity > (v.velocidad + Config.margen) then
                            SetNuiFocus(false,false)
                            SendNUIMessage({type = 'openSpeedcamera'})
                            TriggerServerEvent('radares:multa', GetPlayerServerId(PlayerId()), velocity, v.velocidad, plate)
                            Citizen.Wait(200)
                            SendNUIMessage({type = 'closeSpeedcamera'})

                            -- Comprobación de velocidad y aviso

                            if velocity >= Config.aviso or velocity >= Config.avisoFuera then
                                local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                                local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                                local street = GetStreetNameFromHashKey(streetName)
                                local primary, secondary = GetVehicleColours(vehicle)
                                if crossingRoad ~= 0 then street = GetStreetNameFromHashKey(streetName) .. ' con ' .. GetStreetNameFromHashKey(crossingRoad) end
                                if model == 'NULL' then model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) end
                                TriggerServerEvent('radares:aviso', GetPlayerServerId(PlayerId()), model, street, primary, velocity)
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

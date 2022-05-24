ESX = nil
LatestBlip = nil

TriggerEvent('chat:addSuggestion', '/entorno', 'Manda un aviso al LSPD', {
    { name = 'Aviso', help = "Escribe tu entorno" }
})
TriggerEvent('chat:addSuggestion', '/socorro', 'Manda un aviso a los EMS (LSFD)', {
    { name = 'Aviso', help = "Escribe tu aviso" }
})
TriggerEvent('chat:addSuggestion', '/forzar', 'Manda un entorno al LSPD', {})
TriggerEvent('chat:addSuggestion', '/vel', 'Manda un entorno de velocidad al LSPD', {})

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


-- Teclas
Citizen.CreateThread(function ()
    while true do
        if LatestBlip ~= nil then
            if IsControlPressed(0, Config.keys.aceptar) then
                SetWaypointOff()
                SetNewWaypoint(LatestBlip.x, LatestBlip.y)
                LatestBlip = nil
            end
        end
        Citizen.Wait(100)
    end
end)

function vehicleData()
    local player = GetPlayerPed(PlayerId())

    local vehicle = GetVehiclePedIsIn(player, false)
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    local playerCoords = GetEntityCoords(PlayerPedId())
    local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local street = GetStreetNameFromHashKey(streetName)

    local plate = GetVehicleNumberPlateText(vehicle)

    local primary, secondary = GetVehicleColours(vehicle)

    if crossingRoad ~= 0 then
        street = GetStreetNameFromHashKey(streetName) .. ' con ' .. GetStreetNameFromHashKey(crossingRoad)
    end

    if model == 'NULL' then model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) end

    return { model = model, street = street, primary = primary, plate = plate }
end


RegisterCommand("forzar", function(source, args, rawCommand)
    if not IsPedInAnyVehicle(PlayerPedId(), true) then return end
    TriggerServerEvent('entornos:forzar', GetPlayerServerId(PlayerId()), vehicleData())
end, false)

RegisterCommand("vel", function(source, args, rawCommand)
    if not IsPedInAnyVehicle(PlayerPedId(), true) then return end
    local velocity = round(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(PlayerId()), false)) * 3.6, 0)
    TriggerServerEvent('entornos:vel', GetPlayerServerId(PlayerId()), vehicleData(), velocity)
end, false)

RegisterCommand('entorno', function(source, args, rawCommand)
  local playerCoords = GetEntityCoords(PlayerPedId())
  local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
  local street = GetStreetNameFromHashKey(streetName)
  if crossingRoad ~= 0 then street = GetStreetNameFromHashKey(streetName) .. ' con ' .. GetStreetNameFromHashKey(crossingRoad) end
  TriggerServerEvent('entornos:entorno', GetPlayerServerId(PlayerId()), street, args)
end, false)

RegisterCommand('socorro', function(source, args, rawCommand)
  local playerCoords = GetEntityCoords(PlayerPedId())
  local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
  local street = GetStreetNameFromHashKey(streetName)
  if crossingRoad ~= 0 then street = GetStreetNameFromHashKey(streetName) .. ' con ' .. GetStreetNameFromHashKey(crossingRoad) end
  TriggerServerEvent('entornos:socorro', GetPlayerServerId(PlayerId()), street, args)
end, false)

--

RegisterNetEvent("entornos:near")
AddEventHandler("entornos:near", function(coords, playerCoords, msg)
  if #(coords.xy - playerCoords.xy) < 20 then
    TriggerEvent('chat:addMessage', {
      color = { 135, 135, 135 },
      multiline = true,
      args = { msg }
    })
  end
end)

-- LSPD
RegisterNetEvent('entornos:notifications')
AddEventHandler('entornos:notifications', function(title, cod, source, msg, loc)
    local data = {["code"] = cod, ["title"] = title, ['id'] = source, ['msg'] = msg, ["loc"] = loc}
    SendNUIMessage({
        info = data
    })
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1.5)

    TriggerEvent('chat:addMessage', {
      color = { 234, 98, 4 },
      multiline = true,
      args = { '🚓 '.. title.. ': ', msg:gsub("<br>", ",") }
    })
end)

-- EMS
RegisterNetEvent('entornos:notificationsEms')
AddEventHandler('entornos:notificationsEms', function(title, cod, source, msg, loc)
    local data = {["code"] = cod, ["title"] = title, ['id'] = source, ['msg'] = msg, ["loc"] = loc}
    SendNUIMessage({
        info = data
    })
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1.5)

    TriggerEvent('chat:addMessage', {
        color = { 234, 98, 4 },
        multiline = true,
        args = { '🚑 '.. title.. ': ', msg:gsub("<br>", ",") }
    })
end)

-- Shots Fired!
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
        local playerPed = PlayerPedId()
        local shot = IsPedShooting(playerPed)
        local silence = IsPedCurrentWeaponSilenced(playerPed)

        if shot and not silence then
            local xPlayer = ESX.GetPlayerData()
            if xPlayer.job.name ~= 'police' then
                local playerCoords = GetEntityCoords(playerPed)
                local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
                local street = GetStreetNameFromHashKey(streetName)

                if crossingRoad ~= 0 then
                  street = GetStreetNameFromHashKey(streetName) .. ' con ' .. GetStreetNameFromHashKey(crossingRoad)
                end
                TriggerServerEvent('entornos:gunshotInProgress', street, GetPlayerServerId(PlayerId()), GetPedType(GetPlayerPed(GetPlayerFromServerId(PlayerId()))))
                Citizen.Wait(5000)
            end
        end
    end
end)

RegisterNetEvent('entornos:LSPDMarker')
AddEventHandler('entornos:LSPDMarker', function(targetCoords, id, sprite)
    PlayerData = ESX.GetPlayerData()
    if PlayerData.job.name == 'police' and sprite ~= 353 then
        showBlip(sprite, targetCoords)
    elseif PlayerData.job.name == 'ambulance' and sprite == 353 then
        showBlip(sprite, targetCoords)
    end
end)

function showBlip(sprite, targetCoords)
    local call = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

    SetBlipSprite(call, sprite)
    SetBlipDisplay(call, 4)
    SetBlipScale(call, 0.8)
    SetBlipAsShortRange(call, true)

    SetBlipHighDetail(call, true)
    SetBlipAsShortRange(call, true)
    SetBlipColour(call, 1)
    BeginTextCommandSetBlipName('STRING')

    if sprite == 58 then
        AddTextComponentString(Config.codes['entorno'].cod)
    elseif sprite == 110 then
        AddTextComponentString(Config.codes['disparos'].cod)
    elseif sprite == 229 then
        AddTextComponentString(Config.codes['forzar'].cod)
    elseif sprite == 134 then
        AddTextComponentString(Config.codes['atraco'].cod)
    elseif sprite == 354 then
        AddTextComponentString(Config.codes['speed'].cod)
    elseif sprite == 353 then
        AddTextComponentString(Config.codes['ems'].cod)
    end
    EndTextCommandSetBlipName(call)
    LatestBlip = targetCoords
    removeBlip(call)
end

function removeBlip(blip)
    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        RemoveBlip(blip)
        LatestBlip = nil
    end)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

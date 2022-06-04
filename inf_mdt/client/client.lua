ESX = nil
local PlayerData = {}

local tab = 0

-- ESX
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
    while ESX.GetPlayerData().job == nil do Citizen.Wait(100) end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)
--

-- Data
RegisterKeyMapping('mdt', 'Tecla para abrir la tablet [Policia/EMS/Mecánico]', 'keyboard', Config.tecla)
TriggerEvent('chat:addSuggestion', '/mdt', 'Abre la tablet [Policia/EMS/Mecánico]', {})
--

-- Funciones

--

-- Eventos
RegisterNetEvent('mdt:open')
AddEventHandler('mdt:open', function()
    if PlayerData.job and PlayerData.job.name == "police"  then
        toggleNuiFrame(true)
        debugPrint('Mostrando MDT')
    end
end)
--

-- NUI
local function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage('setVisible', shouldShow)

    if shouldShow then
        RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")
        while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
        tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    else
        StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
        DeleteObject(tab)
    end
end

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    debugPrint('Ocultando MDT')
    cb({})
end)

RegisterNUICallback('getClientData', function(data, cb)
    debugPrint('Data sent by React', json.encode(data))

    -- Lets send back client coords to the React frame for use
    local curCoords = GetEntityCoords(PlayerPedId())

    local retData <const> = { x = curCoords.x, y = curCoords.y, z = curCoords.z }
    cb(retData)
end)
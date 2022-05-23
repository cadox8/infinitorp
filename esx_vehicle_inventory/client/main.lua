ESX = nil
local GUI, vehiclePlate, PlayerData = {}, {}, {}
local lastVehicle
local lastOpen = false
GUI.Time = 0
local arrayWeight = Config.localWeight

function getItemyWeight(item)
    local weight = 0
    local itemWeight = 0

    if item ~= nil then
        itemWeight = Config.DefaultWeight
        if arrayWeight[item] ~= nil then
            itemWeight = arrayWeight[item]
        end
    end
    return itemWeight
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent("esx_truck_inventory:getOwnedVehicule")
end)

RegisterNetEvent('esx_truck_inventory:setOwnedVehicule')
AddEventHandler('esx_truck_inventory:setOwnedVehicule', function(vehicle)
    vehiclePlate = vehicle
end)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function VehicleMaxSpeed(vehicle, weight, maxweight)
    local percent = (weight / maxweight) * 100
    local hashk = GetEntityModel(vehicle)
    if percent > 80 then
        SetEntityMaxSpeed(vehFront, GetVehicleModelMaxSpeed(hashk) / 1.4)
    elseif percent > 50 then
        SetEntityMaxSpeed(vehFront, GetVehicleModelMaxSpeed(hashk) / 1.2)
    else
        SetEntityMaxSpeed(vehFront, GetVehicleModelMaxSpeed(hashk))
    end
end

-- Key controls
Citizen.CreateThread(function()
    while true do

        Wait(0)

        if IsControlPressed(0, 311) and (GetGameTimer() - GUI.Time) > 150 then
            local vehFront = VehicleInFront()
            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
            if vehFront > 0 and closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) then
                lastVehicle = vehFront
                local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
                local locked = GetVehicleDoorLockStatus(closecar)
                local class = GetVehicleClass(vehFront)
                ESX.UI.Menu.CloseAll()
                if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'inventory') then
                    SetVehicleDoorShut(vehFront, 5, false)
                else
                    if locked == 1 or class == 15 or class == 16 or class == 14 then
                        SetVehicleDoorOpen(vehFront, 5, false, false)
                        ESX.UI.Menu.CloseAll()

                        TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
                    else
                        ESX.ShowNotification('El maletero está ~r~cerrado')
                    end
                end
            else
                ESX.ShowNotification('Ningún ~r~vehículo~w~ cerca')
            end
            lastOpen = true
            GUI.Time = GetGameTimer()
        elseif lastOpen and IsControlPressed(0, 177) and (GetGameTimer() - GUI.Time) > 150 then
            lastOpen = false
            ESX.UI.Menu.CloseAll()
            if lastVehicle or 0 > 0 then
                SetVehicleDoorShut(lastVehicle, 5, false)
                lastVehicle = 0
            end
            GUI.Time = GetGameTimer()
        end
    end
end)

RegisterNetEvent('esx_truck_inventory:getInventoryLoaded')
AddEventHandler('esx_truck_inventory:getInventoryLoaded', function(inventory, weight)
    local elements = {}
    local vehFrontBack = VehicleInFront()
    TriggerServerEvent("esx_truck_inventory:getOwnedVehicule")

    table.insert(elements, {
        label = 'Depositar',
        count = 0,
        value = 'deposit',
    })

    if inventory ~= nil and #inventory > 0 then
        for i = 1, #inventory, 1 do
            if inventory[i].type == 'item_standard' then
                table.insert(elements, {
                    label     = inventory[i].label .. ' x' .. inventory[i].count,
                    count     = inventory[i].count,
                    value     = inventory[i].name,
                    type	  = inventory[i].type
                })
            elseif inventory[i].type == 'item_weapon' then
                table.insert(elements, {
                    label     = inventory[i].label .. ' ['..inventory[i].ammo..' balas]' ..' x '..inventory[i].count,
                    count     = inventory[i].count,
                    value     = inventory[i].name,
                    type	  = inventory[i].type
                })
            elseif inventory[i].type == 'item_account' then
                table.insert(elements, {
                    label     = inventory[i].label .. ' [ $' .. inventory[i].count..' ]',
                    count     = inventory[i].count,
                    value     = inventory[i].name,
                    type	  = inventory[i].type
                })
            end
        end
    end

    ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'inventory_deposit',
            {
                title = 'Maletero',
                align = 'right',
                elements = elements,
            },
            function(data, menu)
                if data.current.value == 'deposit' then
                    local elem = {}
                    PlayerData = ESX.GetPlayerData()
                    for i=1, #PlayerData.accounts, 1 do
                        if PlayerData.accounts[i].name == 'black_money' then
                            table.insert(elem, {
                                label     = PlayerData.accounts[i].label .. ' [ $'.. math.floor(PlayerData.accounts[i].money+0.5) ..' ]',
                                count     = PlayerData.accounts[i].money,
                                value     = PlayerData.accounts[i].name,
                                name      = PlayerData.accounts[i].label,
                                limit     = PlayerData.accounts[i].limit,
                                type		= 'item_account',
                            })
                            -- end
                        end
                    end

                    for i=1, #PlayerData.inventory, 1 do
                        if PlayerData.inventory[i].count > 0 then
                            table.insert(elem, {
                                label     = PlayerData.inventory[i].label .. ' x' .. PlayerData.inventory[i].count,
                                count     = PlayerData.inventory[i].count,
                                value     = PlayerData.inventory[i].name,
                                name      = PlayerData.inventory[i].label,
                                limit     = PlayerData.inventory[i].limit,
                                type		= 'item_standard',
                            })
                        end
                    end

                    local playerPed  = GetPlayerPed(-1)
                    local weaponList = ESX.GetWeaponList()

                    for i=1, #weaponList, 1 do

                        local weaponHash = GetHashKey(weaponList[i].name)

                        if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
                            local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                            table.insert(elem, {label = weaponList[i].label .. ' [' .. ammo .. '] x 1',name = weaponList[i].label, type = 'item_weapon', value = weaponList[i].name, count = 1, ammo = ammo})
                        end

                    end
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_player', {
                        title = 'Contenido del inventario',
                        align = 'right',
                        elements = elem,
                    }, function(data3, menu3)
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
                            title = 'cantidad'
                        }, function(data4, menu4)
                            local quantity = tonumber(data4.value)
                            local Itemweight = tonumber(getItemyWeight(data3.current.value)) * quantity
                            local totalweight = tonumber(weight) + Itemweight
                            vehFront = VehicleInFront()

                            local typeVeh = GetVehicleClass(vehFront)

                            if totalweight > Config.VehicleLimit[typeVeh] then
                                max = true
                            else
                                max = false
                            end

                            ownedV = 0
                            while vehiclePlate == '' do Wait(1000) end
                            for i = 1, #vehiclePlate do
                                if vehiclePlate[i].plate == GetVehicleNumberPlateText(vehFront) then
                                    ownedV = 1
                                    break
                                else
                                    ownedV = 0
                                end
                            end

                            --fin test

                            if quantity > 0 and quantity <= tonumber(data3.current.count) and vehFront > 0 then
                                local MaxVh = (tonumber(Config.VehicleLimit[typeVeh]) / 1000)
                                local Kgweight = totalweight / 1000
                                if not max then
                                    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                                    local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)

                                    --  VehicleMaxSpeed(closecar,totalweight,Config.VehicleLimit[GetVehicleClass(closecar)])

                                    TriggerServerEvent('esx_truck_inventory:addInventoryItem', GetVehicleClass(closecar), GetDisplayNameFromVehicleModel(GetEntityModel(closecar)),
                                            GetVehicleNumberPlateText(vehFront), data3.current.value, quantity, data3.current.name, data3.current.type, ownedV, data3.current.ammo or 0)
                                    ESX.ShowNotification('Peso del maletero: ~g~' .. Kgweight .. ' Kg / ' .. MaxVh .. ' Kg')
                                else
                                    ESX.ShowNotification('Has alcanzado el limite de ~r~ ' .. MaxVh .. ' Kg')
                                end
                            else
                                ESX.ShowNotification('~r~ Cantidad invalida')
                            end

                            ESX.UI.Menu.CloseAll()
                        end, function(data4, menu4)
                            SetVehicleDoorShut(vehFrontBack, 5, false)
                            ESX.UI.Menu.CloseAll()
                        end)
                    end)
                else
                    local title = 'Cantidad'
                    if data.current.type == 'item_weapon' then title = 'Munición' end
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
                        title = title
                    }, function(data2, menu2)
                        local quantity = tonumber(data2.value)
                        local ammo = tonumber(data2.value)
                        if data.current.type == 'item_weapon' then
                            quantity = 1
                        else
                            ammo = 0
                        end
                        PlayerData = ESX.GetPlayerData()
                        vehFront = VehicleInFront()

                        --test
                        local Itemweight = tonumber(getItemyWeight(data.current.value)) * quantity
                        local poid = weight - Itemweight

                        for i = 1, #PlayerData.inventory, 1 do

                            if PlayerData.inventory[i].name == data.current.value then
                                if tonumber(PlayerData.inventory[i].limit or 50000000) < tonumber(PlayerData.inventory[i].count) + quantity and PlayerData.inventory[i].limit ~= -1 then
                                    max = true
                                else
                                    max = false
                                end
                            end
                        end

                        --fin test

                        if quantity > 0 and (quantity <= tonumber(data.current.count) or quantity <= tonumber(data.current.ammo)) and vehFront > 0 then
                            if not max then
                                TriggerServerEvent('esx_truck_inventory:removeInventoryItem', GetVehicleNumberPlateText(vehFront), data.current.value, data.current.type, quantity, ammo)

                            else
                                ESX.ShowNotification('~r~ No puede llevar tanto')
                            end
                        else
                            ESX.ShowNotification('~r~ Cantidad invalida')
                        end

                        ESX.UI.Menu.CloseAll()

                        local vehFront = VehicleInFront()
                        if vehFront > 0 then
                            ESX.SetTimeout(1500, function()
                                TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
                            end)
                        else
                            SetVehicleDoorShut(vehFrontBack, 5, false)
                        end
                    end, function(data2, menu2)
                        SetVehicleDoorShut(vehFrontBack, 5, false)
                        ESX.UI.Menu.CloseAll()
                    end)
                end
            end)
end)

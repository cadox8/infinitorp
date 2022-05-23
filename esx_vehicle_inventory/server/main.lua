ESX = nil
local arrayWeight = Config.localWeight

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('esx_truck_inventory:getOwnedVehicule')
AddEventHandler('esx_truck_inventory:getOwnedVehicule', function()
    local vehicules = {}
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        if result ~= nil and #result > 0 then
            for _, v in pairs(result) do
                local vehicle = json.decode(v.vehicle)
                --print(vehicle.plate)
                table.insert(vehicules, { plate = vehicle.plate })
            end
        end
        TriggerClientEvent('esx_truck_inventory:setOwnedVehicule', _source, vehicules)
    end)
end)

function getInventoryWeight(inventory)
    local weight = 0
    local itemWeight = 0

    if inventory ~= nil then
        for i = 1, #inventory, 1 do
            if inventory[i] ~= nil then
                itemWeight = Config.DefaultWeight
                if arrayWeight[inventory[i].name] ~= nil then
                    itemWeight = arrayWeight[inventory[i].name]
                end
                weight = weight + (itemWeight * inventory[i].count)
            end
        end
    end
    return weight
end

RegisterServerEvent('esx_truck_inventory:getInventory')
AddEventHandler('esx_truck_inventory:getInventory', function(plate)
    local inventory_ = {}
    local _source = source
    MySQL.Async.fetchAll('SELECT * FROM `truck_inventory` WHERE `plate` = @plate', {
        ['@plate'] = plate
    }, function(inventory)
        if inventory ~= nil and #inventory > 0 then
            for i = 1, #inventory, 1 do
                table.insert(inventory_, {
                    label = inventory[i].name,
                    name = inventory[i].item,
                    count = inventory[i].count,
                    type = inventory[i].itemtype,
                    ammo = inventory[i].ammo
                })
            end
        end
        local weight = (getInventoryWeight(inventory_))
        local xPlayer = ESX.GetPlayerFromId(_source)
        TriggerClientEvent('esx_truck_inventory:getInventoryLoaded', xPlayer.source, inventory_, weight)
    end)
end)

RegisterServerEvent('esx_truck_inventory:removeInventoryItem')
AddEventHandler('esx_truck_inventory:removeInventoryItem', function(plate, item, itemType, count, ammo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if plate ~= " " or plate ~= nil or plate ~= "" then
        MySQL.Async.fetchAll('SELECT count, ammo FROM truck_inventory WHERE `plate` = @plate AND `item`= @item AND `itemtype`= @itemtype',
                {
                    ['@plate'] = plate,
                    ['@item'] = item,
                    ['@itemtype'] = itemType
                }, function(res)
                    if res[1].count >= count then
                        local finalCount = res[1].count - count
                        local finalAmmo = res[1].ammo - ammo

                        if finalCount == 0 then
                            MySQL.Async.execute('delete from `truck_inventory` WHERE `plate` = @plate AND `item`= @item AND `itemtype`= @itemtype',
                                    {
                                        ['@plate'] = plate,
                                        ['@qty'] = count,
                                        ['@item'] = item,
                                        ['@itemtype'] = itemType
                                    })
                        else
                            if itemType == 'item_weapon' then
                                MySQL.Async.execute('UPDATE `truck_inventory` SET `count`= `count` - @qty, `ammo`= @lessAmmo WHERE `plate` = @plate AND `item`= @item AND `itemtype`= @itemtype',
                                        {
                                            ['@plate'] = plate,
                                            ['@qty'] = count,
                                            ['@item'] = item,
                                            ['@lessAmmo'] = finalAmmo,
                                            ['@itemtype'] = itemType
                                        })
                            else
                                MySQL.Async.execute('UPDATE `truck_inventory` SET `count`= `count` - @qty WHERE `plate` = @plate AND `item`= @item AND `itemtype`= @itemtype',
                                        {
                                            ['@plate'] = plate,
                                            ['@qty'] = count,
                                            ['@item'] = item,
                                            ['@itemtype'] = itemType
                                        })
                            end
                        end


                        if xPlayer ~= nil then
                            if itemType == 'item_standard' then xPlayer.addInventoryItem(item, count) end
                            if itemType == 'item_account' then xPlayer.addAccountMoney(item, count) end
                            if itemType == 'item_weapon' then
                                xPlayer.addWeapon(item, 0)
                                xPlayer.addWeaponAmmo(item, ammo)
                            end
                        end
                    end
                end)
    end
end)

RegisterServerEvent('esx_truck_inventory:addInventoryItem')
AddEventHandler('esx_truck_inventory:addInventoryItem', function(type, model, plate, item, count, name, itemType, ownedV, ammo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if plate ~= " " or plate ~= nil or plate ~= "" then
        if xPlayer ~= nil then
            if itemType == 'item_standard' then
                local playerItemCount = xPlayer.getInventoryItem(item).count
                if playerItemCount >= count then
                    xPlayer.removeInventoryItem(item, count)
                    putInTrunk(plate, count, item, name, itemType, ownedV, ammo)
                else
                    TriggerClientEvent('esx:showNotification', _source, '~r~Cantidad inválida')
                end
            end

            if itemType == 'item_account' then
                local playerAccountMoney = xPlayer.getAccount(item).money
                if playerAccountMoney >= count then
                    xPlayer.removeAccountMoney(item, count)
                    putInTrunk(plate, count, item, name, itemType, ownedV, ammo)
                end
            end

            if itemType == 'item_weapon' then
                currentLoadout = xPlayer.getLoadout()
                for i = 1, #currentLoadout, 1 do
                    if currentLoadout[i].name == item then
                        xPlayer.removeWeapon(item, 0)
                        putInTrunk(plate, count, item, name, itemType, ownedV, ammo)
                    end
                end
            end
        end
    end
end)

function putInTrunk(plate, count, item, name, itemType, ownedV, ammo)
    if itemType == 'item_weapon' then
        MySQL.Async.execute('INSERT INTO truck_inventory (item,count,plate,name,itemtype,owned,ammo) VALUES (@item,@qty,@plate,@name,@itemtype,@owned,@ammo) ON DUPLICATE KEY UPDATE count=count+ @qty, ammo=ammo + @ammo',
                {
                    ['@plate'] = plate,
                    ['@qty'] = count,
                    ['@item'] = item,
                    ['@name'] = name,
                    ['@itemtype'] = itemType,
                    ['@owned'] = ownedV,
                    ['@ammo'] = ammo
                })
        else
        MySQL.Async.execute('INSERT INTO truck_inventory (item,count,plate,name,itemtype,owned,ammo) VALUES (@item,@qty,@plate,@name,@itemtype,@owned,@ammo) ON DUPLICATE KEY UPDATE count=count+ @qty',
                {
                    ['@plate'] = plate,
                    ['@qty'] = count,
                    ['@item'] = item,
                    ['@name'] = name,
                    ['@itemtype'] = itemType,
                    ['@owned'] = ownedV,
                    ['@ammo'] = ammo
                })
    end
end
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-- ////////////////////////////////////

RegisterNetEvent('inf_drogas:dodeal')
AddEventHandler('inf_drogas:dodeal', function(drugType)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local drug = nil

		if drugType == Config.drugs.weed.name then
			drug = Config.drugs.weed
		elseif drugType == Config.drugs.cocaine.name then
			drug = Config.drugs.cocaine
		elseif drugType == Config.drugs.meta.name then
			drug = Config.drugs.meta
		elseif drugType == Config.drugs.secret.name then
			drug = Config.drugs.secret
		end

		local playerAmount = xPlayer.getInventoryItem(drug.item).count
		local amount = math.random(1, drug.max)

		if amount > playerAmount then amount = playerAmount end -- To sell the max user has (if amount > playerAmount)

		local finalamount = math.random(drug.price, drug.priceMax) * amount

		xPlayer.removeInventoryItem(drug.item, amount)
		xPlayer.addAccountMoney('black_money', finalamount)
		xPlayer.showNotification('Has vendido ~r~'.. amount .. '~s~ de ~g~'.. drug.name .. ' ~s~por ~r~'.. finalamount ..'~s~$', false, false, 140)
	end
end)

RegisterNetEvent('inf_drogas:avisar')
AddEventHandler('inf_drogas:avisar', function(street)
	exports.entornos:drug(source, 'Acaban de intentar venderme droga', street)
end)

RegisterNetEvent('inf_drogas:checkDrugs')
AddEventHandler('inf_drogas:checkDrugs', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local weed = xPlayer.getInventoryItem(Config.drugs.weed.item).count
		local cocaine = xPlayer.getInventoryItem(Config.drugs.cocaine.item).count
		local meta = xPlayer.getInventoryItem(Config.drugs.meta.item).count
		local secret = xPlayer.getInventoryItem(Config.drugs.secret.item).count

		local drugs = {
		  hasWeed = weed > 0,
		  hasCocaine = cocaine > 0,
		  hasMeta = meta > 0,
		  hasSecret = secret > 0
		}

		TriggerClientEvent("inf_drogas:hasDrugs", source, drugs)
	end
end)

RegisterServerEvent("inf_drogas:police")
AddEventHandler("inf_drogas:police", function()
	local players = ESX.GetPlayers()
	local police = 0

	for i = 1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])

		if xPlayer.job.name == 'police' then
			police = police + 1
		end
	end
	TriggerClientEvent('inf_drogas:policeCount', source, police)
end)

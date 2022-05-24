ESX = nil
selling = false

local police = 0

local drugs = {
  hasWeed = false,
  hasCocaine = false,
  hasMeta = false,
  hasSecret = false
}

-- ESX
Citizen.CreateThread(function()
  	while ESX == nil do
    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(250)
  	end

  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(250)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('skinchanger:loadSkin', function(character)
	playerGender = character.sex
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	Citizen.Wait(5000)
end)
-- ////////////////////////////////////

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ped ~= 0 then
			if not IsPedDeadOrDying(ped) and not IsPedInAnyVehicle(ped) then
        local pedType = GetPedType(ped)
				if ped ~= oldped and not selling and (IsPedAPlayer(ped) == false and pedType ~= 28) then
					if (drugs.hasWeed or drugs.hasCocaine or drugs.hasMeta or drugs.hasSecret) and police > 0 then
						local pos = GetEntityCoords(ped)
            local center = vector3(-250.93, -1035.99, 27.22)

            if #(pos.xy - center.xy) < Config.maxDistance then
              DrawText3Ds(pos.x, pos.y, pos.z, '~s~Pulsa ~r~E ~s~para vender droga')

              -- Check drug to sell (if has more than 1)
              local drugType = 'none'
              if drugs.hasSecret then
                drugType = Config.drugs.secret.name
              elseif drugs.hasMeta then
                drugType = Config.drugs.meta.name
              elseif drugs.hasCocaine then
                drugType = Config.drugs.cocaine.name
              elseif drugs.hasWeed then
                drugType = Config.drugs.weed.name
              end
              --

  						if IsControlJustPressed(1, Config.key) then
  							selling = true
  							interact(drugType)
  						end
            end
					end
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('inf_drogas:hasDrugs')
AddEventHandler('inf_drogas:hasDrugs', function(drug)
  drugs = drug
end)

RegisterNetEvent('inf_drogas:policeCount')
AddEventHandler('inf_drogas:policeCount', function(amount)
  police = amount
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1000)
    local playerPed = GetPlayerPed(-1)
    TriggerServerEvent('inf_drogas:checkDrugs')
    TriggerServerEvent('inf_drogas:police')
    if (not IsPedInAnyVehicle(playerPed) or not IsPedDeadOrDying(playerPed)) and not selling then
      ped = GetPedInFront()
    else
      Citizen.Wait(500)
    end
  end
end)

function interact(drugType)
	oldped = ped
	SetEntityAsMissionEntity(ped)
	TaskStandStill(ped, 5000)
  FreezeEntityPosition(ped, true)
  FreezeEntityPosition(PlayerPedId(), true)

  startUI(Config.sellTime, 'Convenciendo al cliente...')
  talkAnimation()
	Citizen.Wait(Config.sellTime)
  stopTalkAnimation()

	if ESX.PlayerData.job.name == 'police' then
    ESX.ShowNotification('No puedes vender droga porque eres ~r~policia', false, false, 140)
		SetPedAsNoLongerNeeded(oldped)
    ClearPedTasksImmediately(oldped)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(PlayerPedId(), false)
		selling = false
		return
	end

	if ped ~= oldped then
    ESX.ShowNotification('Te has ~r~alejado mucho ~s~del comprador', false, false, 140)
		SetPedAsNoLongerNeeded(oldped)
    ClearPedTasksImmediately(oldped)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(PlayerPedId(), false)
		selling = false
		return
	end

	local percent = math.random(1, 10)

	if percent <= Config.policeAdvisePercent then
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local street = GetStreetNameFromHashKey(streetName)

    if crossingRoad ~= 0 then
      street = GetStreetNameFromHashKey(streetName) .. ' con ' .. GetStreetNameFromHashKey(crossingRoad)
    end

    no()
    TriggerServerEvent('inf_drogas:avisar', street)
    ESX.ShowNotification('El comprador ha rechazado comprarte droga', false, false, 140)
    Wait(1500)
	elseif percent <= 10 then
		agreeAnimation()
		TriggerServerEvent('inf_drogas:dodeal', drugType)
    Wait(1500)
	end
	selling = false
  ClearPedTasksImmediately(oldped)
	SetPedAsNoLongerNeeded(oldped)
  FreezeEntityPosition(ped, false)
  FreezeEntityPosition(PlayerPedId(), false)
end

function startUI(time, text)
	SendNUIMessage({
		type = "droga",
		display = true,
		time = time,
		text = text
	})
end

-- Utils
function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.0, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 2.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 60)
end

function talkAnimation()
  local pid = PlayerPedId()
  local pedCoords = GetEntityCoords(ped)
  local playerRotation = GetEntityRotation(pid, 2)
  loadAnimDict('misscarsteal4@actor')

  local scene = NetworkCreateSynchronisedScene(vector3(pedCoords.x, pedCoords.y, pedCoords.z - 1), vector3(playerRotation.x, playerRotation.y, playerRotation.z - 180), 2, false, false, 1065353216, 0, 1.3)
  NetworkAddPedToSynchronisedScene(ped, scene, 'misscarsteal4@actor', 'actor_berating_loop', 1.5, -4.0, 1, 16, 1148846080, 0)

  NetworkStartSynchronisedScene(scene)

	TaskPlayAnim(pid,"misscarsteal4@actor","actor_berating_loop", 100.0, 100.0, 0.3, 120, 0.2, false, false, false)
	--TaskPlayAnim(ped,"misscarsteal4@actor","actor_berating_loop", 100.0, 100.0, 0.3, 120, 0.2, false, false, false)
end

function stopTalkAnimation()
  StopAnimTask(pid, "misscarsteal4@actor","actor_berating_loop", 1.0)
	StopAnimTask(ped, "misscarsteal4@actor","actor_berating_loop", 1.0)
end

function no()
  local pedCoords = GetEntityCoords(ped)
  local playerRotation = GetEntityRotation(pid, 2)
  loadAnimDict('anim@heists@ornate_bank@chat_manager')

  local scene = NetworkCreateSynchronisedScene(vector3(pedCoords.x, pedCoords.y, pedCoords.z), vector3(playerRotation.x, playerRotation.y, playerRotation.z - 180), 2, false, false, 1065353216, 0, 1.3)
  NetworkAddPedToSynchronisedScene(ped, scene, 'anim@heists@ornate_bank@chat_manager', 'fail', 1.5, -4.0, 1, 16, 1148846080, 0)

  NetworkStartSynchronisedScene(scene)
end

function agreeAnimation()
  local pid = PlayerPedId()
  local pedCoords = GetEntityCoords(ped)
  local playerRotation = GetEntityRotation(pid, 2)
  loadAnimDict('mp_common')

  local scene = NetworkCreateSynchronisedScene(vector3(pedCoords.x, pedCoords.y, pedCoords.z - 1), vector3(playerRotation.x, playerRotation.y, playerRotation.z - 180), 2, false, false, 1065353216, 0, 1.3)
  NetworkAddPedToSynchronisedScene(ped, scene, 'mp_common', 'givetake1_a', 1.5, -4.0, 1, 16, 1148846080, 0)

  NetworkStartSynchronisedScene(scene)

  TaskPlayAnim(pid,"mp_common","givetake1_a", 100.0, 100.0, 0.3, 120, 0.2, false, false, false)
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

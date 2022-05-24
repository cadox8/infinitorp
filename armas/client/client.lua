ESX = nil
local xPlayer = {}

local holstered  = true
local blocked	 = false
local arma = false
local PlayerData = {}
------------------------

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    xPlayer = xPlayer
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		loadAnimDict("reaction@intimidation@1h")
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped, false) then
			if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
				if CheckWeapon(ped) then
					if holstered then
						blocked   = true
							SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
							TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 1.0, -1, 50, 0, 0, 0, 0)
								Citizen.Wait(1250)
							  SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								Citizen.Wait(Config.cooldown)
							ClearPedTasks(ped)
						holstered = false
					else
						blocked = false
					end
				else
					if not holstered then
						TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0)
							Citizen.Wait(Config.cooldown)
							ClearPedTasks(ped)
						holstered = true
					end
				end
			else
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			end
		else
			holstered = true
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if blocked then
			DisableControlAction(1, 25, true )
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 23, true)
			DisableControlAction(1, 37, true)
			DisablePlayerFiring(ped, true)
		end
	end
end)

function CheckWeapon(ped)
	if IsEntityDead(ped) then
		blocked = false
			return false
		else
			for i = 1, #Config.RealWeapons do
				if GetHashKey(Config.RealWeapons[i].name) == GetSelectedPedWeapon(ped) then
					return true
				end
			end
		return false
	end
end

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

---
local Weapons = {}

-----------------------------------------------------------
-----------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local playerPed = GetPlayerPed(-1)

		for i=1, #Config.RealWeapons, 1 do

    		local weaponHash = GetHashKey(Config.RealWeapons[i].name)

    		if HasPedGotWeapon(playerPed, weaponHash, false) then
    			local onPlayer = false

				for k, entity in pairs(Weapons) do
				  if entity then
      				if entity.weapon == Config.RealWeapons[i].name then
      					onPlayer = true
      					break
      				end
				  end
      			end

      			if not onPlayer and weaponHash ~= GetSelectedPedWeapon(playerPed) then
	      			SetGear(Config.RealWeapons[i].name)
      			elseif onPlayer and weaponHash == GetSelectedPedWeapon(playerPed) then
	      			RemoveGear(Config.RealWeapons[i].name)
      			end
			else
				RemoveGear(Config.RealWeapons[i].name)
    		end
  		end
		Wait(500)
	end
end)
-----------------------------------------------------------
-----------------------------------------------------------
RegisterNetEvent('removeWeapon')
AddEventHandler('removeWeapon', function(weaponName)
	RemoveGear(weaponName)
end)
RegisterNetEvent('removeWeapons')
AddEventHandler('removeWeapons', function()
	RemoveGears()
end)
-----------------------------------------------------------
-----------------------------------------------------------
function RemoveGear(weapon)
	local _Weapons = {}

	for i, entity in pairs(Weapons) do
		if entity.weapon ~= weapon then
			_Weapons[i] = entity
		else
			DeleteWeapon(entity.obj)
		end
	end

	Weapons = _Weapons
end
-----------------------------------------------------------
-----------------------------------------------------------
function RemoveGears()
	for i, entity in pairs(Weapons) do
		DeleteWeapon(entity.obj)
	end
	Weapons = {}
end
-----------------------------------------------------------
-----------------------------------------------------------
function SpawnObject(model, coords, cb)

  local model = (type(model) == 'number' and model or GetHashKey(model))

  Citizen.CreateThread(function()

    RequestModel(model)

    while not HasModelLoaded(model) do
      Citizen.Wait(0)
    end

    local obj = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)

    if cb ~= nil then
      cb(obj)
    end

  end)

end

function DeleteWeapon(object)
  SetEntityAsMissionEntity(object,  false,  true)
  DeleteObject(object)
end
-- Add one weapon on the ped
function SetGear(weapon)
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local playerPed  = GetPlayerPed(-1)
	local model      = nil
	local playerWeapons = getWeapons()

	for i=1, #Config.RealWeapons, 1 do
		if Config.RealWeapons[i].name == weapon then
			bone     = Config.RealWeapons[i].bone
			boneX    = Config.RealWeapons[i].x
			boneY    = Config.RealWeapons[i].y
			boneZ    = Config.RealWeapons[i].z
			boneXRot = Config.RealWeapons[i].xRot
			boneYRot = Config.RealWeapons[i].yRot
			boneZRot = Config.RealWeapons[i].zRot
			model    = Config.RealWeapons[i].model
			break
		end
	end

	SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		local playerPed = GetPlayerPed(-1)
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)
		AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
		table.insert(Weapons,{weapon = weapon, obj = obj})
	end)
end

local weapon_types = {
  "WEAPON_STUNGUN",
  "WEAPON_BAT",
  "WEAPON_GOLFCLUB",
  "WEAPON_CROWBAR",
  "WEAPON_PISTOL",
  "WEAPON_COMBATPISTOL",
  "WEAPON_APPISTOL",
  "WEAPON_PISTOL50",
  "WEAPON_MICROSMG",
  "WEAPON_SMG",
  "WEAPON_ASSAULTSMG",
  "WEAPON_ASSAULTRIFLE",
  "WEAPON_CARBINERIFLE",
  "WEAPON_SPECIALCARBINE",
  "WEAPON_ADVANCEDRIFLE",
  "WEAPON_MG",
  "WEAPON_COMBATMG",
  "WEAPON_PUMPSHOTGUN",
  "WEAPON_SAWNOFFSHOTGUN",
  "WEAPON_ASSAULTSHOTGUN",
  "WEAPON_BULLPUPSHOTGUN",
  "WEAPON_STUNGUN",
  "WEAPON_SNIPERRIFLE",
  "WEAPON_HEAVYSNIPER",
  "WEAPON_REMOTESNIPER",
  "WEAPON_GRENADELAUNCHER",
  "WEAPON_GRENADELAUNCHER_SMOKE",
  "WEAPON_RPG",
  "WEAPON_PASSENGER_ROCKET",
  "WEAPON_AIRSTRIKE_ROCKET",
  "WEAPON_STINGER",
  "WEAPON_MINIGUN",
  "WEAPON_GRENADE",
  "WEAPON_STICKYBOMB",
  "WEAPON_SMOKEGRENADE",
  "WEAPON_BZGAS",
  "WEAPON_MOLOTOV",
  "WEAPON_FIREEXTINGUISHER",
  "WEAPON_PETROLCAN",
  "WEAPON_DIGISCANNER",
  "WEAPON_BRIEFCASE",
  "WEAPON_BRIEFCASE_02",
  "WEAPON_BALL",
  "WEAPON_FLARE",
--"WEAPON_UNARMED",
  "WEAPON_BAT",
  "WEAPON_GOLFCLUB",
  "WEAPON_CROWBAR",
  "WEAPON_PISTOL",
  "WEAPON_COMBATPISTOL",
  "WEAPON_APPISTOL",
  "WEAPON_PISTOL50",
  "WEAPON_MICROSMG",
  "WEAPON_SMG",
  "WEAPON_ASSAULTSMG",
  "WEAPON_ASSAULTRIFLE",
  "WEAPON_CARBINERIFLE",
  "WEAPON_ADVANCEDRIFLE",
  "WEAPON_MG",
  "WEAPON_COMBATMG",
  "WEAPON_PUMPSHOTGUN",
  "WEAPON_SAWNOFFSHOTGUN",
  "WEAPON_ASSAULTSHOTGUN",
  "WEAPON_BULLPUPSHOTGUN",
  "WEAPON_STUNGUN",
  "WEAPON_SNIPERRIFLE",
  "WEAPON_HEAVYSNIPER",
  "WEAPON_REMOTESNIPER",
  "WEAPON_GRENADELAUNCHER",
  "WEAPON_GRENADELAUNCHER_SMOKE",
  "WEAPON_RPG",
  "WEAPON_PASSENGER_ROCKET",
  "WEAPON_AIRSTRIKE_ROCKET",
  "WEAPON_STINGER",
  "WEAPON_MINIGUN",
  "WEAPON_GRENADE",
  "WEAPON_STICKYBOMB",
  "WEAPON_SMOKEGRENADE",
  "WEAPON_BZGAS",
  "WEAPON_MOLOTOV",
  "WEAPON_FIREEXTINGUISHER",
  "WEAPON_PETROLCAN",
  "WEAPON_DIGISCANNER",
  "WEAPON_BRIEFCASE",
  "WEAPON_BRIEFCASE_02",
  "WEAPON_BALL",
  "WEAPON_FLARE",
  "WEAPON_VEHICLE_ROCKET",
  "WEAPON_DROWNING",
  "WEAPON_DROWNING_IN_VEHICLE",
  "WEAPON_BLEEDING",
  "WEAPON_ELECTRIC_FENCE",
  "WEAPON_EXPLOSION",
  "WEAPON_FALL",
  "WEAPON_HIT_BY_WATER_CANNON",
  "WEAPON_RAMMED_BY_CAR",
  "WEAPON_RUN_OVER_BY_CAR",
  "WEAPON_HELI_CRASH",
  "WEAPON_FIRE",
  "GADGET_NIGHTVISION",
  "GADGET_PARACHUTE",
  "WEAPON_HEAVYSHOTGUN",
  "WEAPON_MARKSMANRIFLE",
  "WEAPON_HOMINGLAUNCHER",
  "WEAPON_PROXMINE",
  "WEAPON_SNOWBALL",
  "WEAPON_FLAREGUN",
  "WEAPON_GARBAGEBAG",
  "WEAPON_HANDCUFFS",
  "WEAPON_COMBATPDW",
  "WEAPON_MARKSMANPISTOL",
  "WEAPON_HATCHET",
  "WEAPON_RAILGUN",
  "WEAPON_MACHETE",
  "WEAPON_MACHINEPISTOL",
  "WEAPON_AIR_DEFENCE_GUN",
  "WEAPON_SWITCHBLADE",
  "WEAPON_REVOLVER"
}

function getWeapons()
  local player = GetPlayerPed(-1)

  local ammo_types = {}

  local weapons = {}
  for k,v in pairs(weapon_types) do
    local hash = GetHashKey(v)
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[v] = weapon

      local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
      if ammo_types[atype] == nil then
        ammo_types[atype] = true
        weapon.ammo = GetAmmoInPedWeapon(player,hash)
      else
        weapon.ammo = 0
      end
    end
  end

  return weapons
end


-----------------------------------------------------------
-----------------------------------------------------------
function SetGears()
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local playerPed  = GetPlayerPed(-1)
	local model      = nil
	local playerWeapons = getWeapons()
	local weapon 	 = nil

	for k,v in pairs(playerWeapons) do

		for j=1, #Config.RealWeapons, 1 do
			if Config.RealWeapons[j].name == k then

				bone     = Config.RealWeapons[j].bone
				boneX    = Config.RealWeapons[j].x
				boneY    = Config.RealWeapons[j].y
				boneZ    = Config.RealWeapons[j].z
				boneXRot = Config.RealWeapons[j].xRot
				boneYRot = Config.RealWeapons[j].yRot
				boneZRot = Config.RealWeapons[j].zRot
				model    = Config.RealWeapons[j].model
				weapon   = Config.RealWeapons[j].name

				break

			end
		end

		local _wait = true

		SpawnObject(model, {
			x = x,
			y = y,
			z = z
		}, function(obj)

			local playerPed = GetPlayerPed(-1)
			local boneIndex = GetPedBoneIndex(playerPed, bone)
			local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)

			AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)

			table.insert(Weapons,{weapon = weapon, obj = obj})

			_wait = false

		end)

		while _wait do
			Wait(0)
		end
    end

end

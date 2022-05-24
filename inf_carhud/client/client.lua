local sleep
local limitador, cinturon, choque = false, false, false
local oldHealth = 0

local MaxSpeed = Config.VehicleMaxSpeed / 3.6

-- Mapeo de Teclas para cambiarlas en la configuración
RegisterKeyMapping('limitador', 'Limitador de Velocidad', 'keyboard', Config.limitador)
RegisterKeyMapping('cinturon', 'Cinturón de Seguridad', 'keyboard', Config.cinturon)

RegisterCommand('limitador', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped)

        local vehicle_type = GetVehicleClass(vehicle)
        if vehicle_type >= 13 and vehicle_type <= 16 then return end -- No hay limitador para esos vehiculos

        if GetPedInVehicleSeat(vehicle, -1) == ped then
            if not limitador then
                local speed = GetEntitySpeed(vehicle)
                SetVehicleMaxSpeed(vehicle,  speed)
                limitador = true
            else
                SetVehicleMaxSpeed(vehicle, maxSpeed)
                limitador = false
            end
        end
    end
end)

RegisterCommand('cinturon', function ()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped)
        local vehicle_type = GetVehicleClass(vehicle)
        if vehicle_type == 8 or (vehicle_type >= 13 and vehicle_type <= 16) then return end -- No hay cinturon para esos vehiculos

        if cinturon then
            cinturon = false
            SendNUIMessage({
                action = 'sound';
                sound = 'seat_off';
            })
        else
            cinturon = true
            SendNUIMessage({
                action = 'sound';
                sound = 'seat_on';
            })
        end
    end
end)
--



CreateThread(function ()
    while true do
        sleep = 1000
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            local speed = (GetEntitySpeed(vehicle)* 3.6)
            local fuel = GetVehicleFuelLevel(vehicle)
            local gear = GetVehicleCurrentGear(vehicle)
            local damage = GetVehicleEngineHealth(vehicle)
            sleep = 100

            --
            if cinturon then DisableControlAction(0, 75, true) end
            --

            SetVehicleMaxSpeed(vehicle, MaxSpeed)

            -- Pantalla en negro en choque
            if damage ~= oldHealth then
                if not isBlackedOut and (damage < oldHealth) and ((oldHealth - damage) >= Config.damageParaNegro) then
                    if cinturon then
                        choqueNegro()
                    else
                        local co = GetEntityCoords(ped)
                        local fw = Fwv(ped)
                        local velBuffer = GetEntitySpeedVector(vehicle, false)
                        SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                        SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                    end
                end
                oldHealth = damage
            end
            --

            local vehicle_type = GetVehicleClass(vehicle)

            if vehicle_type >= 13 and vehicle_type <= 16 then
                SendNUIMessage({
                    action = 'speedometer';
                    speed = speed;
                    fuel = -1;
                    damage = damage;
                    gear = 1;
                    cinturon = -1;
                })
            elseif vehicle_type == 8 then
                SendNUIMessage({
                    action = 'speedometer';
                    speed = speed;
                    fuel = fuel;
                    damage = damage;
                    gear = gear;
                    limitador = limitador;
                    cinturon = -1;
                })
            else
                SendNUIMessage({
                    action = 'speedometer';
                    speed = speed;
                    fuel = fuel;
                    damage = damage;
                    gear = gear;
                    limitador = limitador;
                    cinturon = cinturon;
                })
            end
        else
            limitador = false
            cinturon = false
            sleep = 1000
            SendNUIMessage({
                action = 'hideSpeedo';
            })
        end
        Citizen.Wait(sleep)
    end
end)

Fwv = function (entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

function choqueNegro()
    if not choque then
        choque = true
        Citizen.CreateThread(function()
            DoScreenFadeOut(100)
            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
            Citizen.Wait(Config.tiempoEnNegro)
            DoScreenFadeIn(250)
            choque = false
        end)
    end
end
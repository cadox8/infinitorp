local currentlyTowedVehicle = nil

AddEventHandler('flatbed:pillar', function()
    local playerped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerped, true)

    local towmodel = GetHashKey('flatbed')
    local isVehicleTow = IsVehicleModel(vehicle, towmodel)

    if isVehicleTow then
        local coordA = GetEntityCoords(playerped, 1)
        local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 10.0, 0.0)
        local targetVehicle = getVehicleInDirection(coordA, coordB)

        if currentlyTowedVehicle == nil then
            if targetVehicle ~= 0 then
                if not IsPedInAnyVehicle(playerped, true) then
                    if vehicle ~= targetVehicle then
                        AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                        currentlyTowedVehicle = targetVehicle
                    end
                end
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { 'No hay vehículos cercanos' }
                })
            end
        else
            AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, -.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            DetachEntity(currentlyTowedVehicle, true, true)
            currentlyTowedVehicle = nil
        end
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end
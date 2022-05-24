ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('radares:multa')
AddEventHandler('radares:multa', function(source, velocity, min, plate)
    local mensaje = 'Excedido en límite de velocidad ('..velocity..' km/h)'
    local multa = Config.multa + ((velocity - min) * Config.multiplicador)

    if not plate then return end

    MySQL.Async.fetchAll("SELECT owner FROM owned_vehicles LEFT JOIN users ON owned_vehicles.owner = users.identifier WHERE owned_vehicles.plate = @plate", {
        ['@plate'] = plate
    }, function (result)
        if result then
            if not result or not result[1] then return end
            MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
                    {
                        ['@identifier']  = result[1].owner,
                        ['@sender']      = '',
                        ['@target_type'] = 'society',
                        ['@target']      = 'society_police',
                        ['@label']       = mensaje,
                        ['@amount']      = multa
                    }, function(rowsChanged)
                        local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)
                        if xPlayer then
                            xPlayer.showNotification('~r~Has recibido una multa')
                        end
                    end)
        end
    end)
end)

RegisterServerEvent('radares:aviso')
AddEventHandler('radares:aviso', function(source, model, street, primary, velocity)
    exports.inf_entornos:vel(source, model, street, primary, velocity)
end)
ESX = nil

local data = {}
local insideZone = -1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('chat:addSuggestion', '/zona', 'Crea un entorno de zona /zona [distancia] [mensaje]', {})
TriggerEvent('chat:addSuggestion', '/banda', 'Crea un entorno de zona de bandas /banda [distancia] [mensaje]', {})
TriggerEvent('chat:addSuggestion', '/borarzona', 'Borra el entorno de zona /borrarzona [id]', {})
TriggerEvent('chat:addSuggestion', '/reloadzona', 'Recarga los entornos de zona para ti', {})

RegisterCommand("zona", function(source, args, rawCommand)
  if args[1] == nil or args[2] == nil then
    TriggerEvent('chat:addMessage', {
      color = { 255, 66, 66 },
      multiline = true,
      args = { 'Entorno Zonas > ', ' Uso: /zona [distancia] [mensaje]' }
    })
  else
    local playerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('zona:createZone', args[1], 0, concat(args), playerCoords)
  end
end, false)

RegisterCommand("banda", function(source, args, rawCommand)
  if args[1] == nil or args[2] == nil then
    TriggerEvent('chat:addMessage', {
      color = { 255, 66, 66 },
      multiline = true,
      args = { 'Entorno Zonas > ', ' Uso: /banda [distancia] [mensaje]' }
    })
  else
    local playerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('zona:createZone', args[1], 1, concat(args), playerCoords)
  end
end, true)

RegisterCommand("borrarzona", function(source, args, rawCommand)
  TriggerServerEvent('zona:deteleZone', args[1])
end, true)

RegisterCommand("reloadzona", function(source, args, rawCommand)
  TriggerServerEvent('zona:loadData')
end, false)

--
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if data ~= nil then
      for i,v in ipairs(data) do
        local zone = data[i]
        local pos = GetEntityCoords(PlayerPedId())
        if pos ~= nil then
          local distance = #(pos - zone.coords)
          if insideZone == -1 then
            if distance <= (tonumber(zone.distance) or 20) then
              TriggerEvent('chat:addMessage', {
                color = { 5, 255, 255 },
                multiline = true,
                args = { 'Entorno de Zona [' .. zone.id ..']: ' .. zone.msg }
              })
              insideZone = zone.id
            end
          else
            if insideZone == zone.id and (distance > (tonumber(zone.distance) or 20)) then
              insideZone = -1
            end
          end
        end
      end
    end
    Citizen.Wait(1500)
  end
end)
--

AddEventHandler('playerSpawned', function(spawn)
  Citizen.Wait(7000)
  print('Loading Zone Data')
  TriggerServerEvent('zona:loadData')
end)

RegisterNetEvent('zona:sendData')
AddEventHandler('zona:sendData', function(locations)
  data = {}
  for i,v in ipairs(data) do
    print(data[i].id)
  end
  for i,v in ipairs(locations) do
    table.insert(data, {
      id = locations[i].id,
      distance = locations[i].distance,
      coords = vector3(locations[i].x, locations[i].y, locations[i].z),
      msg = locations[i].msg
    })
  end
  for i,v in ipairs(data) do
    print(data[i].id)
  end
end)

RegisterNetEvent('zona:addData')
AddEventHandler('zona:addData', function(insertId, distance, msg, coords)
  table.insert(data, {
    id = insertId,
    distance = distance,
    coords = coords,
    msg = msg
  })
end)

-- Utils
function concat(args)
  local i = 2
  local s = ''
  while args[i] do
    s = s .. ' ' .. args[i]
    i = i + 1
  end
  return s
end

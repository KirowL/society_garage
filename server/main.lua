local teleportedPlayers = {}
local PlayersInInstance = {}
local spawnedVehicles = {}

for i = 1, #Config.JobsGarages do 
    PlayersInInstance[i] = {}
    spawnedVehicles[i] = {}
end



function isJobValid(playerId, jobName)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    return xPlayer.job.name == jobName or xPlayer.job2.name == jobName
end


RegisterNetEvent('Aldalys:EnteringGarage')
AddEventHandler('Aldalys:EnteringGarage', function(garageId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local garageData = Config.JobsGarages[garageId]
    
    if isJobValid(src, garageData.job) then
        local infos = {
            playersCountInInstance = #PlayersInInstance[garageId], -- players in instance before player enter
            vehicles = GetVehiclesInSocietyGarage(garageId),
            spawnedVehicles = spawnedVehicles[garageId]
        }
        TriggerClientEvent('Aldalys:onGarageEnter', src, garageId, infos)
        SetPlayerRoutingBucket(src, garageData.bucketId)  
        teleportedPlayers[src] = {
            bucketId = garageData.bucketId,
            garageId = garageId
        }  
        table.insert(PlayersInInstance[garageId], src)
        local data = {
            playersCountInInstance = #PlayersInInstance[garageId], -- players in instance before player enter
            vehicles = GetVehiclesInSocietyGarage(garageId),
            spawnedVehicles = spawnedVehicles[garageId]
        }
        for k, playerId in pairs(PlayersInInstance[garageId]) do 
            TriggerClientEvent('Aldalys:UpdateGarageData', playerId, data)
        end 
    else 
        DropPlayer(src, "Mon reuf tu fais quoi là ?")
    end 
end)

function GetVehiclesInSocietyGarage(garageId)
    local vehicles = {}
    local result = MySQL.Sync.fetchAll("SELECT * FROM society_vehicles WHERE garageId = @garageId", {["@garageId"] = garageId})
    if result ~= nil and #result > 0 then
        for k, v in pairs(result) do
            if v.placeId ~= -1 and v.is_stored then
                table.insert(vehicles, v)
            end
        end
    end
    return vehicles
end

AddEventHandler('playerDropped', function(reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if teleportedPlayers[src] then
        MySQL.Sync.execute('UPDATE users SET last_society_garage = @data WHERE identifier = @identifier', {
            ['@data'] = json.encode(teleportedPlayers[src]),
            ['@identifier'] = xPlayer.identifier
        })
    end
end)

RegisterNetEvent('Aldalys:onConnectSocietyGarage')
AddEventHandler('Aldalys:onConnectSocietyGarage', function()
    local src = source
    local data = MySQL.Sync.fetchScalar("SELECT last_society_garage FROM users WHERE identifier = @identifier", {['@identifier'] = GetPlayerLicense(src)})
    if data ~= nil then 
        SetPlayerRoutingBucket(src, data.bucketId)
        TriggerClientEvent('Aldalys:onGarageEnter', src, data.garageId)
        teleportedPlayers[src] = {
            bucketId = data.bucketId,
            garageId = data.garageId
        }  
        table.insert(PlayersInInstance[garageId], src)
    end
end)

function GetPlayerLicense(playerId) 
    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return string.sub(v, 9)
        end
    end
end

RegisterNetEvent('Aldalys:ExitingGarage')
AddEventHandler('Aldalys:ExitingGarage', function(garageId)
    local src = source
    local garageData = Config.JobsGarages[garageId]
    
    TriggerClientEvent('Aldalys:onGarageExit', src, garageId)
    SetPlayerRoutingBucket(src, 0)  
    teleportedPlayers[src] = nil
    table.remove(PlayersInInstance[garageId], GetTableIndex(PlayersInInstance[garageId], src))
    MySQL.Sync.execute('UPDATE users SET last_society_garage = NULL WHERE identifier = @identifier', {['@identifier'] = GetPlayerLicense(src)})
end)   

function GetTableIndex(paramTable, value)
    for i = 1, #table do 
        if paramTable[i] == value then return i end
    end
end

ESX.RegisterServerCallback('Aldalys:IsSocietyPlateTaken', function(source, cb, plate)
    local result = MySQL.Sync.fetchAll("SELECT plate FROM society_vehicles")
    if result ~= nil then 
        for k, v in pairs(result) do 
            if v == plate then cb(true) return end
        end 
    end
    cb(false)
end)


function IsValueInTable(paramTable, value)
    for k, v in pairs(paramTable) do 
        if v.placeId == value then 
            return true 
        end 
    end
    return false
end


function GetFirstFreePlace(garageId)
    local result = MySQL.Sync.fetchAll("SELECT placeId FROM society_vehicles WHERE garageId = @garageId", {["@garageId"] = garageId})
    if #result == 0 then 
        return 1
    else 
        for i = 1, #result do 
            if result[i].placeId == -1 or not IsValueInTable(result, i) then 
                return i
            end 
        end
        return #result + 1
    end 
end

RegisterCommand('t', function(source,args,rawCommand) 
    print(GetFirstFreePlace(1))
end, false)


ESX.RegisterServerCallback('Aldalys:BuySocietyVehicle', function(source, cb, job, vehId)
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_" .. job, function(account)
        local price = Config.JobsVehicles[job][vehId].price
        if account.money >= price then 
            account.removeMoney(price)
            cb(true)
        else  
            cb(false)
        end
    end)
end)



RegisterNetEvent('Aldalys:AddVehicleToSocietyGarage')
AddEventHandler('Aldalys:AddVehicleToSocietyGarage', function(garageId, vehicle)
    MySQL.Sync.execute("INSERT INTO society_vehicles (garageId, placeId, is_stored, job, plate, vehicle) VALUES (@garageId, @placeId, @stored, @job, @plate, @vehicle)", {
        ["@garageId"] = garageId,
        ["@placeId"] = -1,
        ["@stored"] = false,
        ["@job"] = Config.JobsGarages[garageId].job,
        ["@plate"] = vehicle.plate,
        ["@vehicle"] = json.encode(vehicle)
    })
end)

RegisterNetEvent('debug:printcoords')
AddEventHandler('debug:printcoords', function(char)
    print(char)
end)

RegisterNetEvent('Aldalys:EnteringGarageWithVehicle')
AddEventHandler('Aldalys:EnteringGarageWithVehicle', function(garageId, vehicle)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local garageData = Config.JobsGarages[garageId]
    
    if isJobValid(src, garageData.job) then
        local placeId = GetFirstFreePlace(garageId)
        MySQL.Sync.execute("UPDATE society_vehicles SET placeId = @placeId, is_stored = @stored, vehicle = @vehicle WHERE plate = @plate", {
            ["@placeId"] = placeId,
            ["@stored"] = true,
            ["@plate"] = vehicle.plate,
            ["@vehicle"] = json.encode(vehicle)
        })
        local infos = {
            playersCountInInstance = #PlayersInInstance[garageId],
            vehicles = GetVehiclesInSocietyGarage(garageId),
            spawnedVehicles = spawnedVehicles[garageId]
        }
        TriggerClientEvent('Aldalys:onGarageEnter', src, garageId, infos)
        TriggerClientEvent('Aldalys:SpawnNewSocietyVehicle', src, garageId, placeId, vehicle)
        SetPlayerRoutingBucket(src, garageData.bucketId)  
        teleportedPlayers[src] = {
            bucketId = garageData.bucketId,
            garageId = garageId
        }  
        table.insert(PlayersInInstance[garageId], src)
    else 
        DropPlayer(src, "Mon reuf tu fais quoi là ?")
    end 
end)

function IsVehicleInTable(garageId, vehicle)
    for k, v in pairs(spawnedVehicles[garageId]) do 
        if v == vehicle then 
            return true 
        end 
    end 
    return false
end

RegisterNetEvent('Aldalys:SendSpawnedVehicles')
AddEventHandler('Aldalys:SendSpawnedVehicles', function(garageId, vehicles)
    for k, v in pairs(vehicles) do 
        if not IsVehicleInTable(garageId, v) then 
            table.insert(spawnedVehicles[garageId], v)
        end
    end
    print(json.encode(spawnedVehicles[garageId]))
end)
isInInstance = false
usedTeleporter = nil

currentGarageData = {}

ESX = nil

Citizen.CreateThread(function()
	TriggerServerEvent('Aldalys:onConnectSocietyGarage')
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)








RegisterNetEvent('Aldalys:onGarageEnter')
AddEventHandler('Aldalys:onGarageEnter', function(comingFrom, data)
	currentGarageData = data
    ShowLoadingMessage("Entrée dans le garage...", 2, 500)
    local playerPed = GetPlayerPed(-1)
    SetEntityCoords(playerPed, Config.GarageInteriorCoords)
    SetEntityHeading(playerPed, Config.GarageInteriorHeading)
    isInInstance = true
    usedTeleporter = comingFrom

	if data.playersCountInInstance == 0 then
		SpawnSocietyVehicles(comingFrom, data.vehicles)
	end
end)



function SpawnSocietyVehicles(garageId, vehicles)
	local spawnedVehicles = {}
	for k, v in pairs(vehicles) do
		local coords = Config.vehiclesLocations[v.placeId]
		local heading = coords.heading
		coords = vector3(coords.x, coords.y, coords.z - 0.6)
		ESX.Game.SpawnVehicle(v.vehicle.model, coords, heading, function(vehicle)
			ESX.Game.SetVehicleProperties(vehicle, v.vehicle)
			FreezeEntityPosition(vehicle, true)
			SetVehicleDoorsLocked(vehicle, 2)
		end)
		table.insert(spawnedVehicles, v.vehicle.plate)
	end
	TriggerServerEvent('Aldalys:SendSpawnedVehicles', garageId, spawnedVehicles)
end

RegisterNetEvent('Aldalys:SpawnNewSocietyVehicle')
AddEventHandler('Aldalys:SpawnNewSocietyVehicle', function(garageId, placeId, vehicle)
	local spawnedVehicles = {}
	local coords = Config.vehiclesLocations[v.placeId]
	local heading = coords.heading
	coords = vector3(coords.x, coords.y, coords.z - 0.6)
	ESX.Game.SpawnVehicle(vehicle.model, coords, heading, function(vehicleCb)
		ESX.Game.SetVehicleProperties(vehicleCb, vehicle)
		FreezeEntityPosition(vehicleCb, true)
		SetVehicleDoorsLocked(vehicleCb, 2)
	end)
	table.insert(spawnedVehicles, vehicle.plate)
	TriggerServerEvent('Aldalys:SendSpawnedVehicles', garageId, spawnedVehicles)
end)

RegisterNetEvent('Aldalys:onGarageExit')
AddEventHandler('Aldalys:onGarageExit', function(comingFrom)
    ShowLoadingMessage("Sortie du garage...", 2, 500)
    local playerPed = GetPlayerPed(-1)
    SetEntityCoords(playerPed, Config.JobsGarages[comingFrom].enteringCoords)
    isInInstance = false
    usedTeleporter = nil
	
	if currentGarageData.playersCountInInstance == 0 then 
		local vehicles = ESX.Game.GetVehiclesInArea(PlayerPedId(), 100)
		print(json.encode(vehicles))
	end

	currentGarageData = {}
end)


local NumberCharset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

function GetRandomNumber(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GenerateSocietyVehiclePlate(job)
    local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(Config.GenericJobPlate[job] .. GetRandomNumber(4))

		ESX.TriggerServerCallback('Aldalys:IsSocietyPlateTaken', function(isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end



RegisterCommand('c', function(source, args, rawCommand)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local x, y, z = table.unpack(GetEntityCoords(veh))
    local heading = GetEntityHeading(veh)
    
    TriggerServerEvent('debug:printcoords', "{x = " .. x .. ", y = " .. y .. ", z =" .. z .. ", heading = " .. heading .. "}")
end)


function GetJobGarageId(job)
    for k, v in pairs(Config.JobsGarages) do 
        if v.job == job then return k end 
    end
    return -1
end













RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    societyBuyVehicleBlip = RefreshBlip()
	if ESX.PlayerData.job.grade_name ~= "boss" then RemoveBlip(societyBuyVehicleBlip) end 
end)

RegisterNetEvent('Aldalys:UpdateGarageData')
AddEventHandler('Aldalys:UpdateGarageData', function(data)
	currentGarageData = data
end)
function ShowLoadingMessage(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function canEnterVehicle(vehProps, garageId) 
	local plate = vehProps.plate 
	local job = Config.JobsGarages[garageId].job
	if string.find(plate, Config.GenericJobPlate[job]) then 
		return true
	else 
		for k, v in pairs(Config.GenericJobPlate) do 
			if string.find(plate, v) then return false end
		end
	end
	return true
end
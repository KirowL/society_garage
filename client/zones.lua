Citizen.CreateThread(function()
    while ESX == nil or ESX.PlayerData.job == nil do  -- fix error nil value for ESX.PlayerData
        Citizen.Wait(10)
    end
    societyBuyVehicleBlip = RefreshBlip()
    while true do
        attente = 500
        for k,v in pairs(Config.JobsGarages) do
            local pPed = PlayerPedId()
            local pCoords = GetEntityCoords(pPed, true)
            local dst = GetDistanceBetweenCoords(pCoords, v.enteringCoords, true)
            local x, y, z = table.unpack(v.enteringCoords)
            if dst <= 7.5  and ESX.PlayerData.job.name == v.job then 
                attente = 1
                dst = GetDistanceBetweenCoords(pCoords, v.enteringCoords, true)
                DrawMarker(6, x, y, z - 0.99, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, v.MarkerColor[1], v.MarkerColor[2], v.MarkerColor[3], 100, false, true, 2, false, nil, nil, false)
                if dst <= 3 then
                    ESX.ShowHelpNotification('Appuyez sur ~INPUT_PICKUP~ pour ~g~entrer dans le garage~s~.', false, true)
                    if IsControlJustReleased(0, 38) then
                        local vehProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(pPed, false))
                        if IsPedInAnyVehicle(pPed, true) and canEnterVehicle(vehProps, k) then 
                            TriggerServerEvent('Aldalys:EnteringGarageWithVehicle', k, vehProps)
                            local vehicle = GetVehiclePedIsIn(pPed, false)
                            ESX.Game.DeleteVehicle(vehicle)
                        else 
                            TriggerServerEvent('Aldalys:EnteringGarage', k)
                        end
                    end  
                end
            end
        end

        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed, true)
        local dst = GetDistanceBetweenCoords(pCoords, Config.GarageInteriorCoords, true)
        local x, y, z = table.unpack(Config.GarageInteriorCoords)
        if dst <= 7.5 then 
            attente = 1
            dst = GetDistanceBetweenCoords(pCoords, Config.GarageInteriorCoords, true)
            DrawMarker(6, x, y, z - 0.99, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
            if dst <= 3 then
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_PICKUP~ pour ~g~sortir du garage~s~.', false, true)
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('Aldalys:ExitingGarage', usedTeleporter)
                end  
            end
        end

        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed, true)
        local dst = GetDistanceBetweenCoords(pCoords, Config.BuyVehicleCoords, true)
        local x, y, z = table.unpack(Config.BuyVehicleCoords)
        if dst <= 7.5 and ESX.PlayerData.job.grade_name == "boss" then 
            attente = 1
            dst = GetDistanceBetweenCoords(pCoords, Config.BuyVehicleCoords, true)
            DrawMarker(6, x, y, z - 0.99, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
            if dst <= 3 then
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_PICKUP~ pour ~g~accéder au garage d\'entreprise~s~.', false, true)
                if IsControlJustReleased(0, 38) then
                    OpenBuyVehicleMenu(ESX.PlayerData.job.name)
                end  
            end
        end
        Citizen.Wait(attente)
    end
end)

function RefreshBlip(blip)
    if ESX.PlayerData.job.grade_name == "boss" then 
        blip = AddBlipForCoord(Config.BuyVehicleCoords)
        SetBlipSprite(blip, 524)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Concession d'entreprise")
        EndTextCommandSetBlipName(blip)
        return blip
    end
end
    

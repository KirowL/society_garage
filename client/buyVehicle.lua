local isMenuOpened = false

function OpenBuyVehicleMenu(job)
    local buyVehicleMenu = RageUI.CreateMenu("Concession d'entreprise", "Selectionnez u vehicule")
    buyVehicleMenu:SetStyleSize(75)
    buyVehicleMenu:DisplayGlare(false)

    if isMenuOpened then
        isMenuOpened = false
        RageUI.Visible(buyVehicleMenu, false)
    else
        isMenuOpened = true

        buyVehicleMenu.Closed = function()
            isMenuOpened = false
            RageUI.Visible(buyVehicleMenu, false)
        end 

        RageUI.Visible(buyVehicleMenu, true)
        Citizen.CreateThread(function()
            while isMenuOpened do 
                Wait(1)
                RageUI.IsVisible(buyVehicleMenu, function()
                    for k, v in pairs(Config.JobsVehicles[job]) do 
                        RageUI.Button(v.label, "Acheter x~b~1 ~g~" .. v.label .. " ~s~pour ~g~" .. ESX.Math.GroupDigits(v.price) .. "~s~$.", {RightBadge = RageUI.BadgeStyle.Car}, not serverInteraction, {
                            onSelected = function()
                                local vehPlate = GenerateSocietyVehiclePlate(job)
                                ESX.TriggerServerCallback('Aldalys:BuySocietyVehicle', function(bool)
                                    if bool then 
                                        ESX.Game.SpawnVehicle(v.name, Config.SpawnVehicleCoords.coords, Config.SpawnVehicleCoords.heading, function(vehicle)
                                            garageId = GetJobGarageId(job)
                                            SetVehicleNumberPlateText(vehicle, vehPlate)
                                            TriggerServerEvent('Aldalys:AddVehicleToSocietyGarage', garageId, ESX.Game.GetVehicleProperties(vehicle))
                                        end)
                                    end 
                                end, job, k)
                            end
                        })
                    end
                end)
            end
        end)
    end
end

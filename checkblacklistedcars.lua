local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterCommand('checkblacklistedcars', function()
    CheckBlacklistedVehicles()
end, false)

function CheckBlacklistedVehicles()
    local blacklistedVehicles = Config.BlacklistedVehicles
    local vehicles = ESX.Game.GetVehicles()

    if #vehicles > 0 then
        ESX.ShowNotification(Config.NotificationText, true, false, Config.NotificationDuration)

        for _, vehicle in ipairs(vehicles) do
            local modelName = GetEntityModel(vehicle)
            local vehicleName = GetDisplayNameFromVehicleModel(modelName)

            for _, blacklistedVehicle in ipairs(blacklistedVehicles) do
                if string.lower(vehicleName) == string.lower(blacklistedVehicle) then
                    
                    TriggerEvent('esx_blacklist:visualEffect', vehicle)

                    -- Add logic to delete the blacklisted vehicle
                    DeleteEntity(vehicle)

                    -- Show notification with customizable duration
                    ESX.ShowNotification("Blacklisted vehicle found and deleted: " .. blacklistedVehicle, true, false, Config.NotificationDuration)
                    return
                end
            end
        end

        ESX.ShowNotification("No blacklisted vehicles found.", true, false, Config.NotificationDuration)
    else
        ESX.ShowNotification("No vehicles nearby.", true, false, Config.NotificationDuration)
    end
end

RegisterNetEvent('esx_blacklist:visualEffect')
AddEventHandler('esx_blacklist:visualEffect', function(vehicle)
    
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
        Wait(500)
    end
    UseParticleFxAssetNextCall("core")
    local ptfx = StartParticleFxLoopedOnEntity("ent_amb_dust_blowing", vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
    Wait(5000)  -- Adjust the duration of the visual effect as needed
    StopParticleFxLooped(ptfx, 1)
end)

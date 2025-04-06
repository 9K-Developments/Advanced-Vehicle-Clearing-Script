-- Import ox_lib
local lib = exports.ox_lib

-- Logging function that sends logs to server and prints locally
local function Log(level, message)
    if not Config.Logs.enabled then return end
    if not Config.Logs.levels[level] then return end
    
    -- Send log to server
    TriggerServerEvent('9k_clearcar:serverLog', level, message)
    
    -- Also print locally
    print(Config.Logs.prefix .. ' ' .. message)
end

-- Safely show notification
local function SafeNotification(data)
    -- Handle old versions of ox_lib by using TriggerEvent instead of direct call
    TriggerEvent('ox_lib:notify', data)
end

-- Register clear vehicles event
RegisterNetEvent('9k_clearcar:clearAllVehicles')
AddEventHandler('9k_clearcar:clearAllVehicles', function()
    Log('info', 'Received clear vehicles event')
    ClearAllVehicles()
end)

-- Function to clear all vehicles
function ClearAllVehicles()
    -- Simple timer for preparation
    Wait(500)
    Log('info', 'Starting vehicle deletion process')

    -- Get all nearby vehicles
    local vehicles = GetGamePool('CVehicle')
    local count = 0
    local skippedCount = 0
    local currentPlayerId = PlayerId()
    local currentPed = PlayerPedId()
    
    Log('vehicle', 'Found ' .. #vehicles .. ' vehicles to process')
    Log('vehicle', 'skipOccupiedVehicles setting: ' .. tostring(Config.Deletion.skipOccupiedVehicles))
    
    -- Process and delete vehicles
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local shouldDelete = true
        
        -- Check occupied vehicles based on config
        if Config.Deletion.skipOccupiedVehicles then
            -- Skip vehicles with players inside
            local shouldSkip = false
            
            for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                if not IsVehicleSeatFree(vehicle, seat) then
                    Log('vehicle', 'Skipping occupied vehicle (seat ' .. seat .. ' is occupied)')
                    shouldSkip = true
                    break
                end
            end
            
            if shouldSkip then
                skippedCount = skippedCount + 1
                shouldDelete = false
            end
        end
        
        -- Delete vehicle if conditions are met
        if shouldDelete and DoesEntityExist(vehicle) then
            -- Set as mission entity and delete
            SetEntityAsMissionEntity(vehicle, true, true)
            
            -- Attempt to delete with two methods
            local deleted = false
            
            -- Try DeleteVehicle first
            if DeleteVehicle(vehicle) then
                deleted = true
            end
            
            -- If that failed, try DeleteEntity
            if not deleted and DeleteEntity(vehicle) then
                deleted = true
            end
            
            -- Count successful deletions
            if deleted then
                count = count + 1
                Log('vehicle', 'Successfully deleted vehicle ' .. i)
            else
                Log('vehicle', 'Failed to delete vehicle ' .. i)
            end
        end
        
        -- Brief pause between deletions
        Wait(Config.Deletion.waitBetweenVehicles)
    end
    
    -- Check for remaining vehicles
    Wait(Config.Deletion.waitBetweenRetries)
    Log('vehicle', 'First pass complete, cleared ' .. count .. ' vehicles, skipped ' .. skippedCount .. ' vehicles')
    
    -- Multiple retry attempts for remaining vehicles
    for retry = 1, Config.Deletion.maxRetries do
        vehicles = GetGamePool('CVehicle')
        
        -- Skip occupied vehicles based on config
        local remainingVehicles = {}
        
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            local shouldDelete = true
            
            -- Check occupied vehicles based on config
            if Config.Deletion.skipOccupiedVehicles then
                for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                    if not IsVehicleSeatFree(vehicle, seat) then
                        shouldDelete = false
                        break
                    end
                end
            end
            
            if shouldDelete then
                table.insert(remainingVehicles, vehicle)
            end
        end
        
        if #remainingVehicles == 0 then 
            Log('vehicle', 'No more vehicles to delete')
            break 
        end
        
        Log('vehicle', 'Retry ' .. retry .. ': Found ' .. #remainingVehicles .. ' remaining vehicles to delete')
        local retryCount = 0
        
        for i = 1, #remainingVehicles do
            local vehicle = remainingVehicles[i]
            
            -- Delete vehicle
            if DoesEntityExist(vehicle) then
                SetEntityAsMissionEntity(vehicle, true, true)
                
                -- Attempt to delete with two methods
                local deleted = false
                
                -- Try DeleteVehicle first
                if DeleteVehicle(vehicle) then
                    deleted = true
                end
                
                -- If that failed, try DeleteEntity
                if not deleted and DeleteEntity(vehicle) then
                    deleted = true
                end
                
                -- Count successful deletions
                if deleted then
                    count = count + 1
                    retryCount = retryCount + 1
                end
            end
            
            Wait(Config.Deletion.waitBetweenVehicles)
        end
        
        Log('vehicle', 'Retry ' .. retry .. ' complete, cleared ' .. retryCount .. ' additional vehicles')
        Wait(Config.Deletion.waitBetweenRetries)
    end
    
    -- Safely send notification
    local message = string.format(Config.Notifications.Complete.description, count)
    SafeNotification({
        title = Config.Notifications.Complete.title,
        description = message,
        type = Config.Notifications.Complete.type,
        position = Config.Notifications.Complete.position,
        duration = Config.Notifications.Complete.duration,
        icon = Config.Notifications.Complete.icon,
        iconColor = Config.Notifications.Complete.iconColor
    })
    
    if skippedCount > 0 then
        Log('info', 'Vehicle clearing complete - Removed ' .. count .. ' vehicles, skipped ' .. skippedCount .. ' vehicles')
    else
        Log('info', 'Vehicle clearing complete - Removed ' .. count .. ' vehicles')
    end
end

-- Import ox_lib
local lib = exports.ox_lib

-- ANSI color codes
local colors = {
    green = "^2",
    reset = "^7"
}

-- Logging function with colored prefix
local function Log(level, message)
    if not Config.Logs.enabled then return end
    if not Config.Logs.levels[level] then return end
    
    print(colors.green .. Config.Logs.prefix .. colors.reset .. ' ' .. message)
end

-- Register event to receive logs from clients
RegisterNetEvent('9k_clearcar:serverLog')
AddEventHandler('9k_clearcar:serverLog', function(level, message)
    if not Config.Logs.enabled then return end
    if not Config.Logs.levels[level] then return end
    
    local playerId = source
    local playerName = GetPlayerName(playerId) or "Unknown"
    
    -- Print colored log with player info
    print(colors.green .. Config.Logs.prefix .. colors.reset .. ' [' .. playerName .. '/' .. playerId .. '] ' .. message)
end)

-- Framework initialization
local Framework = nil

-- ESX initialization using exports instead of events
if Config.Framework == 'esx' then
    CreateThread(function()
        while not Framework do
            pcall(function()
                Framework = exports['es_extended']:getSharedObject()
            end)
            if not Framework then
                Wait(500)
            end
        end
    end)
    Log('info', 'ESX framework initialized')
elseif Config.Framework == 'qbcore' then
    Framework = exports['qb-core']:GetCoreObject()
    Log('info', 'QBCore framework initialized')
end

-- Check if player is admin
local function IsAdmin(source)
    if Config.Framework == 'esx' then
        -- ESX permission check (with nil check)
        if not Framework then return false end
        local xPlayer = Framework.GetPlayerFromId(source)
        if not xPlayer then return false end
        
        local playerGroup = xPlayer.getGroup()
        return Config.AdminGroups[playerGroup] or false
    elseif Config.Framework == 'qbcore' then
        -- QBCore permission check (with nil check)
        if not Framework then return false end
        local Player = Framework.Functions.GetPlayer(source)
        if not Player then return false end
        
        local playerGroup = Player.PlayerData.permission
        return Config.AdminGroups[playerGroup] or false
    end
    
    return false
end

-- Register command using RegisterCommand
RegisterCommand(Config.CommandName, function(source, args, raw)
    local playerName = GetPlayerName(source)
    
    Log('command', 'Command triggered by ' .. playerName)
    
    if not IsAdmin(source) then
        -- Notify player about insufficient permissions
        TriggerClientEvent('ox_lib:notify', source, {
            title = Config.Notifications.NoPermission.title,
            description = Config.Notifications.NoPermission.description,
            type = Config.Notifications.NoPermission.type,
            position = Config.Notifications.NoPermission.position,
            duration = Config.Notifications.NoPermission.duration,
            icon = Config.Notifications.NoPermission.icon,
            iconColor = Config.Notifications.NoPermission.iconColor
        })
        Log('admin', 'Permission denied for ' .. playerName)
        return
    end
    
    Log('admin', 'Permission granted for ' .. playerName)
    
    -- Send clear vehicles event to all clients
    TriggerClientEvent('9k_clearcar:clearAllVehicles', -1)
    Log('vehicle', 'Sent vehicle clear event to all clients')
    
    -- Send success notification to admin
    TriggerClientEvent('ox_lib:notify', source, {
        title = Config.Notifications.Success.title, 
        description = Config.Notifications.Success.description,
        type = Config.Notifications.Success.type,
        position = Config.Notifications.Success.position,
        duration = Config.Notifications.Success.duration,
        icon = Config.Notifications.Success.icon,
        iconColor = Config.Notifications.Success.iconColor
    })
    
    -- Broadcast notification to all players using ox_lib
    TriggerClientEvent('ox_lib:notify', -1, {
        title = Config.Notifications.Broadcast.title,
        description = Config.Notifications.Broadcast.description,
        type = Config.Notifications.Broadcast.type,
        position = Config.Notifications.Broadcast.position,
        duration = Config.Notifications.Broadcast.duration,
        icon = Config.Notifications.Broadcast.icon,
        iconColor = Config.Notifications.Broadcast.iconColor
    })
    Log('info', 'Broadcast notification sent to all players')
    
    -- Log to server console with more details
    if Config.Framework == 'esx' and Framework then
        local xPlayer = Framework.GetPlayerFromId(source)
        if xPlayer then
            playerName = xPlayer.getName()
            Log('admin', 'ESX player ' .. playerName .. ' (Group: ' .. xPlayer.getGroup() .. ') cleared all vehicles')
        end
    elseif Config.Framework == 'qbcore' and Framework then
        local Player = Framework.Functions.GetPlayer(source)
        if Player then
            playerName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
            Log('admin', 'QBCore player ' .. playerName .. ' (Permission: ' .. Player.PlayerData.permission .. ') cleared all vehicles')
        end
    end
    
    Log('vehicle', 'Vehicle clearing operation completed by ' .. playerName)
end, false)

-- Print initialization message
Log('info', 'Resource started - Command registered: /' .. Config.CommandName) 
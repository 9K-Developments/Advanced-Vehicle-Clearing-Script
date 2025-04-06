Config = {}

-- Framework configuration
Config.Framework = 'esx' -- 'esx' or 'qbcore'

-- Admin groups that can use the clear command
Config.AdminGroups = {
    ['admin'] = true,
    ['superadmin'] = true,
    ['mod'] = true,
    ['god'] = true
}

-- Command configuration
Config.CommandName = 'clearcar' -- Command name to clear vehicles

-- Logging configuration
Config.Logs = {
    enabled = false, -- Enable or disable all logging
    prefix = '[9K-Developments]', -- Prefix for all log messages
    -- Log levels (set to false to disable specific types of logs)
    levels = {
        info = true,     -- Basic information logs
        command = true,  -- Command execution logs
        vehicle = true,  -- Vehicle deletion logs
        admin = true,    -- Admin action logs
        error = true     -- Error logs
    }
}

-- Notification settings
Config.Notifications = {
    Success = {
        title = 'Operation Successful',
        description = 'All vehicles on the map have been cleared',
        type = 'success',
        position = 'top',
        duration = 5000,
        icon = 'check',
        iconColor = '#2ecc71'
    },
    NoPermission = {
        title = 'Insufficient Permissions',
        description = 'You do not have permission to execute this command',
        type = 'error',
        position = 'top',
        duration = 5000,
        icon = 'ban',
        iconColor = '#e74c3c'
    },
    Complete = {
        title = 'Clearing Complete',
        description = 'Cleared %s vehicles', -- %s will be replaced with the number of vehicles cleared
        type = 'success',
        position = 'top',
        duration = 5000,
        icon = 'car',
        iconColor = '#3498db'
    },
    Broadcast = {
        title = 'Vehicle Cleanup',
        description = 'An administrator has cleared all vehicles on the map',
        type = 'info',
        position = 'top-right',
        duration = 7000,
        icon = 'car',
        iconColor = '#e74c3c'
    }
}

-- Animation and effects
Config.ProgressBar = {
    duration = 3000,
    label = 'Clearing vehicles...',
    anim = {
        dict = 'missheist_agency2aig_13',
        clip = 'pickup_briefcase'
    }
}

-- Particle effect for vehicle deletion
Config.ParticleEffect = {
    asset = "core",
    name = "ent_sht_electrical_box"
}

-- Sound effect
Config.SoundEffect = {
    name = "Object_Dropped_Remote",
    set = "GTAO_FM_Events_Soundset"
}

-- Vehicle deletion settings
Config.Deletion = {
    waitBetweenVehicles = 50, -- ms to wait between each vehicle deletion
    waitBetweenRetries = 500, -- ms to wait before checking for remaining vehicles
    maxRetries = 3, -- maximum number of retries to delete vehicles
    skipOccupiedVehicles = false -- If true, won't delete vehicles that players are driving
} 
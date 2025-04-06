# 9k_clearcar

An advanced FiveM vehicle clearing plugin that allows administrators to clear all vehicles on the server with a simple command.

## Features

- Administrators can use the `/clearcar` command to clear all vehicles on the map
- Supports both ESX and QBCore frameworks
- Beautiful notifications using ox_lib
- Fully configurable through config.lua
- Customizable logging system
- Option to preserve or delete occupied vehicles
- Detailed code comments for easy understanding and modification

## Dependencies

- [es_extended](https://github.com/esx-framework/esx-legacy) OR [qb-core](https://github.com/qbcore-framework/qb-core) - Choose your framework
- [ox_lib](https://github.com/overextended/ox_lib) - Overextended Lib

## Installation

1. Download this resource and place it in your server's resource directory
2. Make sure you have installed and are running either `es_extended` or `qb-core` along with `ox_lib`
3. Configure your framework preference in `config.lua`
4. Add the following to your server configuration file `server.cfg`:

```
ensure ox_lib
ensure es_extended # or ensure qb-core
ensure 9k_clearcar
```

## Usage

Only users with permission levels configured in `config.lua` can execute the clear vehicle command.

### Admin Commands

- `/clearcar` - Clear all vehicles on the map (configurable command name)

## Configuration

All settings can be customized in the `config.lua` file:

### Framework and Permissions

```lua
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
```

### Logging Configuration

```lua
-- Logging configuration
Config.Logs = {
    enabled = true, -- Enable or disable all logging
    prefix = '[9k_clearcar]', -- Prefix for all log messages
    -- Log levels (set to false to disable specific types of logs)
    levels = {
        info = true,     -- Basic information logs
        command = true,  -- Command execution logs
        vehicle = true,  -- Vehicle deletion logs
        admin = true,    -- Admin action logs
        error = true     -- Error logs
    }
}
```

### Vehicle Deletion Settings

```lua
-- Vehicle deletion settings
Config.Deletion = {
    waitBetweenVehicles = 50, -- ms to wait between each vehicle deletion
    waitBetweenRetries = 500, -- ms to wait before checking for remaining vehicles
    maxRetries = 3, -- maximum number of retries to delete vehicles
    skipOccupiedVehicles = true -- If true, won't delete vehicles that players are driving
}
```

When `skipOccupiedVehicles` is set to `true`, the plugin will preserve all vehicles that have any player inside them. If set to `false`, it will delete all vehicles on the map including those that players are driving, **including the vehicle of the player who executed the command**.

### Notification Settings

The plugin provides fully customizable notifications, including titles, descriptions, icons, colors, and durations.

## Permissions

This plugin uses ESX's or QBCore's permission system. Only players with admin groups defined in `Config.AdminGroups` can use the clear vehicle command.

## Customization

To modify the permission logic, edit the `IsAdmin` function in `server/main.lua` or update the groups in `config.lua`.

## License

MIT License - See the LICENSE file for more information.

## Author

- 9K

## Contribution

Issues and pull requests are welcome! 

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name '9k_clearcar'
author '9k'
description 'Advanced Vehicle Clearing Script with ESX/QBCore Support'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

dependencies {
    'ox_lib'
}
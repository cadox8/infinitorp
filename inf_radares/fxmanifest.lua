fx_version 'adamant'

game 'gta5'

name 'Radares'
author 'cadox8'
version '1.1.0'

ui_page 'html/index.html'

files {
    'html/index.html'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
}

dependencies {
    'es_extended',
    'inf_entornos'
}

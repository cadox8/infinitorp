fx_version 'adamant'

game 'gta5'

name 'Entornos'
author 'cadox8'
version '2.3.0'

ui_page 'html/ui.html'

files {
    'html/style.css',
    'html/app.js',
    'html/ui.html',
}

server_scripts {
    'server/server.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
}

dependencies {
    'es_extended'
}

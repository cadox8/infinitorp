fx_version 'cerulean'
game 'gta5'

name 'Drogas'
version '1.1.0'
author 'cadox8'

files {
  'index.html'
}

ui_page('index.html')

server_scripts {
  'server/server.lua',
  'config.lua'
}

client_scripts {
  'client/client.lua',
  'config.lua'
}

dependencies {
  'inf_entornos'
}

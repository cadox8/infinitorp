fx_version 'cerulean'
game 'gta5'

name 'Entornos Zona'
author 'cadox8'
version '1.0.0'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/server.lua'
}

client_scripts {
    'client/client.lua'
}

dependencies {
	'es_extended'
}

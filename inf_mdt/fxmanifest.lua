fx_version 'bodacious'
game 'gta5'

shared_script 'config.lua'

client_scripts {
	'client/client.lua',
	'client/utils.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'serveR/server.lua'
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*'
}
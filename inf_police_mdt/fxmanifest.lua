fx_version 'cerulean'
game 'gta5'

files {
    "config.json",
    "build/frontend/**/*"
}

ui_page "build/frontend/index.html"

server_scripts {
    'build/backend/index.js'
}

client_scripts {
    'build/client/index.js'
}
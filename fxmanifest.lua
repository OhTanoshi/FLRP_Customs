fx_version 'adamant'
games { 'gta5' }

dependencies {
    "externalsql"
}

server_scripts {
	'server/server.lua',
}

client_scripts {
	'client/menu.lua',
	'config.lua',
	'client/client.lua',
	'utils/managers.lua',
}
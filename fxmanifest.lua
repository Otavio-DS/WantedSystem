fx_version "adamant"
game "gta5"

author 'Elite Store'
description 'System wanted, for vRP FIVEM \n pt-BR \n Sistema de procurado para vRP FIVEM '
version 'v3.1.5'

lua54 'yes'

escrow_ignore {
    "fuga.lua",
    "procurado.lua",
    "exports.lua"
}

ui_page "fuga/nui/index.html"

files {
	"fuga/nui/*"
}

client_scripts {
	"@vrp/lib/utils.lua",
	"fuga/client.lua",
	"procurado/client.lua",
	"fuga.lua",
	"procurado.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"exports.lua",
	"fuga/server.lua",
	"procurado/server.lua",
	"fuga.lua",
	"procurado.lua"
}

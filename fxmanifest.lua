fx_version 'cerulean'

game 'gta5'

author 'Kirow'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    "config.lua",
    'client/**/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "config.lua",
    'server/**/*.lua'
}

shared_script '@es_extended/imports.lua'
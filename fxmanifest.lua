--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-CLOTHINGRADIAL — the clothing wheel for LXRCore v3
     A fork of Murphy Workshop's murphy_radialmenu 1.1.0 (GPL-3.0, see LICENSE):
     the same wheel, one menu, wired to lxr-clothing. Everything else on the
     wheel is lxr-radial's job.
     © 2026 Murphy Workshop (original) · LXRCore fork — GPL-3.0
     ═══════════════════════════════════════════════════════════════════════════ ]]

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'lxr-clothingradial'
author 'Murphy Workshop · LXRCore fork'
description 'The action wheel (F1) and the clothing wheel (J): clothing on / off and wearable states from lxr-clothing, horse, satchel, duty, papers, HUD.'
version '3.0.1'
lxr_core_api '3'

lua54 'yes'

shared_scripts {
    'shared/config.lua',
    'shared/labels.lua',
}

client_scripts {
    -- integrations append their menus to Config.Menus, so they load BEFORE client/client.lua (which clones the catalogue at boot)
    'integrations/_shared.lua',
    'integrations/lxr_clothing.lua',
    'integrations/lxr_actions.lua',
    'client/client.lua',
}

server_script 'server/main.lua'

ui_page 'ui/build/index.html'

files {
    'ui/build/index.html',
    'ui/build/config.js',
    'ui/build/failsafe.js',
    'ui/build/assets/**/*',
    'ui/build/images/**/*',
    'ui/build/locales/**/*',
}

-- No hard dependency and no framework: the wheel runs on any core or none. Its clothing ring reads lxr-clothing
-- (ToggleCategory / CycleState / Wearing) when that resource is present; the other entries show only when their
-- resource runs (lxr-horses, lxr-inventory, lxr-emotes, lxr-hud) or their core does (duty, papers on LXRCore).

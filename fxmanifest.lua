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
description 'The clothing wheel: take off / put on, sleeves, collar, tuck, raise, over / under, undress, dress — built from what you wear (lxr-clothing).'
version '1.0.0'
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
    'client/client.lua',
}

ui_page 'ui/build/index.html'

files {
    'ui/build/index.html',
    'ui/build/config.js',
    'ui/build/failsafe.js',
    'ui/build/assets/**/*',
    'ui/build/images/**/*',
    'ui/build/locales/**/*',
}

dependency 'lxr-clothing'

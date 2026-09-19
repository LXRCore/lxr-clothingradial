--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-CLOTHINGRADIAL — Config
     The clothing wheel for LXRCore v3: a fork of Murphy Workshop's
     murphy_radialmenu (GPL-3 — see LICENSE) trimmed to one wheel, wired to
     lxr-clothing. The regular action wheel is lxr-radial (F1); this one is the
     clothing ring only: J, /clothes, or the "Clothing" entry on lxr-radial.
     ═══════════════════════════════════════════════════════════════════════════ ]]

Config = {}

-- 'en' | 'ka' — the wheel's chrome (Back / Close) and the slot labels (shared/labels.lua)
Config.Locale = 'en'

-- The key that shows the wheel while held. A-Z, 0-9, F1-F12, TAB, SPACE, LSHIFT, LCTRL...
-- (lxr-radial holds F1; keep them apart)
Config.OpenKey = 'J'

-- Keys that open a specific wheel directly. Only `clothing` exists here.
Config.DirectMenuKeys = {}

Config.Integrations = {
    lxr_clothing = true,     -- the clothing wheel from lxr-clothing's Wearing() / ToggleCategory / CycleState
}

-- Every context resolves to the clothing wheel — on foot, in the saddle, on a wagon
Config.Contexts = {
    { menuId = 'clothing', when = function(_) return true end },
}

-- The catalogue is filled by integrations/lxr_clothing.lua at load time
Config.Menus = {}

-- Undress / dress everything: which categories those two buttons touch, in this order
Config.AllCategories = { 'hats', 'masks', 'eyewear', 'cloaks', 'ponchos', 'capes', 'coats', 'coats_closed', 'coats_heavy',
                         'shirts_full', 'vests', 'suspenders', 'neckwear', 'neckerchiefs', 'neckties', 'gloves', 'gauntlets',
                         'pants', 'skirts', 'chaps', 'spats', 'boots', 'boot_accessories', 'gunbelts', 'gunbelt_accs', 'satchels', 'accessories', 'badges', 'aprons' }

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

-- true: this is the whole action wheel (F1: clothing, horse, satchel, duty, papers, HUD — the entries lxr-radial
-- carries) and lxr-radial can stay off. false: the clothing ring only (J) and lxr-radial is the action wheel.
Config.FullWheel = true

-- The key that shows the context wheel while held (RegisterKeyMapping default; players rebind it in the game's settings)
Config.OpenKey = 'F1'

-- Keys that open a specific wheel directly: the clothing ring on J
Config.DirectMenuKeys = { clothing = 'J' }

Config.Integrations = {
    lxr_clothing = true,     -- the clothing wheel from lxr-clothing's Wearing() / ToggleCategory / CycleState
}

-- Contexts: with Config.FullWheel integrations/lxr_actions.lua sets player / horse / vehicle;
-- without it every context is the clothing wheel
Config.Contexts = {
    { menuId = 'clothing', when = function(_) return true end },
}

-- The catalogue is filled by integrations/lxr_clothing.lua at load time
Config.Menus = {}

-- Undress / dress everything: which categories those two buttons touch, in this order
Config.AllCategories = { 'hats', 'masks', 'eyewear', 'cloaks', 'ponchos', 'capes', 'coats', 'coats_closed', 'coats_heavy',
                         'shirts_full', 'vests', 'suspenders', 'neckwear', 'neckerchiefs', 'neckties', 'gloves', 'gauntlets',
                         'pants', 'skirts', 'chaps', 'spats', 'boots', 'boot_accessories', 'gunbelts', 'gunbelt_accs', 'satchels', 'accessories', 'badges', 'aprons' }

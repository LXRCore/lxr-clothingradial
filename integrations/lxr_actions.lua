--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-CLOTHINGRADIAL — integration: the action wheel (player / horse / wagon)
     With Config.FullWheel the fork is the whole wheel, not the clothing ring
     alone: F1 opens the context wheel — clothing (sub-wheel), horse, satchel,
     duty, papers, HUD — the entries lxr-radial carries, on Murphy's wheel.
     Disable: Config.FullWheel = false (then lxr-radial is the action wheel and
     this resource is the clothing ring only).
     ═══════════════════════════════════════════════════════════════════════════ ]]

if not Config.FullWheel then return end

local function started(res) return function() return GetResourceState(res) == 'started' end end
local function onFoot() return not IsPedOnMount(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) end

-- the clothing sub-wheel is the clothing menu's builder (integrations/lxr_clothing.lua)
local clothing = {
    id = 'clothing', icon = 'kit_wardrobe', label = L('title'),
    visibleWhen = started('lxr-clothing'),
    childrenBuilder = function() local m = Config.Menus.clothing return m and m.slotsBuilder and m.slotsBuilder() or {} end,
}
local horse = {
    id = 'horse', icon = 'toast_horse_bond', label = L('horse'),
    visibleWhen = function() return GetResourceState('lxr-horses') == 'started' and onFoot() end,
    children = {
        { id = 'horse_call',  icon = 'toast_horse_bond', label = L('horse_call'),  action = { type = 'export', value = { 'lxr-horses', 'CallHorse' } } },
        { id = 'horse_store', icon = 'kit_horse_brush',  label = L('horse_store'), action = { type = 'command', value = 'horse store' } },
    },
}
local satchel = { id = 'satchel', icon = 'kit_pouch_kit',         label = L('satchel'), visibleWhen = started('lxr-inventory'), action = { type = 'command', value = 'inventory' } }
local trade   = { id = 'trade',   icon = 'kit_pouch_valuables',       label = L('trade'),   visibleWhen = started('lxr-inventory'), action = { type = 'command', value = 'trade' } }
local emotes  = { id = 'emotes',  icon = 'emote_dance_formal_a',  label = L('emotes'),  visibleWhen = started('lxr-emotes'), action = { type = 'command', value = 'emotes' } }
local duty    = { id = 'duty',    icon = 'provision_deputy_star', label = L('duty'),    visibleWhen = started('lxr-core'), action = { type = 'serverEvent', value = 'lxr:player:duty' } }
local papers  = { id = 'papers',  icon = 'document_player_journal', label = L('papers'), visibleWhen = started('lxr-core'), action = { type = 'serverEvent', value = 'lxr:item:use', args = { 'id_card' } } }
local hud     = { id = 'hud',     icon = 'settings',              label = L('hud'),     visibleWhen = started('lxr-hud'), action = { type = 'command', value = 'hud' } }

Config.Menus.player  = { title = L('player'), slots = { clothing, horse, satchel, trade, emotes, duty, papers, hud } }
Config.Menus.horse   = { title = L('horse'),  slots = { clothing, satchel, duty, papers, hud } }
Config.Menus.vehicle = { title = L('wagon'),  slots = { satchel, duty, papers, hud } }

-- the context wheel: saddle → horse, wagon → vehicle, otherwise player; a menu with nothing visible falls through
Config.Contexts = {
    { menuId = 'horse',   when = function(ped) return IsPedOnMount(ped) end },
    { menuId = 'vehicle', when = function(ped) return IsPedInAnyVehicle(ped, false) end },
    { menuId = 'player',  when = function(_)   return true end },
}

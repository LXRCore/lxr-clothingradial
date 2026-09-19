--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-CLOTHINGRADIAL — integration: lxr-clothing
     The clothing wheel, built when it opens from what the character wears:
       · one slot per worn category — take off / put on (lxr-clothing ToggleCategory)
       · the shirt, vest, neckwear, boots, gunbelt and hair get a sub-wheel with
         their wearable state (sleeves / collar, tucked, raised, over / under,
         side, pomade — lxr-clothing CycleState)
       · Undress / Dress everything
     Disable: Config.Integrations.lxr_clothing = false.
     ═══════════════════════════════════════════════════════════════════════════ ]]

if not RadialIntegrations.enabled('lxr_clothing') then return end

local TARGET = 'lxr-clothing'

-- category → wheel icon (ui/build/assets/icons/<name>.png)
local ICON = {
    hats = 'clothing_generic_hat', headwear = 'clothing_generic_hat', hat_accessories = 'clothing_generic_hat',
    masks = 'clothing_generic_mask', eyewear = 'clothing_generic_outfit',
    shirts_full = 'clothing_generic_shirt', vests = 'clothing_generic_vest',
    coats = 'clothing_generic_coat', coats_closed = 'clothing_generic_coat', coats_heavy = 'clothing_generic_coat',
    cloaks = 'clothing_generic_cloak', ponchos = 'clothing_generic_cloak', capes = 'clothing_generic_cloak',
    gloves = 'clothing_generic_glove', gauntlets = 'clothing_generic_glove',
    pants = 'clothing_generic_pants', skirts = 'clothing_generic_skirt', chaps = 'clothing_generic_chaps', spats = 'clothing_generic_spats',
    boots = 'clothing_generic_boots', boot_accessories = 'clothing_generic_boots',
    gunbelts = 'clothing_generic_gunbelt', gunbelt_accs = 'clothing_generic_gunbelt',
    neckwear = 'clothing_generic_neckerchief', neckerchiefs = 'clothing_generic_neckerchief', neckties = 'clothing_generic_neckerchief',
    accessories = 'clothing_generic_outfit', satchels = 'kit_pouch_kit', suspenders = 'clothing_generic_suspenders',
    badges = 'provision_deputy_star', aprons = 'clothing_generic_dress', hair = 'kit_shaving_kit',
}

-- categories with a wearable state and the label of their state toggle
local STATE = { shirts_full = 'sleeves_collar', vests = 'tuck', neckwear = 'raise', neckerchiefs = 'raise', boots = 'over_under', loadouts = 'gunbelt_side', hair = 'pomade' }

local function wearing()
    local ok, w = pcall(function() return exports[TARGET]:Wearing() end)
    return (ok and type(w) == 'table') and w or {}
end

local function toggleSlot(cat, w)
    return {
        id = 'wear:' .. cat, icon = ICON[cat] or 'clothing_generic_outfit', label = w.hidden and L('put_on') or L('take_off'), stayOpen = true,
        action = { type = 'export', value = { TARGET, 'ToggleCategory' }, args = { cat, not w.hidden } },
    }
end
local function stateSlot(cat)
    return {
        id = 'state:' .. cat, icon = ICON[cat] or 'clothing_generic_outfit', label = L(STATE[cat]), stayOpen = true,
        action = { type = 'export', value = { TARGET, 'CycleState' }, args = { cat } },
    }
end

local function build()
    if GetResourceState(TARGET) ~= 'started' then return {} end
    local w = wearing()
    local out = {}
    -- worn categories, in the catalogue's order
    for _, cat in ipairs(Config.AllCategories) do
        local e = w[cat]
        if e and e.worn then
            if STATE[cat] then
                out[#out + 1] = { id = cat, icon = ICON[cat], label = L(cat), children = { toggleSlot(cat, e), stateSlot(cat) } }
            else
                local s = toggleSlot(cat, e) s.label = L(cat) .. ' · ' .. s.label
                out[#out + 1] = s
            end
        end
    end
    -- states that are not clothes
    local hasState = function(cat) local ok, v = pcall(function() return exports[TARGET]:HasState(cat) end) return ok and v == true end
    if hasState('loadouts') then out[#out + 1] = stateSlot('loadouts') end
    if hasState('hair') then local s = stateSlot('hair') s.label = L('hair') .. ' · ' .. L('pomade') out[#out + 1] = s end
    -- everything off / on
    local anyOn, anyOff = false, false
    for _, cat in ipairs(Config.AllCategories) do local e = w[cat] if e and e.worn then if e.hidden then anyOff = true else anyOn = true end end end
    if anyOn then out[#out + 1] = { id = 'all_off', icon = 'clothing_generic_outfit', label = L('undress'), stayOpen = true, action = { type = 'export', value = { TARGET, 'ToggleAll' }, args = { true } } } end
    if anyOff then out[#out + 1] = { id = 'all_on', icon = 'kit_wardrobe', label = L('dress'), stayOpen = true, action = { type = 'export', value = { TARGET, 'ToggleAll' }, args = { false } } } end
    return out
end

Config.Menus.clothing = { title = L('title'), slotsBuilder = build }

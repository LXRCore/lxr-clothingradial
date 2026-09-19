-- lxr-clothingradial -- client entry (a fork of Murphy Workshop's murphy_radialmenu, GPL-3)
-- Holds wheel state, owns the keybind, sends payloads to the NUI, and routes
-- selections into the actions declared in shared/config.lua.

local RESOURCE = GetCurrentResourceName()

-- ============================================================================
-- STATE
-- ============================================================================

-- Live copy of the catalog: Config.Menus is deep-cloned so runtime mutations
-- (registerMenu / registerSlot / removeSlot) never leak back into Config.
local menus = {}

local currentMenuId = nil    -- menu shown by the NUI, nil when closed

-- Resolved copy of the open menu (childrenBuilder results included) so
-- findSlot can return the live dynamic slots. nil when closed.
local currentResolved = nil

local contextResolver = nil  -- optional override for Config.Contexts

-- ============================================================================
-- HELPERS
-- ============================================================================

local function deepCopy(t)
  if type(t) ~= 'table' then return t end
  local out = {}
  for k, v in pairs(t) do out[k] = deepCopy(v) end
  return out
end

for id, def in pairs(Config.Menus or {}) do menus[id] = deepCopy(def) end

local function logError(fmt, ...)
  print(('[lxr-clothingradial] ' .. fmt):format(...))
end

-- Materialize a slot tree: run visibleWhen / childrenBuilder without mutating
-- the static `menus` table. visibleWhen errors fall open (slot shown) so a
-- broken predicate doesn't silently hide functionality.
local function resolveSlots(slots)
  local out = {}
  for _, s in ipairs(slots or {}) do
    local visible = true
    if type(s.visibleWhen) == 'function' then
      local ok, v = pcall(s.visibleWhen)
      if ok then
        visible = v ~= false
      else
        logError('visibleWhen for slot %s failed: %s', tostring(s.id), tostring(v))
      end
    end
    if visible then
      local copy
      if s.childrenBuilder or s.children then
        copy = {}
        for k, v in pairs(s) do
          if k ~= 'childrenBuilder' and k ~= 'visibleWhen' then copy[k] = v end
        end
        if s.childrenBuilder then
          local ok, built = pcall(s.childrenBuilder)
          copy.children = (ok and type(built) == 'table') and built or {}
          if not ok then logError('childrenBuilder for slot %s failed: %s', tostring(s.id), tostring(built)) end
        end
        if copy.children then copy.children = resolveSlots(copy.children) end
      else
        copy = s
      end
      out[#out + 1] = copy
    end
  end
  return out
end

-- nil when the menu doesn't exist or resolves to zero visible slots.
local function materialize(menuId)
  local menu = menus[menuId]
  if not menu then return nil end
  local baseSlots = menu.slots
  -- A menu can build its whole slot list at open time (`slotsBuilder`), the
  -- menu-level counterpart of a slot's childrenBuilder. Integrations use it
  -- to expose a sub-menu as a directly-openable wheel (`/clothes`).
  if type(menu.slotsBuilder) == 'function' then
    local ok, built = pcall(menu.slotsBuilder)
    if not ok then
      logError('slotsBuilder for menu %s failed: %s', tostring(menuId), tostring(built))
    end
    baseSlots = (ok and type(built) == 'table') and built or (menu.slots or {})
  end
  local slots = resolveSlots(baseSlots)
  if #slots == 0 then return nil end
  return {
    menuId = menuId,
    title  = menu.title,
    logo   = menu.logo,
    slots  = slots,
  }
end

-- Slot matching `slotId` at the end of `path` (array of parent slot ids).
local function findSlot(slotId, path)
  if not currentResolved then return nil end
  local list = currentResolved.slots
  for _, parentId in ipairs(path or {}) do
    local parent
    for _, s in ipairs(list) do if s.id == parentId then parent = s; break end end
    if not parent or not parent.children then return nil end
    list = parent.children
  end
  for _, s in ipairs(list) do
    if s.id == slotId then return s end
  end
  return nil
end

-- NUI payload: rendering fields only -- `action` / `childrenBuilder` are Lua
-- values SendNUIMessage can't serialize.
local function serializeMenu(resolved)
  if not resolved then return nil end
  local function strip(slots)
    local out = {}
    for i, s in ipairs(slots) do
      out[i] = {
        id          = s.id,
        icon        = s.icon,
        label       = s.label,
        description = s.description or nil,
        disabled    = s.disabled or nil,
        stayOpen    = s.stayOpen or nil,
        children    = s.children and strip(s.children) or nil,
      }
    end
    return out
  end
  return {
    menuId = resolved.menuId,
    title  = resolved.title,
    logo   = resolved.logo,
    slots  = strip(resolved.slots or {}),
  }
end

-- ============================================================================
-- DISPATCH
-- ============================================================================

local function runAction(slot, slotId, path)
  local action = slot.action
  local t = action.type
  local v = action.value
  local args = action.args or {}

  if t == 'command' then
    ExecuteCommand(v)

  elseif t == 'event' then
    TriggerEvent(v, table.unpack(args))

  elseif t == 'serverEvent' then
    TriggerServerEvent(v, table.unpack(args))

  elseif t == 'export' then
    local resource, fn = v[1], v[2]
    local ok, err = pcall(function()
      exports[resource][fn](exports[resource], table.unpack(args))
    end)
    if not ok then logError('export %s.%s failed: %s', resource, fn, tostring(err)) end

  elseif t == 'callback' then
    local ok, err = pcall(v, slotId, path)
    if not ok then logError('callback for slot %s failed: %s', slotId, tostring(err)) end

  else
    logError('unknown action type %q for slot %s', tostring(t), tostring(slotId))
  end
end

-- `delay` (ms) defers the action so the click that selected the slot doesn't
-- bleed into a chained NUI (interaction picker, player selector, keyboard).
local function dispatch(slot, slotId, path)
  local action = slot.action
  if not action or not action.type then return end

  local delay = tonumber(slot.delay) or 0
  if delay > 0 then
    CreateThread(function()
      Wait(delay)
      runAction(slot, slotId, path)
    end)
  else
    runAction(slot, slotId, path)
  end
end

-- ============================================================================
-- OPEN / CLOSE / REFRESH
-- ============================================================================

-- Open `menuId`, or (nil) the first matching context whose menu materializes
-- to at least one slot -- empty menus fall through to the next context.
local function open(menuId)
  local resolved = nil

  if menuId then
    resolved = materialize(menuId)
  else
    if contextResolver then
      local ok, id = pcall(contextResolver)
      if ok and id then resolved = materialize(id) end
    end
    if not resolved then
      local ped = PlayerPedId()
      for _, ctx in ipairs(Config.Contexts or {}) do
        local ok, hit = pcall(ctx.when, ped)
        if ok and hit then
          resolved = materialize(ctx.menuId)
          if resolved then break end
        end
      end
    end
  end

  if not resolved then return false end
  currentMenuId = resolved.menuId
  currentResolved = resolved
  SetNuiFocus(true, true)
  -- KeepInput: without it NUI focus swallows the keyboard, so the hold-key
  -- release fires on the next frame and the wheel closes itself instantly.
  SetNuiFocusKeepInput(true)
  SendNUIMessage({ action = 'nui:radial:open', payload = serializeMenu(currentResolved) })
  return true
end

local function close()
  if not currentMenuId then return end
  SendNUIMessage({ action = 'nui:radial:close', payload = {} })
  SetNuiFocusKeepInput(false)
  SetNuiFocus(false, false)
  currentMenuId = nil
  currentResolved = nil
end

-- Re-resolve and push fresh slots into the open wheel; close if now empty.
local function refresh()
  if not currentMenuId then return end
  local resolved = materialize(currentMenuId)
  if not resolved then close() return end
  currentResolved = resolved
  SendNUIMessage({ action = 'nui:radial:update', payload = { slots = serializeMenu(currentResolved).slots } })
end

-- ============================================================================
-- NUI CALLBACKS
-- ============================================================================

RegisterNUICallback('radial:select', function(data, cb)
  local slotId = data and data.slotId
  local path   = (data and data.path) or {}
  local slot   = slotId and findSlot(slotId, path) or nil
  local stayOpen = slot and slot.stayOpen and true or false

  -- Leaf select: the NUI already hid itself, so release focus. stayOpen
  -- slots keep the wheel + focus up so the player can pick again.
  if not stayOpen then
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    currentMenuId = nil
    currentResolved = nil
  end

  if slot and not slot.disabled then
    dispatch(slot, slotId, path)
    -- a stayOpen slot changes what is worn: rebuild the wheel so "Take off" reads "Put on" (same ids, the sub-wheel stays)
    if stayOpen then SetTimeout(150, refresh) end
  end

  cb({ ok = true })
end)

RegisterNUICallback('radial:close', function(_, cb)
  SetNuiFocusKeepInput(false)
  SetNuiFocus(false, false)
  currentMenuId = nil
  currentResolved = nil
  cb({ ok = true })
end)

-- ============================================================================
-- INPUT LOCK -- while the wheel is open
-- ----------------------------------------------------------------------------
-- SetNuiFocusKeepInput leaks the mouse axes to the game, so the camera would
-- rotate with the wheel; keyboard KeepInput is still needed for movement and
-- hold-key detection, so look + combat controls are disabled per frame
-- instead. RDR3 control hashes -- the FiveM numeric IDs no-op on RedM.
-- ============================================================================

local INPUT_LOOK_LR    = 0xA987235F
local INPUT_LOOK_UD    = 0xD2047988
local INPUT_ATTACK     = 0x07CE1E61  -- LMB / melee primary (also F unarmed)
local INPUT_ATTACK2    = 0xCEE12B50  -- secondary attack / mounted melee
local INPUT_AIM        = 0xB2F377E8  -- RMB aim

CreateThread(function()
  while true do
    if currentMenuId then
      DisableControlAction(0, INPUT_LOOK_LR, true)
      DisableControlAction(0, INPUT_LOOK_UD, true)
      DisableControlAction(0, INPUT_ATTACK,  true)
      DisableControlAction(0, INPUT_ATTACK2, true)
      DisableControlAction(0, INPUT_AIM,     true)
      DisablePlayerFiring(PlayerId(), true)
      Wait(0)
    else
      Wait(200)
    end
  end
end)

-- ============================================================================
-- KEYBIND
-- ============================================================================
-- The keys, through RegisterKeyMapping: nothing polls per frame and players rebind them in the game's
-- settings. Hold-to-show: `+` opens, `-` closes (the release reaches us because NUI focus keeps input).
local function keyName(k) return tostring(k or 'F1') end
RegisterCommand('+lxr_wheel', function() if not currentMenuId and not IsPauseMenuActive() then open(nil) end end, false)
RegisterCommand('-lxr_wheel', function() if currentMenuId then close() end end, false)
RegisterKeyMapping('+lxr_wheel', 'Action wheel', 'keyboard', keyName(Config.OpenKey))
for menuId, key in pairs(Config.DirectMenuKeys or {}) do
  RegisterCommand('+lxr_wheel_' .. menuId, function() if not currentMenuId and not IsPauseMenuActive() then open(menuId) end end, false)
  RegisterCommand('-lxr_wheel_' .. menuId, function() if currentMenuId == menuId then close() end end, false)
  RegisterKeyMapping('+lxr_wheel_' .. menuId, 'Wheel: ' .. menuId, 'keyboard', keyName(key))
end

--   /clothes -> the clothing wheel (press again, or Esc, to close)
RegisterCommand('clothes', function()
  if currentMenuId then close(); return end
  open('clothing')
end, false)


-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('open', function(menuId) return open(menuId) end)

exports('openContext', function() return open(nil) end)

exports('close', function() close() end)

exports('isOpen', function() return currentMenuId ~= nil end)

exports('registerMenu', function(menuId, def)
  if type(menuId) ~= 'string' or type(def) ~= 'table' then return false end
  menus[menuId] = def
  if currentMenuId == menuId then refresh() end
  return true
end)

exports('unregisterMenu', function(menuId)
  if not menus[menuId] then return false end
  if currentMenuId == menuId then close() end
  menus[menuId] = nil
  return true
end)

-- `path` (array of parent slot ids) targets a sub-menu. Replaces by id.
exports('registerSlot', function(menuId, slot, path)
  local menu = menus[menuId]
  if not menu or type(slot) ~= 'table' or not slot.id then return false end
  local list = menu.slots
  for _, parentId in ipairs(path or {}) do
    local parent
    for _, s in ipairs(list) do if s.id == parentId then parent = s; break end end
    if not parent then return false end
    parent.children = parent.children or {}
    list = parent.children
  end
  for i, s in ipairs(list) do
    if s.id == slot.id then
      list[i] = slot
      if currentMenuId == menuId then refresh() end
      return true
    end
  end
  list[#list + 1] = slot
  if currentMenuId == menuId then refresh() end
  return true
end)

exports('removeSlot', function(menuId, slotId, path)
  local menu = menus[menuId]
  if not menu then return false end
  local list = menu.slots
  for _, parentId in ipairs(path or {}) do
    local parent
    for _, s in ipairs(list) do if s.id == parentId then parent = s; break end end
    if not parent or not parent.children then return false end
    list = parent.children
  end
  for i, s in ipairs(list) do
    if s.id == slotId then
      table.remove(list, i)
      if currentMenuId == menuId then refresh() end
      return true
    end
  end
  return false
end)

-- fn() must return a menuId, or nil to fall back to Config.Contexts.
-- Pass nil to remove the override.
exports('setContextResolver', function(fn)
  contextResolver = (type(fn) == 'function') and fn or nil
end)

-- Optional `translations` table is deep-merged onto the locale.
exports('setLocale', function(locale, translations)
  if type(locale) ~= 'string' then return false end
  SendNUIMessage({ action = 'nui:locale:set', payload = {
    locale = locale,
    translations = translations,
  }})
  return true
end)

--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-CLOTHINGRADIAL — Server: the start-up card
     © 2026 iBoss21 / LXRCore — GPL-3.0 (see LICENSE)
     ═══════════════════════════════════════════════════════════════════════════ ]]

CreateThread(function()
    Wait(500)
    local rule = '^3  ═══════════════════════════════════════════════════════════════════════^7'
    local function row(label, value) print(('^7   %s %s %s^7'):format(label, string.rep('·', math.max(1, 17 - #label)), value)) end
    print('')
    for _, l in ipairs({
        '██████╗  █████╗ ██████╗ ██╗ █████╗ ██╗',
        '██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗██║',
        '██████╔╝███████║██║  ██║██║███████║██║',
        '██╔══██╗██╔══██║██║  ██║██║██╔══██║██║',
        '██║  ██║██║  ██║██████╔╝██║██║  ██║███████╗',
        '╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═╝╚══════╝',
    }) do print('^8    ' .. l .. '^7') end
    print('')
    print(rule)
    print('^3   🐺 LXR-CLOTHINGRADIAL^7 · ^8The action wheel and the clothing wheel^7 · ^5RedM^7')
    print(rule)
    row('Resource', '^8' .. GetCurrentResourceName())
    row('Version', '^8' .. (GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '?'))
    row('Framework', '^8' .. (GetResourceState('lxr-core') == 'started' and 'LXRCore (lxr-core)') or (GetResourceState('rsg-core') == 'started' and 'RSG Core') or (GetResourceState('vorp_core') == 'started' and 'VORP Core') or 'standalone')
    row('Language', '^8' .. tostring(Config.Locale or 'en'))
    row('Open key', ('^8%s^7 (hold) · clothing ^8%s'):format(tostring(Config.OpenKey), tostring(Config.DirectMenuKeys and Config.DirectMenuKeys.clothing or '-')))
    row('Full wheel', Config.FullWheel and '^2ENABLED^7' or '^3CLOTHING ONLY^7')
    row('Categories', ('^8%d^7 clothing slots'):format(#(Config.AllCategories or {})))
    print(rule)
    row('Website', '^4https://www.lxrcore.com')
    row('Discord', '^4https://discord.gg/GAhk8cgXe9')
    row('Store', '^4https://theluxempire.tebex.io')
    row('Developer', '^8iBoss21 / LXRCore')
    print(rule)
    print('')
end)

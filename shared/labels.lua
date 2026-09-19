--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-CLOTHINGRADIAL — Slot labels, EN + KA (the wheel's chrome is ui/build/locales)
     ═══════════════════════════════════════════════════════════════════════════ ]]

Labels = {
    en = {
        hats = 'Hat', headwear = 'Headwear', hat_accessories = 'Hat accessory', masks = 'Mask', eyewear = 'Eyewear',
        shirts_full = 'Shirt', vests = 'Vest', coats = 'Coat', coats_closed = 'Coat', coats_heavy = 'Heavy coat',
        cloaks = 'Cloak', ponchos = 'Poncho', capes = 'Cape', gloves = 'Gloves', gauntlets = 'Gauntlets',
        pants = 'Pants', skirts = 'Skirt', chaps = 'Chaps', spats = 'Spats', boots = 'Boots', boot_accessories = 'Spurs',
        gunbelts = 'Gunbelt', gunbelt_accs = 'Holster', neckwear = 'Neckwear', neckerchiefs = 'Neckerchief', neckties = 'Necktie',
        accessories = 'Accessories', satchels = 'Satchel', suspenders = 'Suspenders', badges = 'Badge', aprons = 'Apron',
        take_off = 'Take off', put_on = 'Put on', sleeves_collar = 'Sleeves / collar', tuck = 'Tuck in / out',
        raise = 'Raise / lower', over_under = 'Over / under the pants', gunbelt_side = 'Gunbelt side', pomade = 'Pomade',
        undress = 'Undress', dress = 'Dress', hair = 'Hair', title = 'Clothing',
        player = 'Player', horse = 'Horse', wagon = 'Wagon', horse_call = 'Call the horse', horse_store = 'Stable the horse',
        satchel = 'Satchel', trade = 'Trade', emotes = 'Emotes', duty = 'Duty', papers = 'Papers', hud = 'HUD',
    },
    ka = {
        hats = 'ქუდი', headwear = 'თავსაბურავი', hat_accessories = 'ქუდის აქსესუარი', masks = 'ნიღაბი', eyewear = 'სათვალე',
        shirts_full = 'პერანგი', vests = 'ჟილეტი', coats = 'პალტო', coats_closed = 'პალტო', coats_heavy = 'მძიმე პალტო',
        cloaks = 'მოსასხამი', ponchos = 'პონჩო', capes = 'კეიპი', gloves = 'ხელთათმანები', gauntlets = 'სამკლაურები',
        pants = 'შარვალი', skirts = 'ქვედაბოლო', chaps = 'ჩაპსი', spats = 'გეტრები', boots = 'ჩექმები', boot_accessories = 'დეზები',
        gunbelts = 'ქამარი', gunbelt_accs = 'ბუდე', neckwear = 'ყელსახვევი', neckerchiefs = 'ყელსახოცი', neckties = 'ჰალსტუხი',
        accessories = 'აქსესუარები', satchels = 'ჩანთა', suspenders = 'აჭიმები', badges = 'სამკერდე ნიშანი', aprons = 'წინსაფარი',
        take_off = 'გახდა', put_on = 'ჩაცმა', sleeves_collar = 'სახელოები / საყელო', tuck = 'შიგნით / გარეთ',
        raise = 'აწევა / დაშვება', over_under = 'შარვალზე / შარვალქვეშ', gunbelt_side = 'ქამრის მხარე', pomade = 'პომადა',
        undress = 'გახდა სრულად', dress = 'ჩაცმა სრულად', hair = 'თმა', title = 'ტანსაცმელი',
        player = 'მოთამაშე', horse = 'ცხენი', wagon = 'ეტლი', horse_call = 'ცხენის გამოძახება', horse_store = 'ცხენის საჯინიბოში',
        satchel = 'ჩანთა', trade = 'გაცვლა', emotes = 'ემოციები', duty = 'მორიგეობა', papers = 'საბუთები', hud = 'HUD',
    },
}

function L(key) local t = Labels[Config.Locale] or Labels.en return t[key] or Labels.en[key] or key end

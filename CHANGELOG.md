# Changelog

## 3.0.0 — 2026-09-19
* LXRCore v3 release line: every resource ships as 3.0.0 from here (the entries below are the road to it).
* The wheel keys go through RegisterKeyMapping (the three raw-key polls per frame are gone; F1 / J rebindable in the game settings).

## 1.1.0 — 2026-09-19
* `Config.FullWheel` (default true): the fork is the whole action wheel — F1 opens the context wheel (player / horse / wagon) with clothing as a sub-wheel, horse call / stable, satchel, duty, papers, HUD; J still opens clothing directly. With it lxr-radial stays off (both hold F1). `false` = the clothing ring only, lxr-radial the action wheel.

## 1.0.0 — 2026-09-19
* First release: murphy_radialmenu 1.1.0 (Murphy Workshop, GPL-3.0) forked to one wheel — the clothing ring for lxr-clothing. Worn pieces on / off, wearable states (sleeves / collar, tuck, raise, over / under, holster side, pomade) in sub-wheels, Undress / Dress. J, `/clothes`, or lxr-radial's *Clothing*. EN + KA labels and chrome, the wolf in the centre; the ragdoll bind and the murphy_* integrations removed.

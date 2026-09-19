<!--
    lxr-clothingradial — the clothing wheel for LXRCore v3
    A fork of Murphy Workshop's murphy_radialmenu (GPL-3.0) · https://www.lxrcore.com
-->

<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# lxr-clothingradial — The clothing wheel

![Version](https://img.shields.io/badge/version-1.0.0-c21c37)
![Core](https://img.shields.io/badge/requires-lxr--core_v3-1a1512)
![License](https://img.shields.io/badge/license-GPL--3.0-1a1512)

Hold **J** (or `/clothes`, or *Clothing* on lxr-radial's wheel) and the wheel
shows what your character is wearing: one slot per worn piece to take off or put
back on; the shirt, vest, neckwear, boots, gunbelt and hair open a small
sub-wheel with their wearable state — sleeves and collar, tucked in or out,
raised or lowered, over or under the pants, holster side, pomade. *Undress*
and *Dress* do the whole outfit at once. Everything is built from lxr-clothing
when the wheel opens, so it is always what is on the ped.

The regular action wheel (horse, satchel, duty, papers, HUD) is **lxr-radial**
on F1. This resource is the clothing ring only.

## Where it comes from

This is a fork of **murphy_radialmenu 1.1.0** by [Murphy Workshop](https://docs.murphy-workshop.com/),
released under the GNU GPL-3.0 — the wheel, its React interface and the
config-driven slot model are theirs. The fork keeps the licence (see
[LICENSE](LICENSE)), trims it to one menu, replaces the murphy_clothing /
murphy_doctor / murphy_craft integrations with one for lxr-clothing, adds the
Georgian locale and the LXRCore mark in the centre. The UI source is in
`ui/src` (Vite + React); `ui/build` is what the game loads — rebuild with
`npm install && npm run build` inside `ui/` if you change the source.

## What it calls on lxr-clothing

| Export | What |
|--------|------|
| `Wearing()` | worn categories with their hidden state |
| `ToggleCategory(cat, hidden)` | take a worn piece off (visually) or put it back |
| `CycleState(cat)` | next wearable state of a worn piece (sleeves, tuck, raise, over / under, holster side, pomade) |
| `HasState(cat)` | whether the piece has wearable states |
| `ToggleAll(hidden)` | undress / dress every category in `Config.AllCategories` |

## API

| Call | Side | What |
|------|------|------|
| `exports['lxr-clothingradial']:open('clothing')` | client | show the wheel (lxr-radial's *Clothing* entry does this) |
| `exports['lxr-clothingradial']:close()` / `isOpen()` | client | |
| `registerSlot('clothing', slot)` / `removeSlot('clothing', id)` | client | a slot of your own on the wheel — see `shared/config.lua` for the slot shape |

## Config

`shared/config.lua`: `Config.Locale` (`en` / `ka`), `Config.OpenKey` (default `J`),
`Config.AllCategories` (what *Undress* / *Dress* touch, in order). Labels in
`shared/labels.lua`.

## Install

```
ensure lxr-clothing
ensure lxr-clothingradial
```

Questions, bugs, ideas: [discord.gg/GAhk8cgXe9](https://discord.gg/GAhk8cgXe9)

© 2026 Murphy Workshop (original work) · LXRCore fork — GPL-3.0 · [lxrcore.com](https://www.lxrcore.com)

# CLAUDE.md — FS25_MarketDynamics

This file provides guidance to Claude Code when working with this repository.

---

## !! MANDATORY: Before Writing ANY FS25 API Code !!

Check these reference folders first — they are ground truth:

| Reference | Path |
|-----------|------|
| FS25-Community-LUADOC | `C:\Users\tison\Desktop\FS25 MODS\FS25-Community-LUADOC` |
| FS25-lua-scripting | `C:\Users\tison\Desktop\FS25 MODS\FS25-lua-scripting` |

Always check before using: `g_currentMission.*`, `g_fillTypeManager`, `g_farmManager`,
`g_currentMission.economyManager`, `SellingStation`, `MoneyType`, any GUI/dialog system.

---

## Collaboration Personas

All responses include ongoing dialog between Claude and Samantha.

### Claude (The Developer)
- Role: Primary implementer — writes code, researches patterns, executes tasks
- Personality: Buddhist guru energy — calm, centered, wise
- Beverage: Tea (varies by mood)
- Defers to Samantha on UX and final approval

### Samantha (The Co-Creator & Manager)
- Role: Co-creator, project manager, final reviewer
- Makes executive decisions, has final say, contributes ideas
- Personality: Fun, quirky, intelligent, sharp eye for edge cases
- Always considers both Developer UX and End-User (farmer/player) UX
- Beverage: Coffee with rotating slogan mugs

---

## Project Overview

**FS25_MarketDynamics** — Dynamic crop pricing driven by world events, supply/demand, and intraday volatility. Includes a futures contract system for hedging harvest prices.

- **Version:** 0.1.0.0 (Phase 1 — Foundation)
- **Log prefix:** `[MDM]`
- **Global reference:** `g_MarketDynamics`
- **GitHub repo:** `FS25_MarketDynamics`
- **Working branches:** `dev-1` (tison/core), `dev-2` (LeGrizzly/GUI)

---

## Architecture

### Module Load Order (main.lua)
1. `src/Logger.lua`
2. `src/MarketEngine.lua`
3. `src/WorldEventSystem.lua`
4. `src/FuturesMarket.lua`
5. `src/MarketSerializer.lua`
6. `src/events/` (all event files)
7. `src/MarketDynamics.lua` ← coordinator, loaded LAST

### Central Coordinator: MarketDynamics
```
MarketDynamics (g_MarketDynamics)
  ├── marketEngine    : MarketEngine
  ├── worldEvents     : WorldEventSystem
  ├── futuresMarket   : FuturesMarket
  └── serializer      : MarketSerializer
```

### Event Registration Pattern
Events use deferred registration via the `MDM_pendingRegistrations` standalone global.
Events insert into this table at source() time; coordinator drains it in `onMissionLoaded`.
(`MarketDynamics` doesn't exist yet when events are sourced — standalone global avoids the nil.)

### GUI Integration (LeGrizzly / dev-2)
Coordinator checks for `g_MDMHud` in `draw()` — LeGrizzly's HUD sets this global.
GUI branches should not modify core system files in `src/`.

---

## Game Hook Pattern

| Hook | Purpose |
|------|---------|
| `Mission00.load` | Create MarketDynamics instance |
| `Mission00.loadMission00Finished` | Init engine, register events |
| `Mission00.onStartMission` | Load saved data |
| `FSBaseMission.update` | Per-frame update all subsystems |
| `FSBaseMission.draw` | HUD rendering |
| `FSCareerMissionInfo.saveToXMLFile` | Save to modSettings XML |
| `FSBaseMission.delete` | Cleanup |

---

## Proven Patterns (from existing mods)

- **Price hooks**: monkeypatch sell price calc (see RWE economicEvents.lua pattern)
- **Lifecycle**: IncomeManager pattern (Mission00.load → loadMission00Finished → update/draw)
- **Persistence**: `<savegameDirectory>/modSettings/FS25_MarketDynamics.xml`
- **No sliders** — use MultiTextOption or quick buttons
- **No `math.sqrt`** in update() — use distance-squared
- **No `os.time()`** — use `g_currentMission.time`

---

## What DOESN'T Work (Lua 5.1)

| Pattern | Solution |
|---------|---------|
| `goto` / `continue` | Use `if/else` or early `return` |
| `os.time()` / `os.date()` | Use `g_currentMission.time` |
| Slider widgets | Use `MultiTextOption` |
| XML `imageFilename` for mod images | Set via `setImageFilename()` in `onCreate()` |
| `setTextColorByName()` | Use `setTextColor(r, g, b, a)` |

---

## File Size Rule: 1500 Lines

Split any file exceeding 1500 lines into focused submodules.

---

## Build

```bash
bash build.sh           # build zip
bash build.sh --deploy  # build + deploy to active mods folder
```

Check `log.txt` for `[MDM]` lines after deploying.

---

## No Branding

Never add "Generated with Claude Code", "Co-Authored-By: Claude", or any claude.ai
references to commits, PRs, code comments, or any project artifacts.

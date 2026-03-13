# Architecture — FS25_MarketDynamics

System design, module map, and lifecycle for the core mod (`dev-1` / tison).

---

## Overview

MarketDynamics is a coordinator-based architecture. One global object (`g_MarketDynamics`)
owns four subsystems and drives their update loops. Subsystems don't know about each other —
all cross-system communication goes through the coordinator.

```
g_MarketDynamics  (MarketDynamics)
  ├── marketEngine    MarketEngine        — price state, modifiers, volatility
  ├── worldEvents     WorldEventSystem    — event registry, scheduling, firing
  ├── futuresMarket   FuturesMarket       — contract lifecycle
  └── serializer      MarketSerializer    — save/load XML
```

---

## Module Load Order

Defined in `main.lua`. Order is strict — each module depends on the ones above it.

| # | File | Provides |
|---|------|----------|
| 1 | `src/Logger.lua` | `MDMLog` — logging wrapper |
| 2 | `src/MarketEngine.lua` | `MarketEngine` class |
| 3 | `src/WorldEventSystem.lua` | `WorldEventSystem` class |
| 4 | `src/FuturesMarket.lua` | `FuturesMarket` class |
| 5 | `src/MarketSerializer.lua` | `MarketSerializer` class |
| 6 | `src/events/*.lua` | Event registrations (deferred) |
| 7 | `src/MarketDynamics.lua` | `MarketDynamics` coordinator — **loaded last** |

Event files run before the coordinator exists. They push registrations into
`MarketDynamics.pendingEventRegistrations` (a static table), which the coordinator
drains during `onMissionLoaded`.

---

## Game Hook Map

| Hook | Where bound | What happens |
|------|-------------|--------------|
| `Mission00.load` | `main.lua` | `MarketDynamics.new()` — creates coordinator + all subsystems |
| `Mission00.loadMission00Finished` | `main.lua` | `onMissionLoaded()` — inits engine, registers events |
| `Mission00.onStartMission` | `main.lua` | `onStartMission()` — loads savegame XML |
| `FSBaseMission.update` | `main.lua` | `update(dt)` — ticks all subsystems |
| `FSBaseMission.draw` | `main.lua` | `draw()` — delegates to `g_MDMHud` if present |
| `FSCareerMissionInfo.saveToXMLFile` | `main.lua` | `save()` — writes modSettings XML |
| `FSBaseMission.delete` | `main.lua` | `delete()` — sets `isActive = false` |

---

## Lifecycle Sequence

```
game starts
  └─ Mission00.load
       └─ MarketDynamics.new()
            ├─ MarketEngine.new()
            ├─ WorldEventSystem.new()
            ├─ FuturesMarket.new()
            └─ MarketSerializer.new()

map loads
  └─ Mission00.loadMission00Finished
       └─ g_MarketDynamics:onMissionLoaded()
            ├─ marketEngine:init()          ← snapshot base prices
            ├─ drain pendingEventRegistrations
            └─ isActive = true

savegame starts
  └─ Mission00.onStartMission
       └─ g_MarketDynamics:onStartMission()
            └─ serializer:load(self)        ← restore contracts + event cooldowns

per-frame
  └─ FSBaseMission.update(dt)
       └─ g_MarketDynamics:update(dt)
            ├─ marketEngine:update(dt)
            ├─ worldEvents:update(dt)
            └─ futuresMarket:checkExpiry()

per-frame
  └─ FSBaseMission.draw()
       └─ g_MarketDynamics:draw()
            └─ g_MDMHud:draw()  (if present)

on save
  └─ FSCareerMissionInfo.saveToXMLFile
       └─ g_MarketDynamics:save()
            └─ serializer:save(self)

on exit
  └─ FSBaseMission.delete
       └─ g_MarketDynamics:delete()
```

---

## MarketEngine — Price Model

Prices are stored per `fillTypeIndex`:

```lua
self.prices[fillTypeIndex] = {
    base      = number,   -- vanilla sell price, snapshotted at init
    current   = number,   -- base × product of all active modifiers
    modifiers = {},       -- list of { id, factor, remaining }
}
```

**Volatility layers (applied in update loop):**

| Layer | Interval | Magnitude | Notes |
|-------|----------|-----------|-------|
| Intraday | 60s game-time | ±2% | Small tick noise |
| Daily | 24h game-time | ±5% | Broader trend with mean-reversion |

**Event modifiers** stack multiplicatively on top of base. When an event expires,
its modifiers are removed and `_recalculate()` updates `current`.

---

## WorldEventSystem — Scheduling

Every `CHECK_INTERVAL_MS` (5 in-game minutes), `_rollForEvents()` iterates the registry.
For each event not currently active:

1. Check `(now - lastFiredAt) >= cooldownMs`
2. Roll `math.random() < event.probability`
3. If both pass → `_fireEvent()` — sets intensity, duration, calls `event.onFire(intensity)`

Only one instance of each event can be active at a time (keyed by event id).

---

## Event Registration Pattern

Event files cannot call `WorldEventSystem:registerEvent()` directly at source time because
`g_MarketDynamics` doesn't exist yet. Instead:

```lua
-- In any events/*.lua file:
MarketDynamics.pendingEventRegistrations = MarketDynamics.pendingEventRegistrations or {}
table.insert(MarketDynamics.pendingEventRegistrations, { ... })
```

The coordinator drains this table in `_registerDefaultEvents()` during `onMissionLoaded`.

---

## GUI Integration Point

The coordinator checks for `g_MDMHud` in `draw()`. LeGrizzly's GUI sets this global.
Core files in `src/` must not be modified by GUI branches.

```lua
-- In MarketDynamics:draw()
if g_MDMHud then
    g_MDMHud:draw()
end
```

---

## Save Format

**Path:** `<savegameDir>/modSettings/FS25_MarketDynamics.xml`

**Schema:**

```xml
<marketDynamics version="1">
  <futures>
    <contract id="" farmId="" fillTypeIndex="" fillTypeName=""
              quantity="" lockedPrice="" deliveryTime=""
              delivered="" status="" />
  </futures>
  <events>
    <event id="" lastFiredAt="" />
  </events>
</marketDynamics>
```

Saved: active + completed futures contracts, per-event `lastFiredAt` (for cooldown persistence).
Not saved: current price state, active event modifiers (these reset on load — by design).

---

## Coding Rules

- **No `goto` / `continue`** — use `if/else` or early `return`
- **No `os.time()`** — use `g_currentMission.time`
- **No `math.sqrt` in `update()`** — use distance-squared
- **No sliders** — use `MultiTextOption` or quick buttons
- **Max 1500 lines per file** — split into submodules if needed
- **Log prefix:** `[MDM]` (via `MDMLog`)

---

## See Also

- [API Reference](api-reference.md) — Public methods per module
- [Event Authoring](event-authoring.md) — Adding new event types
- [Serialization](serialization.md) — Save/load internals
- [Lua Compatibility](lua-compat.md) — Lua 5.1 / FS25 gotchas

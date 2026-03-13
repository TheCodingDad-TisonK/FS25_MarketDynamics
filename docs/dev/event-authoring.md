# Event Authoring — Adding New World Events

How to create, register, and test a new event type for FS25_MarketDynamics.

---

## Event Anatomy

An event is a Lua file in `src/events/` that:

1. Defines `onFire(intensity)` — what happens when the event triggers
2. Defines `onExpire(intensity)` — cleanup when the event ends
3. Pushes a registration table into `MarketDynamics.pendingEventRegistrations`

The coordinator processes all pending registrations during `onMissionLoaded`. This
deferred pattern exists because event files are sourced before `g_MarketDynamics` exists.

---

## Minimal Template

```lua
-- src/events/MyEvent.lua
-- Brief description of what this event represents.
--
-- Author: yourname

local EVENT_ID = "my_event"  -- must be globally unique

local AFFECTED_CROPS = { "wheat", "barley" }  -- lowercase fill type names

local function onFire(intensity)
    if not g_MarketDynamics then return end

    -- intensity is 0–1, interpolate to your desired price range
    local factor = 1.10 + intensity * 0.20  -- e.g. 1.10x to 1.30x

    for _, cropName in ipairs(AFFECTED_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:addModifier({
                id            = EVENT_ID .. "_" .. cropName,
                fillTypeIndex = fillType.index,
                factor        = factor,
                durationMs    = 10 * 60 * 1000,  -- 10 in-game minutes
            })
        end
    end

    MDMLog.info("MyEvent fired — factor " .. string.format("%.2f", factor))
end

local function onExpire(intensity)
    if not g_MarketDynamics then return end

    for _, cropName in ipairs(AFFECTED_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:removeModifierById(
                fillType.index,
                EVENT_ID .. "_" .. cropName
            )
        end
    end
end

-- Deferred registration
MarketDynamics.pendingEventRegistrations = MarketDynamics.pendingEventRegistrations or {}
table.insert(MarketDynamics.pendingEventRegistrations, {
    id           = EVENT_ID,
    name         = "My Event Display Name",
    probability  = 0.07,          -- 7% chance per 5-min check
    minIntensity = 0.2,
    maxIntensity = 1.0,
    cooldownMs   = 30 * 60 * 1000,
    onFire       = onFire,
    onExpire     = onExpire,
})
```

---

## Registration Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | ✓ | Unique event identifier. Used as key in registry + active table. |
| `name` | string | ✓ | Human-readable display name (shown in HUD). |
| `probability` | number | ✓ | Chance of firing per check (every 5 in-game minutes). 0.08 = 8%. |
| `minIntensity` | number | ✓ | Minimum intensity value (0–1). Recommend ≥ 0.2. |
| `maxIntensity` | number | ✓ | Maximum intensity value (0–1). |
| `cooldownMs` | number | ✓ | Minimum gap (game ms) before this event can fire again. |
| `onFire` | function | ✓ | Called with `intensity` (0–1) when event fires. |
| `onExpire` | function | — | Called with `intensity` when event expires. Include to clean up modifiers. |

---

## Intensity Mapping

Intensity is a `0–1` float, randomized between `minIntensity` and `maxIntensity` on each fire.
Map it to a price factor in `onFire`:

```lua
-- Price boost event (+10% to +35%)
local factor = 1.10 + intensity * 0.25

-- Price crash event (-8% to -25%)
local factor = 0.92 - intensity * 0.17

-- Mixed / asymmetric (two crop groups)
local stapleFactor = 1.15 + intensity * 0.30  -- +15% to +45%
local energyFactor = 1.20 + intensity * 0.35  -- +20% to +55%
```

Modifiers stack multiplicatively in MarketEngine. If two events affect the same crop
simultaneously, both factors multiply together.

---

## Modifier ID Convention

Modifier ids must be unique per fill type to allow clean removal:

```lua
id = EVENT_ID .. "_" .. cropName
-- e.g. "my_event_wheat", "my_event_barley"
```

The same id is used in both `addModifier` and `removeModifierById`. If you use different
ids in `onFire` and `onExpire`, the modifier will not be removed — double-check these match.

---

## Loading the File

Add the event file to `main.lua` **before** `src/MarketDynamics.lua`:

```lua
source(modDir .. "src/events/BumperHarvestEvent.lua")
source(modDir .. "src/events/DroughtEvent.lua")
source(modDir .. "src/events/GeopoliticalEvent.lua")
source(modDir .. "src/events/TradeDisruptionEvent.lua")
source(modDir .. "src/events/MyEvent.lua")         -- ← add here
source(modDir .. "src/MarketDynamics.lua")
```

---

## Probability & Balance Reference

Existing events as a balance baseline:

| Event | Probability | Cooldown | Price Range | Duration |
|-------|-------------|----------|-------------|----------|
| Drought | 8% | 30 min | +10–35% | 15 min |
| Bumper Harvest | 10% | 25 min | -8–25% | 12 min |
| Trade Disruption | 6% | 40 min | +5–25% | 8 min |
| Geopolitical Crisis | 4% | 60 min | +15–55% | 20 min |

Guidelines:
- **High-impact events** (>30% swing): keep probability ≤ 5% and cooldown ≥ 45 min
- **Moderate events**: 6–10% probability, 20–35 min cooldown
- **Duration**: keep between 5–25 in-game minutes; very long durations distort the economy

---

## Testing

1. Deploy with `bash build.sh --deploy`
2. Start a new game, open `log.txt`
3. Filter for `[MDM]` — you'll see registration on startup and event firings in-session
4. Temporarily raise `probability` to `1.0` for immediate testing, then restore it

---

## See Also

- [Architecture](architecture.md) — Event registration lifecycle explained
- [API Reference](api-reference.md) — `WorldEventSystem` and `MarketEngine` method signatures

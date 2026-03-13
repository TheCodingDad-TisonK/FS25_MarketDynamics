# API Reference — FS25_MarketDynamics

Public methods for every module. All accessed via `g_MarketDynamics` and its subsystems.

---

## MarketDynamics (Coordinator)

**Global:** `g_MarketDynamics`

| Method | Signature | Description |
|--------|-----------|-------------|
| `new` | `MarketDynamics.new(modDir, modName)` | Constructor. Called once at `Mission00.load`. |
| `onMissionLoaded` | `:onMissionLoaded(mission)` | Inits engine, registers events, sets active. |
| `onStartMission` | `:onStartMission(mission)` | Loads savegame data via serializer. |
| `update` | `:update(dt)` | Per-frame tick. `dt` = game-time delta in ms. |
| `draw` | `:draw()` | Delegates HUD rendering to `g_MDMHud` if set. |
| `save` | `:save(xmlFile)` | Persists state via serializer. |
| `delete` | `:delete()` | Cleanup. Sets `isActive = false`. |

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `marketEngine` | `MarketEngine` | Price management subsystem |
| `worldEvents` | `WorldEventSystem` | Event registry and scheduler |
| `futuresMarket` | `FuturesMarket` | Contract lifecycle |
| `serializer` | `MarketSerializer` | Save/load handler |
| `isActive` | `boolean` | Whether the system is running |

---

## MarketEngine

**Access:** `g_MarketDynamics.marketEngine`

| Method | Signature | Returns | Description |
|--------|-----------|---------|-------------|
| `new` | `MarketEngine.new()` | `MarketEngine` | Constructor. |
| `init` | `:init()` | — | Snapshots base prices from game economy. Call after mission load. |
| `update` | `:update(dt)` | — | Applies intraday and daily volatility on schedule. |
| `getPrice` | `:getPrice(fillTypeIndex)` | `number \| nil` | Current effective price per liter for a fill type. |
| `addModifier` | `:addModifier(modifier)` | — | Applies a named price multiplier to a fill type. |
| `removeModifierById` | `:removeModifierById(fillTypeIndex, id)` | — | Removes a modifier by its string id. |

**Modifier table:**

```lua
{
    id            = string,   -- unique identifier (e.g. "drought_wheat")
    fillTypeIndex = number,   -- fill type index from g_fillTypeManager
    factor        = number,   -- price multiplier (e.g. 1.25 = +25%)
    durationMs    = number,   -- how long the modifier lasts (game-time ms)
}
```

Modifiers stack multiplicatively. Removing a modifier triggers `_recalculate()`.

---

## WorldEventSystem

**Access:** `g_MarketDynamics.worldEvents`

| Method | Signature | Returns | Description |
|--------|-----------|---------|-------------|
| `new` | `WorldEventSystem.new()` | `WorldEventSystem` | Constructor. |
| `registerEvent` | `:registerEvent(event)` | — | Registers an event type. Duplicate ids are rejected with a warning. |
| `update` | `:update(dt)` | — | Ticks active events, checks for expiry, rolls for new events. |
| `getActiveEvents` | `:getActiveEvents()` | `table[]` | Returns list of active event summaries (for HUD/GUI). |

**Event registration table:**

```lua
{
    id           = string,    -- unique event id (e.g. "drought")
    name         = string,    -- display name (e.g. "Regional Drought")
    probability  = number,    -- 0–1 chance per check interval (~5 min)
    minIntensity = number,    -- 0–1, minimum intensity on fire
    maxIntensity = number,    -- 0–1, maximum intensity on fire
    cooldownMs   = number,    -- minimum ms between firings of this event
    onFire       = function,  -- called with intensity (0–1) when event fires
    onExpire     = function,  -- called with intensity when event expires (optional)
}
```

**Active event summary** (returned by `getActiveEvents`):

```lua
{
    id        = string,
    name      = string,
    intensity = number,   -- 0–1
    endsAt    = number,   -- absolute game time (ms)
}
```

---

## FuturesMarket

**Access:** `g_MarketDynamics.futuresMarket`

| Method | Signature | Returns | Description |
|--------|-----------|---------|-------------|
| `new` | `FuturesMarket.new()` | `FuturesMarket` | Constructor. |
| `createContract` | `:createContract(params)` | `contractId` (number) | Creates and stores a new futures contract. |
| `recordDelivery` | `:recordDelivery(contractId, liters)` | `boolean` | Records crop delivery toward a contract. Returns true if now fulfilled. |
| `checkExpiry` | `:checkExpiry()` | — | Called each frame; fulfills or defaults overdue contracts. |
| `getContractsForFarm` | `:getContractsForFarm(farmId)` | `Contract[]` | Returns all contracts for a farm (active, fulfilled, defaulted). |

**Contract params table** (for `createContract`):

```lua
{
    farmId        = number,   -- farm identifier
    fillTypeIndex = number,   -- fill type index
    fillTypeName  = string,   -- display name (e.g. "wheat")
    quantity      = number,   -- contracted amount in liters
    lockedPrice   = number,   -- price per liter at contract creation
    deliveryTimeMs = number,  -- absolute game time deadline (ms)
}
```

**Contract object:**

```lua
{
    id            = number,
    farmId        = number,
    fillTypeIndex = number,
    fillTypeName  = string,
    quantity      = number,   -- total contracted liters
    lockedPrice   = number,   -- per-liter price
    deliveryTime  = number,   -- deadline (absolute game ms)
    delivered     = number,   -- liters delivered so far
    status        = string,   -- "active" | "fulfilled" | "defaulted"
}
```

**Default penalty:** 15% of the value of the undelivered portion.

---

## MarketSerializer

**Access:** `g_MarketDynamics.serializer`

| Method | Signature | Description |
|--------|-----------|-------------|
| `new` | `MarketSerializer.new()` | Constructor. |
| `save` | `:save(coordinator)` | Writes XML to `<savegameDir>/modSettings/FS25_MarketDynamics.xml`. |
| `load` | `:load(coordinator)` | Reads and restores contracts + event cooldowns. No-ops gracefully if no file exists. |

---

## MDMLog (Logger)

**Global:** `MDMLog`

| Method | Description |
|--------|-------------|
| `MDMLog.info(msg)` | Info-level log. Prefixed `[MDM]`. |
| `MDMLog.warn(msg)` | Warning-level log. |
| `MDMLog.error(msg)` | Error-level log. |

All output goes to `log.txt`. Filter by `[MDM]` to isolate mod output.

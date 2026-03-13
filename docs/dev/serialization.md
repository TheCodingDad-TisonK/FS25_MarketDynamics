# Serialization — Save/Load System

How FS25_MarketDynamics persists and restores market state across game sessions.

---

## Save File Location

```
<savegameDirectory>/modSettings/FS25_MarketDynamics.xml
```

The `savegameDirectory` is provided by `g_currentMission.missionInfo.savegameDirectory`.
Each FS25 savegame slot has its own `modSettings/` folder, so state is per-save.

---

## What Is Saved

| Data | Saved | Notes |
|------|-------|-------|
| Futures contracts | ✓ | All statuses: active, fulfilled, defaulted |
| Event `lastFiredAt` | ✓ | Preserves cooldown state across sessions |
| Current crop prices | ✗ | Recalculated fresh on load |
| Active event modifiers | ✗ | Events reset on session start (by design) |

Price state is intentionally not persisted — it recalculates from vanilla base prices
on each `MarketEngine:init()`. This keeps saves forward-compatible if price logic changes.

---

## XML Schema

```xml
<marketDynamics version="1">

  <futures>
    <contract
      id="1"
      farmId="1"
      fillTypeIndex="3"
      fillTypeName="wheat"
      quantity="20000"
      lockedPrice="2.50"
      deliveryTime="345600000"
      delivered="12000"
      status="active"
    />
    <!-- additional contracts... -->
  </futures>

  <events>
    <event id="drought"         lastFiredAt="123456000" />
    <event id="bumper_harvest"  lastFiredAt="98765000"  />
    <!-- one entry per registered event -->
  </events>

</marketDynamics>
```

**Version field:** Currently `"1"`. Increment if schema changes break backward compatibility.
Future loaders should handle older versions gracefully.

---

## Save Flow

Triggered by `FSCareerMissionInfo.saveToXMLFile` → `g_MarketDynamics:save()` →
`MarketSerializer:save(coordinator)`.

```lua
-- Simplified save flow:
local xmlFile = createXMLFile("MDMSave", path, "marketDynamics")
setXMLString(xmlFile, "marketDynamics#version", "1")

-- Write each contract
for _, contract in pairs(coordinator.futuresMarket.contracts) do
    setXMLInt   (xmlFile, base .. "#id",            contract.id)
    setXMLString(xmlFile, base .. "#status",        contract.status)
    -- ... all fields
end

-- Write event cooldown state
for id, event in pairs(coordinator.worldEvents.registry) do
    setXMLFloat(xmlFile, base .. "#lastFiredAt", event.lastFiredAt)
end

saveXMLFile(xmlFile)
delete(xmlFile)
```

---

## Load Flow

Triggered by `Mission00.onStartMission` → `g_MarketDynamics:onStartMission()` →
`MarketSerializer:load(coordinator)`.

```lua
-- Simplified load flow:
local xmlFile = loadXMLFile("MDMLoad", path)
if not xmlFile then return end  -- no save file = fresh start, not an error

-- Restore contracts
local i = 0
while true do
    local id = getXMLInt(xmlFile, base .. "#id")
    if not id then break end
    coordinator.futuresMarket.contracts[id] = { ... }
    -- also updates futuresMarket.nextId to avoid id collisions
    i = i + 1
end

-- Restore event cooldowns
local j = 0
while true do
    local evId = getXMLString(xmlFile, base .. "#id")
    if not evId then break end
    coordinator.worldEvents.registry[evId].lastFiredAt = lastFired
    j = j + 1
end

delete(xmlFile)
```

If the file doesn't exist (new game, or first session after installing the mod),
`loadXMLFile` returns nil and `load()` returns silently — this is expected.

---

## Adding Fields to the Schema

If you add new state that needs persistence:

1. Add `setXML*` calls in `MarketSerializer:save()` for the new field
2. Add matching `getXML*` calls in `MarketSerializer:load()`
3. Handle the missing-field case gracefully in load (old saves won't have the field)
4. Increment the version string if the change is breaking

**FS25 XML API:**

| Function | Type |
|----------|------|
| `setXMLString` / `getXMLString` | string |
| `setXMLInt` / `getXMLInt` | integer |
| `setXMLFloat` / `getXMLFloat` | float |
| `setXMLBool` / `getXMLBool` | boolean |

---

## See Also

- [Architecture](architecture.md) — Full lifecycle including save/load hooks
- [API Reference](api-reference.md) — `MarketSerializer` method signatures

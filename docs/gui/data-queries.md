# Data Queries — Reading Prices, Events, and Contracts

All public APIs available to the GUI layer. Never access subsystem internals directly.

---

## Guard First

Always check before querying — the core may not be active during loading:

```lua
if not g_MarketDynamics or not g_MarketDynamics.isActive then return end
```

---

## Crop Prices

```lua
-- Get current effective price per liter for a fill type
-- Returns number or nil if fill type is unknown to the engine
local price = g_MarketDynamics.marketEngine:getPrice(fillTypeIndex)
```

To get a `fillTypeIndex` from a crop name:

```lua
local fillType = g_fillTypeManager:getFillTypeByName("WHEAT")  -- uppercase
local index = fillType and fillType.index
```

---

## Active World Events

```lua
-- Returns a list of currently active event summaries
local events = g_MarketDynamics.worldEvents:getActiveEvents()

-- Each entry:
-- {
--   id        = string,   -- event id (e.g. "drought")
--   name      = string,   -- display name (e.g. "Regional Drought")
--   intensity = number,   -- 0–1 (how severe)
--   endsAt    = number,   -- absolute game time (ms) when event expires
-- }

if #events == 0 then
    -- show "Markets stable" / mdm_hud_no_events
end

-- Time remaining for an event
local now = g_currentMission and g_currentMission.time or 0
local remaining = event.endsAt - now  -- ms remaining
```

---

## Futures Contracts

```lua
-- Returns all contracts for a farm (active, fulfilled, defaulted)
local farmId = g_currentMission.player.farmId  -- or however you resolve current farm
local contracts = g_MarketDynamics.futuresMarket:getContractsForFarm(farmId)

-- Each contract:
-- {
--   id            = number,
--   farmId        = number,
--   fillTypeIndex = number,
--   fillTypeName  = string,   -- e.g. "wheat"
--   quantity      = number,   -- total contracted liters
--   lockedPrice   = number,   -- per-liter price locked in
--   deliveryTime  = number,   -- deadline (absolute game ms)
--   delivered     = number,   -- liters delivered so far
--   status        = string,   -- "active" | "fulfilled" | "defaulted"
-- }

-- Delivery progress
local pct = contract.delivered / contract.quantity  -- 0.0 to 1.0+

-- Time to deadline
local now = g_currentMission and g_currentMission.time or 0
local timeLeft = contract.deliveryTime - now  -- ms; negative = overdue
```

---

## Creating a Contract (from GUI)

```lua
-- Call when player confirms a new contract in the UI
local contractId = g_MarketDynamics.futuresMarket:createContract({
    farmId         = farmId,
    fillTypeIndex  = fillType.index,
    fillTypeName   = "wheat",
    quantity       = 20000,          -- liters
    lockedPrice    = currentPrice,   -- use getPrice() for current market price
    deliveryTimeMs = deadline,       -- absolute game time in ms
})
```

Getting a reasonable delivery deadline (e.g. 3 in-game days from now):

```lua
local now = g_currentMission.time
local threeDaysMs = 3 * 24 * 60 * 60 * 1000
local deadline = now + threeDaysMs
```

---

## Recording a Delivery (from GUI or sell hook)

```lua
-- Call when player delivers crop toward a contract
local fulfilled = g_MarketDynamics.futuresMarket:recordDelivery(contractId, liters)
if fulfilled then
    -- show fulfillment notification
end
```

---

## See Also

- [Integration Guide](integration-guide.md) — How to set up `g_MDMHud`
- [Translation Keys](l10n-keys.md) — L10N strings for UI labels
- [API Reference](../dev/api-reference.md) — Full method signatures and types

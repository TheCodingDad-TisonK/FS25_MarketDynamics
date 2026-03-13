# GUI Integration Guide — LeGrizzly (dev-2)

How to hook your HUD into the MarketDynamics core without touching `src/` files.

---

## The Integration Contract

The core system provides one hook point for GUI:

```lua
-- In MarketDynamics:draw() — called every frame
if g_MDMHud then
    g_MDMHud:draw()
end
```

**Your job:** Set `g_MDMHud` to an object with a `draw()` method. The core calls it every frame.
You never modify files in `src/`. All GUI code lives in `gui/`.

---

## Setting Up g_MDMHud

Set the global after your HUD is initialized and ready to draw:

```lua
-- In your HUD init (after GUI elements are loaded):
g_MDMHud = MyHud.new()
```

Unset it on cleanup:

```lua
-- In your HUD delete:
g_MDMHud = nil
```

The core's `draw()` guard (`if g_MDMHud then`) handles the case where your HUD
isn't loaded yet or has been cleaned up — no errors, no crashes.

---

## Timing — When Is Data Available?

| Data | Available After |
|------|----------------|
| `g_MarketDynamics` exists | `Mission00.load` |
| Subsystems initialized | `Mission00.loadMission00Finished` |
| Save data restored | `Mission00.onStartMission` |
| Prices populated | `MarketEngine:init()` (called in `loadMission00Finished`) |

Initialize your HUD after `loadMission00Finished`. Querying prices or contracts
before this point will return nil or empty tables.

---

## Reading Data

All data queries go through `g_MarketDynamics` and its subsystems.
**Never access subsystem internals directly** — use the public methods.

See [Data Queries](data-queries.md) for the full reference. Quick examples:

```lua
-- Current price for a fill type
local price = g_MarketDynamics.marketEngine:getPrice(fillTypeIndex)

-- Active world events (for event ticker/banner)
local events = g_MarketDynamics.worldEvents:getActiveEvents()
-- returns: { { id, name, intensity, endsAt }, ... }

-- Farm's futures contracts
local contracts = g_MarketDynamics.futuresMarket:getContractsForFarm(farmId)
-- returns: { Contract, ... }  (see API Reference for Contract fields)
```

---

## Guard Pattern

Always guard reads with existence checks — the core may not be active yet
(e.g., during map loading):

```lua
function MyHud:draw()
    if not g_MarketDynamics or not g_MarketDynamics.isActive then return end

    -- safe to query now
    local events = g_MarketDynamics.worldEvents:getActiveEvents()
    -- ...
end
```

---

## Branch Rules

- **GUI branch:** `dev-2` (LeGrizzly)
- **Core branch:** `dev-1` (tison)
- GUI PRs must never modify files in `src/`
- Core PRs must never modify files in `gui/`
- Merge conflicts in shared files (e.g. `main.lua`, `modDesc.xml`) — coordinate before merging

---

## File Organization

```
gui/
  MyHud.lua              ← main HUD class
  MyHud.xml              ← layout descriptor (if using FS25 XML GUI)
  textures/              ← HUD graphics
```

Add your Lua files to `main.lua` source order. GUI files should be sourced after all
`src/` files but can be before or after `src/MarketDynamics.lua` — the hook is set
at runtime, not at source time.

---

## Translation Keys

L10N strings used by core and available for GUI are listed in [Translation Keys](l10n-keys.md).

---

## See Also

- [Data Queries](data-queries.md) — All public read APIs for GUI use
- [Translation Keys](l10n-keys.md) — Available L10N strings
- [API Reference](../dev/api-reference.md) — Full method signatures

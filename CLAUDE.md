# FS25_MarketDynamics — Claude Project Context

## What this mod is
Real-world-inspired dynamic crop pricing for Farming Simulator 25.
Prices fluctuate daily and intraday based on world events, weather, and supply/demand.
Includes a futures contract system where players lock in prices months in advance.

**Authors:** TheCodingDad (tison) & LeGrizzly
**License:** CC BY-NC-ND 4.0 (see `LICENSE`)

---

## Architecture

| File | Role |
|------|------|
| `main.lua` | Entry point — loads all modules, hooks into FS25 mission lifecycle |
| `src/MarketDynamics.lua` | Root coordinator (`g_MarketDynamics`) — owns all subsystems |
| `src/MarketEngine.lua` | Per-fillType dynamic prices: base, volatilityFactor, modifiers, history |
| `src/PriceHook.lua` | Intercepts FS25's vanilla price queries and returns MDM prices |
| `src/FuturesMarket.lua` | Futures contract creation, delivery tracking, settlement |
| `src/WorldEventSystem.lua` | Fires random world events, manages cooldowns and active events |
| `src/MarketSerializer.lua` | Save/load market state to `<savegame>/modSettings/FS25_MarketDynamics.xml` |
| `src/Logger.lua` | `MDMLog.info/warn/error/debug` — log prefix `[MDM]` |
| `src/DebugHUD.lua` | In-game debug overlay (toggled via settings) |
| `src/BCIntegration.lua` | BetterContracts mod compatibility |
| `src/UPIntegration.lua` | UsedPlus mod compatibility |
| `src/AdminCommands.lua` | Dev console commands |
| `src/gui/MarketScreen.lua` | Main market screen controller (TabbedMenuFrameElement subclass) |
| `src/gui/MarketScreen.xml` | GUI layout — commodity list, prices/events/contracts tabs, contract dialog |
| `src/gui/MarketScreenGraph.lua` | Draws the price history line chart in the Prices tab |
| `src/gui/SettingsUI.lua` | In-game settings panel integration |
| `src/events/*.lua` | Individual world events (e.g. DroughtEvent, PestOutbreakEvent) |

---

## Key conventions

- **Log prefix:** `[MDM]` — always filter log.txt for this
- **Global:** `g_MarketDynamics` — the root coordinator instance
- **Price model:** `current = base * volatilityFactor * Π(eventModifiers)`
- **Save schema version:** currently `v2` in MarketSerializer
- **Coord system:** FS25 GUI is Y-UP, anchorBottomLeft by default. Positive Y = upward.
- **Mouse events in FS25:** processed in **reverse** XML declaration order (last declared = first to receive clicks)
- **No `%` in log strings** — FS25's `Logging.info()` calls `string.format()` internally; use `math.floor(n) .. "%"` not `string.format("%.0f%%", n)`

---

## Build & deploy

```bash
bash build.sh --deploy
```
Zips the mod and copies to `C:\Users\tison\Documents\My Games\FarmingSimulator2025\mods`.
Always check `log.txt` for `[MDM]` entries after deploying.

---

## Active branch: `dev-1`
Main branch for PRs: `main`

---

## Mod compatibility

| Mod | Integration file | Notes |
|-----|-----------------|-------|
| BetterContracts | `BCIntegration.lua` | Suppresses futures UI when BC is active |
| UsedPlus | `UPIntegration.lua` | Credit/deal API for futures settlement |

---

## Known constraints & gotchas

- `modDesc.xml` actions must NOT have `axisType` attribute (causes `validateActionEventParameters` callstack)
- `createFolder()` must be called before `createXMLFile()` — FS25 does not auto-create parent directories
- GUI Buttons extending `fs25_buttonText` trigger `MENU_ACCEPT` navigation — use `emptyPanel` + `isFocusable` instead
- The commodity list filters to `g_fruitTypeManager` fruit types only — not all fill types with a price
- Tab switching uses a `mouseEvent` override for reliable click detection (FS25 Button onClick is unreliable inside TabbedMenuFrameElement pages)

# FS25_MarketDynamics — Documentation

Dynamic crop pricing driven by world events, supply/demand, and intraday volatility.
Includes a futures contract system for hedging harvest prices.

**Version:** 1.0.0.0 · **Authors:** TheCodingDad (tison) & LeGrizzly

---

## Who Are You?

| You Are | Start Here |
|---------|-----------|
| A player/farmer using the mod | [Player Guide →](player-guide/overview.md) |
| A developer working on core systems | [Architecture →](dev/architecture.md) |
| LeGrizzly building the GUI | [GUI Integration →](gui/integration-guide.md) |
| A community contributor | [Dev Overview →](dev/architecture.md) + [Event Authoring →](dev/event-authoring.md) |

---

## Contents

### Player Guide
- [Overview](player-guide/overview.md) — What this mod does and why
- [World Events](player-guide/world-events.md) — All 4 events explained
- [Futures Contracts](player-guide/futures-contracts.md) — Lock in your harvest price

### Developer Docs
- [Architecture](dev/architecture.md) — System design, module map, lifecycle
- [API Reference](dev/api-reference.md) — Public methods for every module
- [Event Authoring](dev/event-authoring.md) — How to create and register new events
- [Serialization](dev/serialization.md) — Save/load system internals
- [Lua Compatibility](dev/lua-compat.md) — Lua 5.1 / FS25 gotchas

### GUI Integration (LeGrizzly)
- [Integration Guide](gui/integration-guide.md) — How to hook your HUD into the core
- [Data Queries](gui/data-queries.md) — Reading prices, events, and contracts
- [Translation Keys](gui/l10n-keys.md) — All available L10N strings

---

## Quick Reference

```
g_MarketDynamics                 Central coordinator (global)
  ├── marketEngine               Price management & volatility
  ├── worldEvents                Event registry & scheduling
  ├── futuresMarket              Contract creation & fulfillment
  └── serializer                 Save/load to modSettings XML
```

**Log prefix:** `[MDM]`
**Save path:** `<savegameDir>/modSettings/FS25_MarketDynamics.xml`
**Multiplayer:** Not supported (single-player only)

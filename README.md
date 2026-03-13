# FS25_MarketDynamics

**Real-world inspired dynamic crop pricing for Farming Simulator 25.**

Prices no longer sit static. A drought in Europe, a bumper harvest in the Americas, a geopolitical crisis — they all move markets. Track live prices, react to global events, and lock in your harvest via futures contracts like a real commodity trader.

---

## Features

### Dynamic Pricing Engine
- Per-fillType price state with base + live modifier stack
- Intraday micro-fluctuations (every in-game minute)
- Daily trend shifts with mean-reversion toward base price
- All effects stack and expire cleanly

### World Event System
| Event | Price Impact | Duration |
|-------|-------------|----------|
| Regional Drought | Grain +10–35% | ~15 min |
| Bumper Harvest | Grain -8–25% | ~12 min |
| Trade Disruption | Mixed crops +5–25% | ~8 min |
| Geopolitical Crisis | Staples +15–45%, Energy crops +20–55% | ~20 min |

Events fire probabilistically on a timer with per-type cooldowns so markets feel alive, not random chaos.

### Futures Contracts
- Lock in a price months in advance for any crop
- Commit to a quantity and delivery date
- Fulfill early → full locked payout
- Default → partial payout minus 15% penalty on unfulfilled portion

### Market HUD *(in development — LeGrizzly)*
- Corner price ticker for key crops
- Active event notification banners
- Full market screen with price history

---

## Installation

1. Download `FS25_MarketDynamics.zip`
2. Place in `Documents/My Games/FarmingSimulator2025/mods/`
3. Enable in the mod manager

---

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch structure, coding standards, and build instructions.

**Authors:**
- **tison (TheCodingDad)** — core systems (engine, events, futures, serializer)
- **LeGrizzly** — GUI systems (market screen, HUD, futures dialog)

---

## License

[CC BY-NC-ND 4.0](LICENSE) — Attribution, Non-Commercial, No Derivatives.

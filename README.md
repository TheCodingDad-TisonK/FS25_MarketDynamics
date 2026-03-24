# FS25_MarketDynamics

> [!TIP]
> Want to be part of our community? Share tips, report issues, and chat with other farmers on the **[FS25 Modding Community Discord](https://discord.gg/Th2pnq36)**!

**Real-world inspired dynamic crop pricing for Farming Simulator 25.**

Prices no longer sit static. A drought in Europe, a bumper harvest in the Americas, a geopolitical shock — they all move markets. Track live prices, react to global events, and lock in your harvest via futures contracts like a real commodity trader.

---

<a href="https://paypal.me/TheCodingDad">
  <img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" alt="Donate via PayPal" height="50">
</a>

---

## Features

### Dynamic Pricing Engine
- Per-crop price state with a base price + live modifier stack
- Intraday micro-fluctuations every in-game minute
- Daily trend shifts with mean-reversion toward the base price
- All modifiers stack and expire cleanly — no ghost effects after events end

### World Event System — 7 Events

| Event | Affected Crops | Price Impact | Cooldown |
|-------|---------------|-------------|---------|
| Regional Drought | Wheat, Barley, Canola, Corn, Sunflower | +10–35% | 30 min |
| Bumper Harvest | Wheat, Barley, Corn, Oat, Sorghum | −8–25% | 25 min |
| Trade Disruption | Random 50% of all grains | +5–25% | 40 min |
| Geopolitical Crisis | Staples +15–45%, Energy crops +20–55% | High | 60 min |
| Biofuel Initiative | Canola, Sunflower, Sugarbeet | +25–50% | 2 hrs |
| Livestock Feed Boom | Grass, Silage, Maize | +15–40% | 1.5 hrs |
| Root Crop Blight | Potato, Sugarbeet | +20–60% | 1 hr |

Events fire probabilistically on a fixed check interval with per-type cooldowns so markets feel alive, not random noise.

### Futures Contracts
- Lock in a price now for delivery up to 120 in-game days in the future
- Choose any crop tracked by MDM, set a quantity and delivery window
- Fulfill by delivering before the deadline → full locked-price payout
- Default (miss the deadline) → partial payout minus 15% penalty on the unfulfilled portion
- Credit score integration with **FS25_UsedPlus** — good credit lowers the default penalty

### Market Screen  *(Press **F10**)*
Full InGameMenu page with three tabs:

| Tab | What you see |
|-----|-------------|
| **Prices** | Live price list for all tracked crops with % change; select a crop for a detail card and session price trend chart |
| **Events** | All currently active world events with intensity (Mild / Moderate / Severe) and time remaining |
| **Contracts** | Your active, fulfilled, and defaulted futures contracts |

Press **Q / E** to cycle tabs, **Up / Down** to navigate lists.

### Futures Contract Dialog  *(Press **N** or click "New Contract" in the Contracts tab)*
- Crop selector with live prices and change % for every tracked crop
- Six quantity presets: 500 / 1,000 / 5,000 / 10,000 / 25,000 / 50,000 L
- Four delivery windows: 30 / 60 / 90 / 120 days
- Live summary panel: locked price, total value, deadline, penalty note
- **Price signal badge**: green ▲ when price is above base (good time to lock in), yellow ◆ near baseline, red ▼ below base (consider waiting)
- Press **Enter** to confirm or **Escape** to cancel

### Mod Integrations

**FS25_BetterContracts** (by Mmtrx)
- Harvest missions trigger supply-spike modifiers via the MDM price engine
- MDM's own futures UI is suppressed when BC mode is active
- BC can read MDM futures contracts via `g_currentMission.MarketDynamics.futuresMarket:getContractsForFarm(farmId)`

**FS25_UsedPlus** (by XelaNull)
- Fulfilled contracts improve your credit score; defaults hurt it
- Credit score scales the default penalty: excellent credit → ~10%, poor credit → ~20%
- New contract registrations are forwarded to the UP credit bureau

### Translations
Full localization for all 25 FS25 languages — generated via Google Translate from the English source.

---

## Installation

1. Download `FS25_MarketDynamics.zip`
2. Place in `Documents/My Games/FarmingSimulator2025/mods/`
3. Enable in the in-game Mod Manager
4. Start a career save — the mod activates automatically

**Keyboard shortcuts** (rebindable in Game Controls):

| Action | Default Key |
|--------|------------|
| Toggle Market Screen | F10 |
| New Futures Contract | N *(while Market Screen is open)* |

---

## Compatibility

- **Farming Simulator 25** — PC/Mac (singleplayer)
- Multiplayer: not supported in v0.1
- Compatible with FS25_BetterContracts and FS25_UsedPlus (see integrations above)

---

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch structure, coding standards, and build instructions.

**Authors:**
- **TisonK (TheCodingDad)** — core systems (engine, events, futures, serializer, GUI)
- **LeGrizzly** — original Market Screen UI design

---

## License

[CC BY-NC-ND 4.0](LICENSE) — Attribution, Non-Commercial, No Derivatives.

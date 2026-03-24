# FS25_MarketDynamics

> [!TIP]
> Want to be part of our community? Share tips, report issues, and chat with other farmers on the **[FS25 Modding Community Discord](https://discord.gg/Th2pnq36)**!

**Real-world inspired dynamic crop pricing for Farming Simulator 25.**

Prices no longer sit static. A drought in Europe, a bumper harvest in the Americas, a geopolitical shock — they all move markets. Open the Market screen, track live prices, react to global events, and lock in your harvest via futures contracts like a real commodity trader.

---

[![Downloads](https://img.shields.io/github/downloads/TheCodingDad-TisonK/FS25_MarketDynamics/total?style=for-the-badge&logo=github&color=4caf50&logoColor=white)](https://github.com/TheCodingDad-TisonK/FS25_SoilFertilizer/releases)
[![Release](https://img.shields.io/github/v/release/TheCodingDad-TisonK/FS25_MarketDynamics?style=for-the-badge&logo=tag&color=76c442&logoColor=white)](https://github.com/TheCodingDad-TisonK/FS25_SoilFertilizer/releases/latest)
[![License](https://img.shields.io/badge/license-CC%20BY--NC--ND%204.0-lightgrey?style=for-the-badge&logo=creativecommons&logoColor=white)](https://creativecommons.org/licenses/by-nc-nd/4.0/)
<a href="https://paypal.me/TheCodingDad">
  <img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" alt="Donate via PayPal" height="50">
</a>

---

## Features

### Dynamic Pricing Engine

Every crop has a live price built from three layers: a base price that tracks the vanilla seasonal curve, a volatility factor that drifts intraday and daily with mean-reversion, and an event modifier stack that stacks cleanly and expires on its own. The price you see at the selling station is always the result of all three — no static values, no ghost effects after events end.

- Intraday micro-fluctuations every in-game minute
- Daily trend shifts with mean-reversion toward the base price
- Prices clamp between 50% and 200% of base — volatile but never absurd

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

Events fire probabilistically on a fixed check interval with per-type cooldowns so markets feel alive without becoming random noise. Intensity is rolled per-event, so a drought can hit mild one time and severe the next.

### Futures Contracts

Lock in a sell price today for delivery up to 120 in-game days from now. Pick a crop, set a quantity, choose a delivery window — MDM handles the rest.

- **Fulfill on time** → full locked-price payout, regardless of what the market did
- **Miss the deadline** → partial payout, with a 15% penalty on the unfulfilled portion
- Credit score integration with **FS25_UsedPlus** — good credit history lowers your default penalty (down to ~10%), poor history raises it (up to ~20%)

### Market Screen *(Press F10)*

A full InGameMenu page with three tabs:

| Tab | What you see |
|-----|-------------|
| **Prices** | Live price list for all tracked crops with % change; select a crop for a detail card and session price trend chart |
| **Events** | All currently active world events with intensity (Mild / Moderate / Severe) and time remaining |
| **Contracts** | Your active, fulfilled, and defaulted futures contracts |

Press **Q / E** to cycle tabs, **Up / Down** to navigate the list.

### New Contract Dialog *(Press N, or click "New Contract")*

- Crop selector with live prices and % change for every tracked crop
- Six quantity presets: 500 / 1,000 / 5,000 / 10,000 / 25,000 / 50,000 L
- Four delivery windows: 30 / 60 / 90 / 120 days
- Live summary panel: locked price, total contract value, deadline, penalty note
- **Price signal badge** — green ▲ when the price is above its historical base (good time to lock in), yellow ◆ near baseline, red ▼ below base (consider waiting)

### Mod Integrations

**FS25_BetterContracts** (by Mmtrx) — when installed, completing a harvest contract triggers a short-lived supply-spike on the harvested crop (prices dip ~8% for one in-game hour, reflecting the increased supply hitting the market). MDM's futures UI remains fully available alongside BetterContracts — they serve different purposes and coexist cleanly.

**FS25_UsedPlus** (by XelaNull) — fulfilled futures contracts improve your credit score; defaults hurt it. Your credit score then scales the penalty rate on future defaults. New contract registrations are forwarded to the UP credit bureau automatically on detection.

### Settings

All options are available in-game under ESC → Settings → Market Dynamics:

- Enable / disable dynamic prices (fall back to vanilla prices)
- Enable / disable world events
- Event frequency (Rare / Normal / Frequent)
- Price volatility scale (Low / Normal / High / Extreme)
- Debug logging

### Translations

Full localization for all 25 Farming Simulator 25 languages, generated from the English source.

---

## Installation

1. Download `FS25_MarketDynamics.zip`
2. Place in `Documents/My Games/FarmingSimulator2025/mods/`
3. Enable in the in-game Mod Manager
4. Start a career save — the mod activates automatically on load

**Keyboard shortcuts** (rebindable in Game Controls):

| Action | Default Key |
|--------|------------|
| Toggle Market Screen | F10 |
| New Futures Contract | N *(while Market Screen is open)* |

---

## Compatibility

- **Farming Simulator 25** — PC/Mac
- **Singleplayer** — fully supported
- **Multiplayer** — singleplayer only for now; multiplayer support is planned for a future release
- Compatible with FS25_BetterContracts and FS25_UsedPlus (see integrations above)

---

## Roadmap

These are features planned for future releases — not present in v0.1:

- **Multiplayer support** — syncing price state and events across all connected clients on a dedicated server
- **More world events** — seasonal harvest windows, currency crises, fuel price shocks
- **Price alerts** — notify the player when a tracked crop crosses a threshold
- **Contract templates** — save and reuse favourite crop/quantity/window combinations

---

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch structure, coding standards, and build instructions.

**Authors:**
- **TisonK (TheCodingDad)** — core systems (engine, events, futures, serializer, GUI integration)
- **LeGrizzly** — Market Screen UI design

---

## License

[CC BY-NC-ND 4.0](LICENSE) — Attribution, Non-Commercial, No Derivatives.

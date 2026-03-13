# Player Guide — World Events

World events are random, temporary shocks that move crop prices significantly.
They fire automatically — you don't trigger them. You just have to react.

---

## How Events Work

Every 5 in-game minutes, the system rolls the dice for each event type. If an event
fires, it applies a price multiplier to specific crops for a set duration. When the
event expires, those multipliers are removed and prices return to baseline.

Only one event of each type can be active at a time. Each event has a minimum cooldown
before it can fire again.

---

## Event Reference

### Drought

> A region-wide drought cuts crop yields and drives up grain prices.

| Property | Value |
|----------|-------|
| Price change | +10% to +35% |
| Affected crops | Wheat, barley, canola, corn, sunflower |
| Duration | ~15 in-game minutes |
| Fire chance | 8% per check |
| Cooldown | 30 in-game minutes |

**Strategy:** If you have grain in storage, a drought is a great time to sell.
If you have a futures contract for grain delivery, this event validates that hedge.

---

### Bumper Harvest

> An exceptionally large regional harvest floods the market, pushing grain prices down.

| Property | Value |
|----------|-------|
| Price change | -8% to -25% |
| Affected crops | Wheat, barley, corn, oat, sorghum |
| Duration | ~12 in-game minutes |
| Fire chance | 10% per check |
| Cooldown | 25 in-game minutes |

**Strategy:** This is the most common negative event. If you're holding grain and a
bumper harvest fires, consider waiting it out. If you locked in a futures contract
before this event, you're protected from the price drop.

---

### Trade Disruption

> Supply chain chaos creates unpredictable price swings across the commodity market.

| Property | Value |
|----------|-------|
| Price change | +5% to +25% |
| Affected crops | Random 50% selection from: wheat, barley, canola, corn, sunflower, soybean, oat |
| Duration | ~8 in-game minutes |
| Fire chance | 6% per check |
| Cooldown | 40 in-game minutes |

**Strategy:** This is the wildcard event. You won't know which crops are affected
until it fires. Diversified inventories benefit most here — something in your silos
is almost certain to spike. Duration is short, so act quickly.

---

### Geopolitical Crisis

> International tensions disrupt food and energy commodity markets worldwide.

| Property | Value |
|----------|-------|
| Price change (staples) | +15% to +45% — Wheat, barley |
| Price change (energy crops) | +20% to +55% — Canola, sunflower |
| Duration | ~20 in-game minutes |
| Fire chance | 4% per check |
| Cooldown | 60 in-game minutes |

**Strategy:** This is the rarest and most powerful event. Canola and sunflower can
see enormous price surges. The long duration (20 min) gives you more time to react
and sell. Because it's rare and the cooldown is long, don't expect it to save you
regularly — but when it fires, it's a major opportunity.

---

## Seeing Active Events

The HUD (top of screen, provided by LeGrizzly's GUI) shows currently active events
and which crops are affected. If no events are active, the panel will read "No active events."

---

## Tips

- **Bumper Harvest is the most common** (10% chance). Expect it regularly.
- **Geopolitical Crisis is the rarest** (4% chance, 60-min cooldown). Don't plan around it.
- **Events stack with intraday volatility** — a drought during a natural price peak is a great sell window.
- **Futures contracts are your insurance** against negative events like Bumper Harvest.

# Player Guide — Futures Contracts

A futures contract lets you lock in a crop price today for a delivery you'll make in the future.
It's your main tool for protecting yourself against price crashes — and for capitalizing on
price spikes before your harvest even comes in.

---

## How It Works

1. **You agree to sell** a set quantity of a crop at today's price, with a delivery deadline.
2. **You grow and deliver** the crop before that deadline.
3. **At the deadline**, the system checks your delivery:
   - **Fulfilled** (≥ quantity delivered): You receive the full locked-in payout.
   - **Defaulted** (< quantity delivered): You receive partial pay for what was delivered,
     minus a **15% penalty** on the unfulfilled portion.

The locked price doesn't change — even if market prices crash or spike after you sign.

---

## Why Use Futures?

### Scenario A — Price Protection

You see a **Geopolitical Crisis** spike canola prices to +45%. You don't have the crop yet,
but you can lock in that elevated price right now. Even if the event ends and prices fall
before your harvest, you still get paid the locked rate.

### Scenario B — Hedging Against Bumper Harvest

You're storing 50,000L of wheat. A **Bumper Harvest** looks likely — prices are about to
fall 20%. Lock in the current price before the event fires, then deliver after.

### Scenario C — Planned Selling

You know you'll have 30,000L of barley ready in 3 in-game days. Lock in today's price and
remove the uncertainty entirely. No need to watch the market.

---

## The Default Penalty

If you can't deliver the full contracted quantity by the deadline:

- You receive the locked price for **everything you did deliver**.
- You pay a **15% penalty** on the value of the **undelivered portion**.

**Example:**

| Contract | 10,000L wheat @ $2.50/L |
|----------|------------------------|
| Delivered | 7,000L |
| Shortfall | 3,000L |
| Partial payout | 7,000 × $2.50 = **$17,500** |
| Penalty | 3,000 × $2.50 × 15% = **-$1,125** |
| **Net received** | **$16,375** |

Don't commit to more than you can grow.

---

## Strategy Tips

- **Don't over-commit.** Only contract quantities you're confident you can deliver.
  If a drought spikes prices, it's tempting to lock in a huge contract — but if your
  harvest underperforms, the penalty hurts.

- **Shorter deadlines = less risk.** The closer the deadline to when your crops are
  actually ready, the less can go wrong.

- **Futures + events = powerful combo.** Use futures to lock in event-driven price spikes.
  That's what they're designed for.

- **Watch your silos.** Delivery counts grain already in storage. If you have crop ready,
  a short-deadline contract is almost risk-free.

---

## See Also

- [Overview](overview.md) — How the whole mod works
- [World Events](world-events.md) — Events that create futures opportunities

# Translation Keys — L10N Strings

All available localization keys defined in `translations/translation_en.xml`.
Use these in your GUI XML layouts or Lua via `g_i18n:getText("key")`.

---

## Usage

```lua
-- In Lua
local label = g_i18n:getText("mdm_hud_title")  -- "Market Watch"

-- In XML layout
-- <TextElement text="$l10n_mdm_hud_title" />
```

---

## Event Names

| Key | English Text |
|-----|-------------|
| `mdm_event_drought` | Regional Drought |
| `mdm_event_bumper_harvest` | Bumper Harvest |
| `mdm_event_trade_disruption` | Trade Disruption |
| `mdm_event_geopolitical` | Geopolitical Crisis |

These match the `name` field returned by `worldEvents:getActiveEvents()`.
You can also just use the `name` field directly from the event summary — it's the same string.

---

## HUD Labels

| Key | English Text |
|-----|-------------|
| `mdm_hud_title` | Market Watch |
| `mdm_hud_active_events` | Active Events |
| `mdm_hud_no_events` | Markets stable |

---

## Futures UI

| Key | English Text |
|-----|-------------|
| `mdm_futures_title` | Futures Market |
| `mdm_futures_create` | New Contract |
| `mdm_futures_fulfill` | Fulfilled |
| `mdm_futures_defaulted` | Defaulted |
| `mdm_futures_active` | Active |
| `mdm_futures_delivery_label` | Delivery |
| `mdm_futures_locked_label` | Locked Price |
| `mdm_futures_quantity_label` | Quantity (L) |

---

## Adding New Keys

1. Add the entry to `translations/translation_en.xml`
2. Add matching entries to any other translation files if they exist
3. Use the `mdm_` prefix for all MarketDynamics keys

```xml
<text name="mdm_my_new_key" text="My Label" />
```

---

## See Also

- [Integration Guide](integration-guide.md) — GUI setup
- [Data Queries](data-queries.md) — What data to display

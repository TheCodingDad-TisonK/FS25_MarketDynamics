<div align="center">
  
<img width="154" height="204" alt="icon" src="https://github.com/user-attachments/assets/040a03c2-517a-4a30-ba58-af85378cb2f7" />

# 📱 FS25 Farm Tablet

### *All your farm data. One screen. Never leave the game.*

[![Downloads](https://img.shields.io/github/downloads/TheCodingDad-TisonK/FS25_FarmTablet/total?style=for-the-badge&logo=github&color=4caf50&logoColor=white)](https://github.com/TheCodingDad-TisonK/FS25_FarmTablet/releases)
[![Release](https://img.shields.io/github/v/release/TheCodingDad-TisonK/FS25_FarmTablet?style=for-the-badge&logo=tag&color=76c442&logoColor=white)](https://github.com/TheCodingDad-TisonK/FS25_FarmTablet/releases/latest)
[![License](https://img.shields.io/badge/license-CC%20BY--NC--ND%204.0-lightgrey?style=for-the-badge&logo=creativecommons&logoColor=white)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

<br>

**Press `T` to open the tablet. Browse your farm stats, check the forecast, inspect nearby vehicles, track field conditions, and manage your mod integrations — all without touching a menu.**

`Singleplayer` • `Multiplayer (per-farm)` • `15 apps` • `Mod integrations` • `Console commands`

</div>
<img width="234" height="354" alt="image" src="https://github.com/user-attachments/assets/aeafc106-6fb6-4d31-ac44-4cff21db0a0b" /> <img width="234" height="354" alt="image" src="https://github.com/user-attachments/assets/671061be-4e01-464d-a2a7-aa2a50c7a5b5" /> <img width="234" height="354" alt="image" src="https://github.com/user-attachments/assets/e51b9027-4816-43ec-97ca-f6c190ffa5b9" /> <img width="234" height="354" alt="image" src="https://github.com/user-attachments/assets/e5f5226e-d5c7-45df-ae2e-3822958cb649" />

---

## What It Does

The Farm Tablet is a full-screen HUD overlay that opens with a single key press. It replaces the need to open multiple in-game menus to check your balance, weather, field states, or vehicle health. Apps load instantly — no menus, no loading screens, just your data.

Optional integration apps appear automatically when compatible sibling mods are installed. No configuration needed — the tablet detects them on startup and registers the apps for you.

---

## Quick Start

> **Drop the zip in your mods folder, load a save, press `T`.**

```
%USERPROFILE%\Documents\My Games\FarmingSimulator2025\mods\
```

That's it. No XML editing, no extra config files. Settings are accessible inside the tablet itself (Settings app), or from the ESC pause menu under the Settings tab.

---

## Apps

### Built-in Apps

| App | What It Shows |
|-----|---------------|
| **Financial Dashboard** | Farm balance, net income, expenses, active loans, field count, vehicle count, season and time |
| **App Store** | Browse all registered apps — built-in and mod integrations — with version info |
| **Weather** | Current conditions (temperature, wind, humidity, rain chance), plus a 3-day outlook |
| **Digging** | Ground type at your location, nearby terrain info, excavation tracking |
| **Bucket Tracker** | Load counts and estimated weight for loader/bucket vehicles — tracks fills and dumps |
| **Field Status** | Field ownership, crop type, growth stage, and soil state for fields near you |
| **Animal Husbandry** | Livestock counts, productivity, feed status, and barn info across your farm |
| **Workshop** | Nearby vehicle diagnostics — fuel level, wear %, operating hours, attached implements |
| **NPC Favor** | NPC neighbor list, relationship levels, and favor system status (requires FS25_NPCFavor) |
| **Seasonal Crop Stress** | Per-field soil moisture and crop stress readings (requires FS25_SeasonalCropStress) |
| **Soil & Fertilizer** | Per-field N/P/K nutrient levels and soil health data (requires FS25_SoilFertilizer) |
| **Settings** | Toggle mod features, change the open key, and configure notifications without leaving the game |
| **Updates** | Changelog and version history |

### Mod Integration Apps

These apps register automatically when the matching mod is active — no setup required:

| App | Requires | What It Shows |
|-----|----------|---------------|
| **Income Mod** | FS25_IncomeMod | Payment mode, current amount, enabled status, enable/disable toggles |
| **Tax Mod** | FS25_TaxMod | Tax rate, last payment, next due date, tax system status |
| **NPC Favor** | FS25_NPCFavor | NPC roster, relationship levels, favor/debt summary |
| **Seasonal Crop Stress** | FS25_SeasonalCropStress | Field moisture, stress level, irrigation need |
| **Soil & Fertilizer** | FS25_SoilFertilizer | N/P/K per field, deficiency flags |

---

## Keybindings

| Key | Action |
|-----|--------|
| `T` | Open / close the tablet (default — configurable) |
| Mouse click | Navigate apps, press buttons |
| ESC | Close the tablet |

The open key can be changed to any letter, F1–F12, Tab, Space, Enter, or numpad key — either in the Settings app or via console command. Changes take effect immediately, no restart needed.

---

## Console Commands

Type `tablet` in the developer console (`~` key) for the full list.

| Command | Description |
|---------|-------------|
| `tablet` | List all console commands |
| `tabletStatus` | Print current settings to console |
| `TabletOpen` / `TabletClose` | Open or close the tablet |
| `TabletToggle` | Toggle open/closed |
| `TabletEnable` / `TabletDisable` | Enable or disable the mod entirely |
| `TabletKeybind [key]` | Change the open key — takes effect immediately |
| `TabletSetNotifications true\|false` | Toggle HUD notifications |
| `TabletSetStartupApp 1\|2\|3\|4` | Set which app opens first |
| `TabletResetSettings` | Reset all settings to defaults |
| `TabletShowSettings` | Print all current settings |

---

## Settings

Settings are saved to your savegame folder (`FS25_FarmTablet.xml`) and persist across sessions.

| Setting | Default | Description |
|---------|---------|-------------|
| Open Key | `T` | Key to open/close the tablet |
| Startup App | Dashboard | Which app opens first |
| Notifications | On | HUD welcome and status messages |
| Sound Effects | On | Audio feedback on app switch |
| Vibration Feedback | On | Controller haptics on interaction |
| Debug Mode | Off | Verbose logging to game log |

---

## Compatibility

- Farming Simulator 25
- Singleplayer and multiplayer (per-farm data isolation)
- Works alongside any other mod — the tablet only reads game data, it does not modify farm state

**Works best with the sibling mod ecosystem:**

| Mod | Integration |
|-----|-------------|
| [FS25_IncomeMod](https://github.com/TheCodingDad-TisonK/FS25_IncomeMod) | Full status + enable/disable controls |
| [FS25_TaxMod](https://github.com/TheCodingDad-TisonK/FS25_TaxMod) | Tax status and payment info |
| [FS25_NPCFavor](https://github.com/TheCodingDad-TisonK/FS25_NPCFavor) | NPC roster and relationship levels |
| [FS25_SeasonalCropStress](https://github.com/TheCodingDad-TisonK/FS25_SeasonalCropStress) | Field moisture and crop stress data |
| [FS25_SoilFertilizer](https://github.com/TheCodingDad-TisonK/FS25_SoilFertilizer) | Per-field nutrient levels |

---

## Known Limitations

- **Workshop app** shows vehicles within 20 m — walk closer if nothing appears
- **Field Status** and **Animal Husbandry** rely on standard FS25 APIs; modded maps with non-standard field/animal setup may show incomplete data
- **Mod integration apps** only appear if the matching mod is loaded — if you add a mod mid-session, restart the game to register its app

---

## License

[CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) — All rights reserved.
No redistribution or modification without written permission from the author.
# Contributing to FS25_MarketDynamics

## Branch Structure

| Branch | Owner | Purpose |
|--------|-------|---------|
| `main` | — | Stable releases only. No direct commits. |
| `dev-1` | tison | Core systems: engine, events, futures, serializer |
| `dev-2` | LeGrizzly | GUI systems: MarketScreen, HUD, FuturesDialog |

Both branches PR into `main`. All PRs require at least one review before merging.

## Development Setup

1. Clone the repo into your FS25 mods workspace
2. Build: `bash build.sh`
3. Deploy for testing: `bash build.sh --deploy`
4. Check `log.txt` for `[MDM]` prefixed lines after deploying

## Coding Standards

- Lua 5.1 only (FS25 constraint) — no `goto`, no `continue`, no `os.time()`
- No slider widgets — use `MultiTextOption` or quick buttons
- All log output via `MDMLog.info()` / `MDMLog.warn()` / `MDMLog.error()`
- Max file size: **1500 lines** — split into submodules if exceeded
- No `math.sqrt` in `update()` — use distance-squared checks
- Images from ZIP: always set dynamically via `setImageFilename()`, never in XML

## GUI Notes (LeGrizzly)

- Coordinate system: **bottom-left origin**, Y=0 at bottom, increases upward
- Dialog Y values are **negative** going down from the top of the dialog
- Copy `TakeLoanDialog.xml` structure for new dialogs
- Use 3-layer button pattern: Bitmap bg + Button hit area + Text label
- Set mod image paths in `onCreate()` via `setImageFilename(g_currentModDirectory .. "path")`

## Pull Request Checklist

- [ ] Tested in-game with `bash build.sh --deploy`
- [ ] No `[MDM] ERROR` lines in log.txt
- [ ] No Lua 5.1 incompatible syntax
- [ ] File stays under 1500 lines
- [ ] PR description explains what changed and why

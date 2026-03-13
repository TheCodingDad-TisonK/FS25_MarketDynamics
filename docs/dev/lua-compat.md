# Lua Compatibility — FS25 / Lua 5.1 Gotchas

FS25 runs Lua 5.1. Several patterns from modern Lua or other languages don't work.
This page documents what breaks and what to use instead.

---

## Language Restrictions

### No `goto` / `continue`

`goto` was introduced in Lua 5.2. FS25 doesn't have it.

```lua
-- BROKEN
for i = 1, 10 do
    if someCondition then goto continue end
    doWork(i)
    ::continue::
end

-- CORRECT — use if/else or early return
for i = 1, 10 do
    if not someCondition then
        doWork(i)
    end
end
```

### No `os.time()` / `os.date()`

The FS25 sandbox blocks OS time functions. Use game time instead.

```lua
-- BROKEN
local now = os.time()

-- CORRECT
local now = g_currentMission and g_currentMission.time or 0
```

`g_currentMission.time` is in milliseconds of in-game time elapsed since mission start.

---

## FS25 API Restrictions

### No Slider Widgets

Slider UI elements don't function correctly in FS25. Use alternatives:

```lua
-- BROKEN
local slider = self.root:getDescendantByName("mySlider")

-- CORRECT — use MultiTextOption for discrete steps
local option = self.root:getDescendantByName("myOption")
-- or use simple +/- button pairs
```

### `imageFilename` Doesn't Work for Mod Images in XML

Setting `imageFilename` in XML layout for mod-local images silently fails.
Set it in code instead:

```lua
-- BROKEN (in XML): imageFilename="$l10n_..."

-- CORRECT (in Lua onCreate callback):
local img = self.root:getDescendantByName("myImage")
img:setImageFilename(self.modDirectory .. "gui/textures/myIcon.png")
```

### `setTextColorByName()` Doesn't Exist

```lua
-- BROKEN
label:setTextColorByName("red")

-- CORRECT
label:setTextColor(1, 0, 0, 1)  -- r, g, b, a
```

---

## Performance Rules

### No `math.sqrt` in `update()`

Square root is expensive and called every frame. Use distance-squared comparisons.

```lua
-- BROKEN — in update()
local dist = math.sqrt((x2-x1)^2 + (y2-y1)^2)
if dist < threshold then ...

-- CORRECT
local distSq = (x2-x1)^2 + (y2-y1)^2
if distSq < threshold * threshold then ...
```

---

## FS25 Global APIs — Check Before Using

Always verify these in the reference docs before use. APIs change between FS versions
and community docs may lag behind.

| API | Notes |
|-----|-------|
| `g_currentMission.*` | Check field exists — not all fields present in all mission states |
| `g_fillTypeManager` | Safe after `loadMission00Finished`; not available during `load` |
| `g_farmManager` | Same timing as above |
| `g_currentMission.economyManager` | Available post-load; use for base price queries |
| `SellingStation` | Check community LUADOC for current sell price method signatures |
| `MoneyType` | Check valid enum values — `MoneyType.OTHER` is safe for custom payouts |
| GUI/dialog system | Highly version-sensitive; always test in-game |

Reference paths (local to development machine):
- `C:\Users\tison\Desktop\FS25 MODS\FS25-Community-LUADOC`
- `C:\Users\tison\Desktop\FS25 MODS\FS25-lua-scripting`

---

## Quick Reference Table

| Pattern | Broken | Use Instead |
|---------|--------|-------------|
| `goto` / `continue` | ✗ | `if/else` or early `return` |
| `os.time()` | ✗ | `g_currentMission.time` |
| `os.date()` | ✗ | Not available; derive from game time |
| Slider widgets | ✗ | `MultiTextOption` or ± buttons |
| XML `imageFilename` for mod assets | ✗ | `setImageFilename()` in `onCreate()` |
| `setTextColorByName()` | ✗ | `setTextColor(r, g, b, a)` |
| `math.sqrt` in `update()` | ⚠ slow | Distance-squared comparison |
| Bitwise operators (`&`, `\|`, `~`) | ✗ | `bit.band()`, `bit.bor()`, `bit.bnot()` |
| Integer division `//` | ✗ | `math.floor(a / b)` |

---

## See Also

- [Architecture](architecture.md) — Game hook patterns and safe API usage timing
- [Event Authoring](event-authoring.md) — Safe patterns used in existing events

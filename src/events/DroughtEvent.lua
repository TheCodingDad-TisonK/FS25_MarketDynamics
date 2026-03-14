-- DroughtEvent.lua
-- A drought in a major producing region — pushes grain prices up.
-- Intensity 0-1 maps to +10%..+35% price boost on affected crops.
--
-- Author: tison (dev-1)

local EVENT_ID = "drought"

-- Affected fill types (by name — resolved to index at runtime)
local AFFECTED_CROPS = { "wheat", "barley", "canola", "corn", "sunflower" }

local function onFire(intensity)
    if not g_MarketDynamics then return end

    local factor = 1.10 + intensity * 0.25  -- 1.10x to 1.35x

    for _, cropName in ipairs(AFFECTED_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:addModifier({
                id            = EVENT_ID .. "_" .. cropName,
                fillTypeIndex = fillType.index,
                factor        = factor,
                durationMs    = 15 * 60 * 1000,  -- 15 in-game minutes
            })
        end
    end

    MDMLog.info("DroughtEvent fired — price factor " .. string.format("%.2f", factor))
end

local function onExpire(intensity)
    if not g_MarketDynamics then return end

    for _, cropName in ipairs(AFFECTED_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:removeModifierById(fillType.index, EVENT_ID .. "_" .. cropName)
        end
    end
end

-- Deferred registration (coordinator may not exist yet at source() time)
MarketDynamics.pendingEventRegistrations = MarketDynamics.pendingEventRegistrations or {}
table.insert(MarketDynamics.pendingEventRegistrations, {
    id             = EVENT_ID,
    name           = "Regional Drought",
    probability    = 0.08,
    minIntensity   = 0.2,
    maxIntensity   = 1.0,
    cooldownMs     = 30 * 60 * 1000,
    minDurationMs  = 10 * 60 * 1000,   -- 10–20 in-game minutes
    maxDurationMs  = 20 * 60 * 1000,
    onFire         = onFire,
    onExpire       = onExpire,
})

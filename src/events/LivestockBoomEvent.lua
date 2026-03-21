-- LivestockBoomEvent.lua
-- A surge in demand for livestock feed as regional herds expand.
--
-- Intensity 0-1 maps to a +15%..+40% price boost:
--   factor = 1.15 + intensity * 0.25
--
-- Affected crops: GRASS, SILAGE, MAIZE (CORN)
-- Duration: 20-40 in-game minutes | Cooldown: 90 in-game minutes | p = 0.04
--
-- Author: tison (dev-1)

local EVENT_ID = "livestock_boom"

local AFFECTED_CROPS = { "GRASS_WINDROW", "SILAGE", "MAIZE" }

local function onFire(intensity)
    if not g_MarketDynamics then return end

    local factor = 1.15 + intensity * 0.25  -- 1.15x to 1.40x

    for _, cropName in ipairs(AFFECTED_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName)
        if fillType then
            g_MarketDynamics.marketEngine:addModifier({
                id            = EVENT_ID .. "_" .. cropName,
                fillTypeIndex = fillType.index,
                factor        = factor,
            })
        end
    end

    MDMLog.info("LivestockBoomEvent fired — forage crops up " .. math.floor((factor - 1) * 100) .. "%")
end

local function onExpire(intensity)
    if not g_MarketDynamics then return end

    for _, cropName in ipairs(AFFECTED_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName)
        if fillType then
            g_MarketDynamics.marketEngine:removeModifierById(fillType.index, EVENT_ID .. "_" .. cropName)
        end
    end
end

-- Deferred registration
MDM_pendingRegistrations = MDM_pendingRegistrations or {}
table.insert(MDM_pendingRegistrations, {
    id             = EVENT_ID,
    nameKey        = "mdm_event_livestock_boom",
    name           = "Livestock Feed Boom",
    probability    = 0.04,
    minIntensity   = 0.4,
    maxIntensity   = 1.0,
    cooldownMs     = 90 * 60 * 1000,   -- 1.5 hours
    minDurationMs  = 20 * 60 * 1000,   -- 20-40 minutes
    maxDurationMs  = 40 * 60 * 1000,
    onFire         = onFire,
    onExpire       = onExpire,
})

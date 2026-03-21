-- PestOutbreakEvent.lua
-- A sudden blight or pest infestation in a major root-crop region.
-- Affects Potato and Sugarbeet prices significantly as supply collapses.
--
-- Intensity 0-1 maps to a +20%..+60% price boost:
--   factor = 1.20 + intensity * 0.40
--
-- Affected crops: POTATO, SUGARBEET
-- Duration: 15-30 in-game minutes | Cooldown: 60 in-game minutes | p = 0.05
--
-- Author: tison (dev-1)

local EVENT_ID = "pest_outbreak"

local AFFECTED_CROPS = { "POTATO", "SUGARBEET" }

local function onFire(intensity)
    if not g_MarketDynamics then return end

    local factor = 1.20 + intensity * 0.40  -- 1.20x to 1.60x

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

    MDMLog.info("PestOutbreakEvent fired — root crops up " .. math.floor((factor - 1) * 100) .. "%")
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
    nameKey        = "mdm_event_pest_outbreak",
    name           = "Root Crop Blight",
    probability    = 0.05,
    minIntensity   = 0.3,
    maxIntensity   = 1.0,
    cooldownMs     = 60 * 60 * 1000,   -- 1 hour
    minDurationMs  = 15 * 60 * 1000,   -- 15-30 minutes
    maxDurationMs  = 30 * 60 * 1000,
    onFire         = onFire,
    onExpire       = onExpire,
})

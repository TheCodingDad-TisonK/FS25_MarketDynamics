-- DroughtEvent.lua
-- A regional drought in a major producing area cuts supply — grain prices rise.
--
-- Intensity 0-1 maps to a +10%..+35% price boost on affected crops:
--   factor = 1.10 + intensity * 0.25   (1.10x at min, 1.35x at max)
--
-- Affected crops: wheat, barley, canola, corn, sunflower
-- Duration: 10-20 in-game minutes | Cooldown: 30 in-game minutes | p = 0.08
--
-- Author: tison (dev-1)

local EVENT_ID = "drought"

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
            })
        end
    end

    MDMLog.info("DroughtEvent fired — factor " .. string.format("%.2f", factor))
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

-- Deferred registration: MDM_pendingRegistrations is a standalone global that exists
-- before MarketDynamics is sourced. The coordinator drains it in _registerDefaultEvents().
MDM_pendingRegistrations = MDM_pendingRegistrations or {}
table.insert(MDM_pendingRegistrations, {
    id             = EVENT_ID,
    name           = "Regional Drought",
    probability    = 0.08,
    minIntensity   = 0.2,
    maxIntensity   = 1.0,
    cooldownMs     = 30 * 60 * 1000,
    minDurationMs  = 10 * 60 * 1000,   -- 10-20 in-game minutes
    maxDurationMs  = 20 * 60 * 1000,
    onFire         = onFire,
    onExpire       = onExpire,
})

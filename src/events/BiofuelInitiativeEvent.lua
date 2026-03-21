-- BiofuelInitiativeEvent.lua
-- A government-led initiative to boost biofuel production.
-- Increases demand and price for oilseeds and ethanol-friendly crops.
--
-- Intensity 0-1 maps to a +25%..+50% price boost:
--   factor = 1.25 + intensity * 0.25
--
-- Affected crops: CANOLA, SUNFLOWER, SUGARBEET
-- Duration: 30-60 in-game minutes | Cooldown: 120 in-game minutes | p = 0.03
--
-- Author: tison (dev-1)

local EVENT_ID = "biofuel_initiative"

local AFFECTED_CROPS = { "CANOLA", "SUNFLOWER", "SUGARBEET" }

local function onFire(intensity)
    if not g_MarketDynamics then return end

    local factor = 1.25 + intensity * 0.25  -- 1.25x to 1.50x

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

    MDMLog.info("BiofuelInitiativeEvent fired — energy crops up " .. math.floor((factor - 1) * 100) .. "%")
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
    nameKey        = "mdm_event_biofuel_initiative",
    name           = "Biofuel Initiative",
    probability    = 0.03,
    minIntensity   = 0.5,
    maxIntensity   = 1.0,
    cooldownMs     = 120 * 60 * 1000,   -- 2 hours
    minDurationMs  = 30 * 60 * 1000,   -- 30-60 minutes
    maxDurationMs  = 60 * 60 * 1000,
    onFire         = onFire,
    onExpire       = onExpire,
})

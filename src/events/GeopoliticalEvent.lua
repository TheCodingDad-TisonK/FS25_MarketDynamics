-- GeopoliticalEvent.lua
-- Geopolitical instability (conflict, sanctions, policy shock).
-- Spikes energy-adjacent crops (canola/sunflower for bio-fuel) and wheat (staple demand).
--
-- Author: tison (dev-1)

local EVENT_ID = "geopolitical"

local STAPLE_CROPS = { "wheat", "barley" }
local ENERGY_CROPS = { "canola", "sunflower" }

local function onFire(intensity)
    if not g_MarketDynamics then return end

    local stapleFactor = 1.15 + intensity * 0.30  -- 1.15x to 1.45x
    local energyFactor = 1.20 + intensity * 0.35  -- 1.20x to 1.55x

    for _, cropName in ipairs(STAPLE_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:addModifier({
                id            = EVENT_ID .. "_" .. cropName,
                fillTypeIndex = fillType.index,
                factor        = stapleFactor,
                durationMs    = 20 * 60 * 1000,
            })
        end
    end

    for _, cropName in ipairs(ENERGY_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:addModifier({
                id            = EVENT_ID .. "_" .. cropName,
                fillTypeIndex = fillType.index,
                factor        = energyFactor,
                durationMs    = 20 * 60 * 1000,
            })
        end
    end

    MDMLog.info("GeopoliticalEvent fired — staple " .. string.format("%.2f", stapleFactor) ..
        " energy " .. string.format("%.2f", energyFactor))
end

local function onExpire(intensity)
    if not g_MarketDynamics then return end

    local allCrops = {}
    for _, c in ipairs(STAPLE_CROPS) do table.insert(allCrops, c) end
    for _, c in ipairs(ENERGY_CROPS)  do table.insert(allCrops, c) end

    for _, cropName in ipairs(allCrops) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:removeModifierById(fillType.index, EVENT_ID .. "_" .. cropName)
        end
    end
end

MarketDynamics.pendingEventRegistrations = MarketDynamics.pendingEventRegistrations or {}
table.insert(MarketDynamics.pendingEventRegistrations, {
    id           = EVENT_ID,
    name         = "Geopolitical Crisis",
    probability  = 0.04,
    minIntensity = 0.4,
    maxIntensity = 1.0,
    cooldownMs   = 60 * 60 * 1000,
    onFire       = onFire,
    onExpire     = onExpire,
})

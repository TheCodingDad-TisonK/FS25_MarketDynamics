-- TradeDisruptionEvent.lua
-- A trade disruption (export ban, port strike, logistics collapse).
-- Random subset of crops affected — could go up OR down depending on region role.
--
-- Author: tison (dev-1)

local EVENT_ID = "trade_disruption"

local ALL_CROPS = { "wheat", "barley", "canola", "corn", "sunflower", "soybean", "oat" }

local function onFire(intensity)
    if not g_MarketDynamics then return end

    -- Trade disruptions are chaotic — affect a random subset and push prices up
    local factor = 1.05 + intensity * 0.20  -- 1.05x to 1.25x

    for _, cropName in ipairs(ALL_CROPS) do
        if math.random() < 0.5 then  -- 50% chance each crop is affected
            local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
            if fillType then
                g_MarketDynamics.marketEngine:addModifier({
                    id            = EVENT_ID .. "_" .. cropName,
                    fillTypeIndex = fillType.index,
                    factor        = factor,
                    durationMs    = 8 * 60 * 1000,
                })
            end
        end
    end

    MDMLog.info("TradeDisruptionEvent fired — factor " .. string.format("%.2f", factor))
end

local function onExpire(intensity)
    if not g_MarketDynamics then return end

    for _, cropName in ipairs(ALL_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName:upper())
        if fillType then
            g_MarketDynamics.marketEngine:removeModifierById(fillType.index, EVENT_ID .. "_" .. cropName)
        end
    end
end

MarketDynamics.pendingEventRegistrations = MarketDynamics.pendingEventRegistrations or {}
table.insert(MarketDynamics.pendingEventRegistrations, {
    id           = EVENT_ID,
    name         = "Trade Disruption",
    probability  = 0.06,
    minIntensity = 0.3,
    maxIntensity = 1.0,
    cooldownMs   = 40 * 60 * 1000,
    onFire       = onFire,
    onExpire     = onExpire,
})

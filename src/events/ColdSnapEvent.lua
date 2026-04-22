-- ColdSnapEvent.lua
-- An unexpected cold snap / early frost hits during the growing season,
-- damaging standing crops in the field and tightening supply.
--
-- Mixed-direction event — the first in the mod to push some crops UP and
-- others DOWN in the same firing:
--
--   Boosted (supply damaged):
--     WHEAT, BARLEY, CANOLA, SUNFLOWER, SOYBEAN
--     factor = 1.12 + intensity * 0.28   (+12%..+40%)
--
--   Suppressed (frozen forage dumped onto market as farmers salvage early):
--     SILAGE, GRASS_WINDROW
--     factor = 0.88 - intensity * 0.12   (-12%..-24%)
--
-- Intensity 0-1 | Duration: 12-22 min | Cooldown: 50 min | p = 0.06
--
-- Uses getExtraData/onLoad so that the exact affected sets survive a
-- save/load cycle (mirrors TradeDisruptionEvent pattern).
--
-- Author: tison (dev-1)

local EVENT_ID = "cold_snap"

local BOOST_CROPS    = { "WHEAT", "BARLEY", "CANOLA", "SUNFLOWER", "SOYBEAN" }
local SUPPRESS_CROPS = { "SILAGE", "GRASS_WINDROW" }

-- Per-firing state: track what was actually applied so onExpire is clean.
local _boostedApplied    = {}
local _suppressedApplied = {}

local function _applyModifiers(intensity)
    local boostFactor    = 1.12 + intensity * 0.28  -- 1.12x to 1.40x
    local suppressFactor = 0.88 - intensity * 0.12  -- 0.88x to 0.76x

    _boostedApplied    = {}
    _suppressedApplied = {}

    for _, cropName in ipairs(BOOST_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName)
        if fillType then
            g_MarketDynamics.marketEngine:addModifier({
                id            = EVENT_ID .. "_boost_" .. cropName,
                fillTypeIndex = fillType.index,
                factor        = boostFactor,
            })
            _boostedApplied[#_boostedApplied + 1] = cropName
        end
    end

    for _, cropName in ipairs(SUPPRESS_CROPS) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName)
        if fillType then
            g_MarketDynamics.marketEngine:addModifier({
                id            = EVENT_ID .. "_supp_" .. cropName,
                fillTypeIndex = fillType.index,
                factor        = suppressFactor,
            })
            _suppressedApplied[#_suppressedApplied + 1] = cropName
        end
    end

    MDMLog.info(string.format(
        "ColdSnapEvent applied — boost x%.2f on %d crops, suppress x%.2f on %d crops",
        boostFactor, #_boostedApplied, suppressFactor, #_suppressedApplied))
end

local function _removeModifiers()
    for _, cropName in ipairs(_boostedApplied) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName)
        if fillType then
            g_MarketDynamics.marketEngine:removeModifierById(fillType.index, EVENT_ID .. "_boost_" .. cropName)
        end
    end
    for _, cropName in ipairs(_suppressedApplied) do
        local fillType = g_fillTypeManager:getFillTypeByName(cropName)
        if fillType then
            g_MarketDynamics.marketEngine:removeModifierById(fillType.index, EVENT_ID .. "_supp_" .. cropName)
        end
    end
    _boostedApplied    = {}
    _suppressedApplied = {}
end

local function onFire(intensity)
    if not g_MarketDynamics then return end
    _applyModifiers(intensity)
end

local function onExpire(intensity)
    if not g_MarketDynamics then return end
    _removeModifiers()
end

-- Deterministic restore from save — re-applies modifiers using saved intensity
-- and crop lists from extraData rather than re-rolling.
-- extraData format: "b:WHEAT,BARLEY|s:SILAGE,GRASS_WINDROW"
local function onLoad(intensity, extraData)
    if not g_MarketDynamics then return end

    _boostedApplied    = {}
    _suppressedApplied = {}

    local boostFactor    = 1.12 + intensity * 0.28
    local suppressFactor = 0.88 - intensity * 0.12

    -- Parse boost section
    local boostStr    = (extraData or ""):match("b:([^|]*)")
    local suppressStr = (extraData or ""):match("s:(.*)")

    if boostStr then
        for cropName in boostStr:gmatch("[^,]+") do
            local fillType = g_fillTypeManager:getFillTypeByName(cropName)
            if fillType then
                g_MarketDynamics.marketEngine:addModifier({
                    id            = EVENT_ID .. "_boost_" .. cropName,
                    fillTypeIndex = fillType.index,
                    factor        = boostFactor,
                })
                _boostedApplied[#_boostedApplied + 1] = cropName
            end
        end
    end

    if suppressStr then
        for cropName in suppressStr:gmatch("[^,]+") do
            local fillType = g_fillTypeManager:getFillTypeByName(cropName)
            if fillType then
                g_MarketDynamics.marketEngine:addModifier({
                    id            = EVENT_ID .. "_supp_" .. cropName,
                    fillTypeIndex = fillType.index,
                    factor        = suppressFactor,
                })
                _suppressedApplied[#_suppressedApplied + 1] = cropName
            end
        end
    end

    MDMLog.info(string.format(
        "ColdSnapEvent restored — %d boosted, %d suppressed from save",
        #_boostedApplied, #_suppressedApplied))
end

local function getExtraData()
    return "b:" .. table.concat(_boostedApplied, ",") ..
           "|s:" .. table.concat(_suppressedApplied, ",")
end

MDM_pendingRegistrations = MDM_pendingRegistrations or {}
table.insert(MDM_pendingRegistrations, {
    id             = EVENT_ID,
    nameKey        = "mdm_event_cold_snap",
    name           = "Cold Snap",
    probability    = 0.06,
    minIntensity   = 0.2,
    maxIntensity   = 1.0,
    cooldownMs     = 50 * 60 * 1000,    -- 50 in-game minutes
    minDurationMs  = 12 * 60 * 1000,   -- 12-22 in-game minutes
    maxDurationMs  = 22 * 60 * 1000,
    onFire         = onFire,
    onExpire       = onExpire,
    onLoad         = onLoad,
    getExtraData   = getExtraData,
})

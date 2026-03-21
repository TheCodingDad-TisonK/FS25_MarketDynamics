-- UPIntegration.lua
-- Optional integration layer with FS25_UsedPlus (XelaNull).
-- API version targeted: v1.1.0 (FS25_UsedPlus v2.15.4.96)
--
-- When UsedPlus is installed AND the player enables "UP mode", this module:
--   1. Registers MDM futures contracts as external deals → affects credit score
--   2. Reports fulfilled/defaulted contracts → credit score up/down
--   3. Reads credit score at contract creation → scales MDM default penalty rate
--   4. Applies world event market modifiers → affects used equipment prices
--
-- All UsedPlusAPI calls are server-only (g_currentMission.isServer guard).
-- See: https://github.com/XelaNull/FS25_UsedPlus/issues/40
--
-- Author: tison (dev-1)

UPIntegration = {}

-- ---------------------------------------------------------------------------
-- Config
-- ---------------------------------------------------------------------------

-- Credit score thresholds for penalty scaling.
local CREDIT_TIER_EXCELLENT = 750
local CREDIT_TIER_POOR      = 600

local PENALTY_MOD_EXCELLENT = 0.67  -- 10% effective penalty  (vs default 15%)
local PENALTY_MOD_POOR      = 1.33  -- 20% effective penalty  (vs default 15%)
local PENALTY_MOD_DEFAULT   = 1.0   -- 15% — used when UP not active or score unknown

-- Used equipment price multiplier per world event ID.
-- Maps intensity (0-1) to a multiplier passed to getAPI().applyMarketModifier().
-- Clamped 0.5-2.0 by the UP API — our ranges are well within that.
local EVENT_MODIFIERS = {
    drought           = function(i) return 1.0 + i * 0.20 end,  -- +0-20%: farmers need equipment
    geopolitical      = function(i) return 1.0 + i * 0.15 end,  -- +0-15%: can't source new
    trade_disruption  = function(i) return 1.0 + i * 0.12 end,  -- +0-12%: used > new
    bumper_harvest    = function(i) return 1.0 + i * 0.10 end,  -- +0-10%: flush cash, buying
    biofuel_initiative= function(i) return 1.0 + i * 0.08 end,  -- +0-8%: expanding operations
    livestock_boom    = function(i) return 1.0 + i * 0.08 end,  -- +0-8%: need more equipment
    pest_outbreak     = function(i) return 1.0 - i * 0.08 end,  -- -0-8%: economic stress, selling
}

-- Modifier key prefix used to build the UP modifier ID: "MarketDynamics_<eventId>"
local MOD_NAME = "MarketDynamics"

-- ---------------------------------------------------------------------------
-- API accessor
-- Primary path: g_currentMission.usedPlusAPI (shipped in UP v2.15.4.96).
-- Fallback:     bare UsedPlusAPI global (rawset _G path, older versions).
-- ---------------------------------------------------------------------------
local function getAPI()
    return (g_currentMission and g_currentMission.usedPlusAPI) or UsedPlusAPI
end

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------

local _enabled = false  -- user opt-in (persisted via MarketSerializer)

-- Maps contractId → upDealId returned by getAPI().registerExternalDeal().
-- Persisted by save/load so we can report payments/defaults across sessions.
local _dealIds = {}

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

function UPIntegration.isAvailable()
    if g_modManager:getModByName("FS25_UsedPlus") == nil then return false end
    -- Also verify the API object is actually present (timing: checked after mission load)
    return getAPI() ~= nil
end

function UPIntegration.isEnabled()
    return UPIntegration.isAvailable() and _enabled
end

function UPIntegration.setEnabled(val)
    _enabled = val == true
    MDMLog.info("UPIntegration: UP mode " .. (_enabled and "ENABLED" or "DISABLED"))
end

-- Called from MarketDynamics:onMissionLoaded.
function UPIntegration.init()
    if not UPIntegration.isAvailable() then
        MDMLog.info("UPIntegration: FS25_UsedPlus not detected — integration inactive")
        return
    end

    local upMod   = g_modManager:getModByName("FS25_UsedPlus")
    local version = (upMod and upMod.version) or "?"
    MDMLog.info("UPIntegration: FS25_UsedPlus detected (v" .. version .. ")")

    if _enabled then
        MDMLog.info("UPIntegration: UP mode active — credit bridge and market modifiers enabled")
    else
        MDMLog.info("UPIntegration: UP mode inactive — use 'mdmUPMode on' or Settings to enable")
    end
end

-- Save UP mode state and deal ID map. Called from MarketSerializer.
function UPIntegration.save(xmlFile, baseKey)
    setXMLBool(xmlFile, baseKey .. "#upMode", _enabled)

    local i = 0
    for contractId, upDealId in pairs(_dealIds) do
        local base = baseKey .. ".dealIds.entry(" .. i .. ")"
        setXMLInt(xmlFile, base .. "#contractId", contractId)
        setXMLInt(xmlFile, base .. "#upDealId",   upDealId)
        i = i + 1
    end
end

-- Load UP mode state and deal ID map. Called from MarketSerializer.
function UPIntegration.load(xmlFile, baseKey)
    local val = getXMLBool(xmlFile, baseKey .. "#upMode")
    _enabled  = val == true

    _dealIds = {}
    local i = 0
    while true do
        local base       = baseKey .. ".dealIds.entry(" .. i .. ")"
        local contractId = getXMLInt(xmlFile, base .. "#contractId")
        if not contractId then break end
        local upDealId   = getXMLInt(xmlFile, base .. "#upDealId")
        if upDealId then
            _dealIds[contractId] = upDealId
        end
        i = i + 1
    end

    MDMLog.info("UPIntegration: loaded upMode=" .. tostring(_enabled) ..
        ", dealIds=" .. i)
end

-- Post-load re-registration pass for active contracts.
-- Called from MarketDynamics:onStartMission after serializer:load().
-- Registers any active contract that has no persisted upDealId (e.g. save predating
-- the integration, or a dealId that was lost). Skips contracts already registered.
-- registerExternalDeal() is idempotent on the UP side — safe to re-call.
function UPIntegration.reregisterActiveContracts(contracts)
    if not UPIntegration.isEnabled() then return end
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    local count = 0
    for _, contract in pairs(contracts) do
        if contract.status == "active" and not _dealIds[contract.id] then
            local upDealId = getAPI().registerExternalDeal(
                MOD_NAME, contract.id, contract.farmId, {
                    dealType       = "futures",
                    itemName       = contract.fillTypeName .. " Futures Contract",
                    originalAmount = contract.quantity * contract.lockedPrice,
                    monthlyPayment = 0,
                })
            if upDealId then
                _dealIds[contract.id] = upDealId
                count = count + 1
            else
                MDMLog.warn("UPIntegration: re-registration returned nil for contract #" .. contract.id)
            end
        end
    end

    if count > 0 then
        MDMLog.info("UPIntegration: re-registered " .. count .. " active contract(s) after load")
    end
end

-- ---------------------------------------------------------------------------
-- Futures contract hooks (called from FuturesMarket)
-- ---------------------------------------------------------------------------

-- Called when a futures contract is created.
function UPIntegration.onContractCreated(contractId, farmId, params)
    if not UPIntegration.isEnabled() then return end
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    local upDealId = getAPI().registerExternalDeal(
        MOD_NAME, contractId, farmId, {
            dealType       = "futures",
            itemName       = params.fillTypeName .. " Futures Contract",
            originalAmount = params.quantity * params.lockedPrice,
            monthlyPayment = 0,
        })

    if upDealId then
        _dealIds[contractId] = upDealId
        MDMLog.info("UPIntegration: registered deal #" .. upDealId ..
            " for contract #" .. contractId)
    else
        MDMLog.warn("UPIntegration: registerExternalDeal returned nil for contract #" .. contractId)
    end
end

-- Called when a futures contract is fulfilled (full delivery on time).
function UPIntegration.onContractFulfilled(contractId, farmId, payoutAmount)
    if not UPIntegration.isEnabled() then return end
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    local upDealId = _dealIds[contractId]
    if not upDealId then
        MDMLog.warn("UPIntegration: no upDealId for fulfilled contract #" .. contractId)
        return
    end

    getAPI().reportExternalPayment(upDealId, payoutAmount)
    getAPI().closeExternalDeal(upDealId, "fulfilled")
    _dealIds[contractId] = nil
    MDMLog.info("UPIntegration: reported fulfillment for deal #" .. upDealId)
end

-- Called when a futures contract is defaulted (delivery missed or short).
function UPIntegration.onContractDefaulted(contractId, farmId, penaltyAmount)
    if not UPIntegration.isEnabled() then return end
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    local upDealId = _dealIds[contractId]
    if not upDealId then
        MDMLog.warn("UPIntegration: no upDealId for defaulted contract #" .. contractId)
        return
    end

    getAPI().reportExternalDefault(upDealId, false)
    getAPI().closeExternalDeal(upDealId, "defaulted")
    _dealIds[contractId] = nil
    MDMLog.info("UPIntegration: reported default for deal #" .. upDealId)
end

-- Returns a penalty multiplier based on the player's credit score.
-- Applied to FuturesMarket's DEFAULT_PENALTY at contract settlement.
--   Excellent credit (750+) → 0.67× → effective ~10% penalty
--   Normal credit (600-749) → 1.0×  → effective ~15% penalty
--   Poor credit   (<600)    → 1.33× → effective ~20% penalty
-- Returns 1.0 (no change) when UP is not active or score is unavailable.
function UPIntegration.getPenaltyModifier(farmId)
    if not UPIntegration.isEnabled() then return PENALTY_MOD_DEFAULT end

    local score = UPIntegration.getCreditScore(farmId)
    if not score then return PENALTY_MOD_DEFAULT end

    if score >= CREDIT_TIER_EXCELLENT then
        return PENALTY_MOD_EXCELLENT
    elseif score < CREDIT_TIER_POOR then
        return PENALTY_MOD_POOR
    end
    return PENALTY_MOD_DEFAULT
end

-- Returns the player's current credit score (300-850), or nil if unavailable.
function UPIntegration.getCreditScore(farmId)
    if not UPIntegration.isEnabled() then return nil end
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return nil end
    return getAPI().getCreditScore(farmId)
end

-- ---------------------------------------------------------------------------
-- World event hooks (called from WorldEventSystem)
-- ---------------------------------------------------------------------------

-- Called when a world event fires (or is restored from savegame).
-- durationMs is the remaining active duration in game milliseconds.
function UPIntegration.onWorldEventFired(eventId, intensity, durationMs)
    if not UPIntegration.isEnabled() then return end
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    local modFn = EVENT_MODIFIERS[eventId]
    if not modFn then
        MDMLog.debug("UPIntegration: no UP modifier mapping for event '" .. eventId .. "' — skipped")
        return
    end

    local multiplier    = modFn(intensity)
    local durationHours = durationMs / (60 * 60 * 1000)

    getAPI().applyMarketModifier(
        MOD_NAME, eventId, multiplier, durationHours, "ALL",
        "MDM: " .. eventId)

    MDMLog.info(string.format(
        "UPIntegration: applied market modifier '%s' — x%.3f for %.1fh",
        eventId, multiplier, durationHours))
end

-- Called when a world event expires.
function UPIntegration.onWorldEventExpired(eventId)
    if not UPIntegration.isEnabled() then return end
    if g_currentMission and g_currentMission.isClient and not g_currentMission.isServer then return end

    if not EVENT_MODIFIERS[eventId] then return end

    getAPI().removeMarketModifier(MOD_NAME .. "_" .. eventId)
    MDMLog.info("UPIntegration: removed market modifier for '" .. eventId .. "'")
end

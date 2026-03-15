-- UPIntegration.lua
-- Optional integration layer with FS25_UsedPlus (XelaNull).
--
-- When UsedPlus is installed AND the player enables "UP mode", this module will:
--   1. Register MDM futures contracts as external deals in UsedPlus's credit system
--   2. Report fulfilled contracts as successful payments → credit score up
--   3. Report defaulted contracts as missed payments → credit score down
--   4. Read the player's credit score to scale the MDM default penalty rate
--      (higher credit = lower penalty, lower credit = higher penalty)
--
-- STUB STATUS: Integration points are defined but not yet wired to UsedPlusAPI.
-- Awaiting architecture confirmation from XelaNull before filling in API calls.
-- See: https://github.com/XelaNull/FS25_UsedPlus/issues/40
--
-- Detection: g_modManager:getModByName("FS25_UsedPlus")
-- Author: tison (dev-1)

UPIntegration = {}

-- ---------------------------------------------------------------------------
-- Config
-- ---------------------------------------------------------------------------

-- Credit score thresholds for penalty scaling.
-- When UsedPlusAPI is wired in, getPenaltyModifier() will use these.
local CREDIT_TIER_EXCELLENT = 750   -- penalty modifier: PENALTY_MOD_EXCELLENT
local CREDIT_TIER_POOR      = 600   -- penalty modifier: PENALTY_MOD_POOR

local PENALTY_MOD_EXCELLENT = 0.67  -- 10% effective penalty  (vs default 15%)
local PENALTY_MOD_POOR      = 1.33  -- 20% effective penalty  (vs default 15%)
local PENALTY_MOD_DEFAULT   = 1.0   -- 15% — used when UP not active or score unknown

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------

local _enabled = false  -- user opt-in (persisted via MarketSerializer)

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- Returns true if FS25_UsedPlus is installed.
function UPIntegration.isAvailable()
    return g_modManager:getModByName("FS25_UsedPlus") ~= nil
end

-- Returns true if UsedPlus is installed AND the player has enabled UP mode.
function UPIntegration.isEnabled()
    return UPIntegration.isAvailable() and _enabled
end

-- Toggle UP mode on or off. Persisted by MarketSerializer.
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
        MDMLog.info("UPIntegration: UP mode active — credit bridge will be applied to futures contracts")
    else
        MDMLog.info("UPIntegration: UP mode inactive — use 'mdmUPMode on' or Settings to enable")
    end
end

-- Save UP mode state. Called from MarketSerializer.
function UPIntegration.save(xmlFile, baseKey)
    setXMLBool(xmlFile, baseKey .. "#upMode", _enabled)
end

-- Load UP mode state. Called from MarketSerializer.
function UPIntegration.load(xmlFile, baseKey)
    local val = getXMLBool(xmlFile, baseKey .. "#upMode")
    _enabled  = val == true
    MDMLog.info("UPIntegration: loaded upMode=" .. tostring(_enabled))
end

-- ---------------------------------------------------------------------------
-- Integration stubs
-- These are called from FuturesMarket once the architecture is confirmed.
-- Each is a safe no-op until UsedPlusAPI calls are wired in.
-- ---------------------------------------------------------------------------

-- Called when a futures contract is created.
-- Future: register as external deal → UsedPlusAPI.registerExternalDeal()
-- params matches FuturesMarket:createContract() input shape.
function UPIntegration.onContractCreated(contractId, farmId, params)
    if not UPIntegration.isEnabled() then return end
    -- TODO: UsedPlusAPI.registerExternalDeal("FS25_MarketDynamics", contractId, farmId, {
    --     dealType      = "futures",
    --     originalAmount = params.quantity * params.lockedPrice,
    --     monthlyPayment = 0,   -- single settlement, not monthly
    -- })
    MDMLog.debug("UPIntegration.onContractCreated: stub — contract #" .. contractId)
end

-- Called when a futures contract is fulfilled (full delivery on time).
-- Future: report successful payment → credit score up via UsedPlusAPI.reportExternalPayment()
function UPIntegration.onContractFulfilled(contractId, farmId, payoutAmount)
    if not UPIntegration.isEnabled() then return end
    -- TODO: UsedPlusAPI.reportExternalPayment(contractId, payoutAmount)
    MDMLog.debug("UPIntegration.onContractFulfilled: stub — contract #" .. contractId
        .. " payout $" .. payoutAmount)
end

-- Called when a futures contract is defaulted (delivery missed or short).
-- Future: report missed payment → credit score down.
-- The API call for this needs confirmation from XelaNull (issue #40).
function UPIntegration.onContractDefaulted(contractId, farmId, penaltyAmount)
    if not UPIntegration.isEnabled() then return end
    -- TODO: UsedPlusAPI.reportMissedPayment(contractId, penaltyAmount)  -- pending API confirmation
    MDMLog.debug("UPIntegration.onContractDefaulted: stub — contract #" .. contractId
        .. " penalty $" .. penaltyAmount)
end

-- Returns a penalty multiplier based on the player's credit score.
-- Applied to FuturesMarket's DEFAULT_PENALTY at contract settlement.
--   Excellent credit (750+) → 0.67× → effective ~10% penalty
--   Normal credit (600-749) → 1.0×  → effective ~15% penalty (unchanged)
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

-- Returns the player's current credit score, or nil if unavailable.
-- Future: UsedPlusAPI.getCreditScore(farmId)
function UPIntegration.getCreditScore(farmId)
    if not UPIntegration.isEnabled() then return nil end
    -- TODO: return UsedPlusAPI.getCreditScore(farmId)
    return nil
end

-- BCIntegration.lua
-- Optional integration layer with FS25_BetterContracts (Mmtrx).
--
-- When BC is installed this module automatically:
--   1. Hooks AbstractMission.finish to detect successful harvest completions
--   2. Applies a short-lived supply-spike price modifier to the harvested crop
--      (large supply hits market → prices dip for ~1 in-game hour)
--   3. Cleans up expired supply-spike modifiers on each update tick
--
-- MDM's futures contract UI remains available alongside BetterContracts —
-- BC harvest jobs and MDM futures contracts serve different purposes and coexist.
--
-- BC detection: g_modManager:getModByName("FS25_BetterContracts")
-- Author: tison (dev-1)

BCIntegration = {}

-- ---------------------------------------------------------------------------
-- Config
-- ---------------------------------------------------------------------------

local SUPPLY_SPIKE_FACTOR    = 0.92   -- -8% price drop on harvest completion
local SUPPLY_SPIKE_DURATION  = 60 * 60 * 1000  -- 1 in-game hour (ms)

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------

local _hooked          = false  -- AbstractMission.finish hook installed?
local _marketEngine    = nil    -- reference set in init()
local _pendingRemovals = {}     -- { fillTypeIndex, modId, expiresAt }

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- Returns true if BetterContracts is installed.
function BCIntegration.isAvailable()
    return g_modManager:getModByName("FS25_BetterContracts") ~= nil
end

-- Always active when BC is installed — no manual opt-in required.
function BCIntegration.isEnabled()
    return BCIntegration.isAvailable()
end

-- Called from MarketDynamics:onMissionLoaded — safe to hook game APIs here.
function BCIntegration.init(marketEngine)
    _marketEngine = marketEngine

    if not BCIntegration.isAvailable() then
        MDMLog.info("BCIntegration: BetterContracts not detected — integration inactive")
        return
    end

    local bcMod   = g_modManager:getModByName("FS25_BetterContracts")
    local version = (bcMod and bcMod.version) or "?"
    MDMLog.info("BCIntegration: BetterContracts detected (v" .. version .. ") — supply reactions active")

    BCIntegration._installHook()
end

-- Called from MarketDynamics:update(dt) every frame.
-- Removes supply-spike modifiers that have expired.
function BCIntegration.update()
    if not BCIntegration.isEnabled() or not _marketEngine then return end

    local now = g_currentMission and g_currentMission.time or 0
    local i = #_pendingRemovals
    while i >= 1 do
        local pending = _pendingRemovals[i]
        if now >= pending.expiresAt then
            _marketEngine:removeModifierById(pending.fillTypeIndex, pending.modId)
            MDMLog.info("BCIntegration: supply spike expired for fillType " .. pending.fillTypeIndex)
            table.remove(_pendingRemovals, i)
        end
        i = i - 1
    end
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

function BCIntegration._installHook()
    if _hooked then return end
    _hooked = true

    AbstractMission.finish = Utils.appendedFunction(
        AbstractMission.finish,
        BCIntegration._onMissionFinish
    )

    MDMLog.info("BCIntegration: AbstractMission.finish hook installed")
end

-- Appended to AbstractMission.finish — receives (self=mission, finishState).
-- Only reacts to successful harvest missions.
function BCIntegration._onMissionFinish(mission, finishState)
    if not BCIntegration.isEnabled() or not _marketEngine then return end

    if finishState ~= MissionFinishState.SUCCESS then return end

    local fruitTypeIndex = nil
    if mission.fruitType and mission.fruitType.index then
        fruitTypeIndex = mission.fruitType.index
    end
    if not fruitTypeIndex then return end

    if not g_fruitTypeManager then return end
    local fillTypeIndex = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex)
    if not fillTypeIndex or fillTypeIndex <= 1 then return end

    if not _marketEngine.prices[fillTypeIndex] then return end

    local now   = g_currentMission and g_currentMission.time or 0
    local modId = "bc_supply_" .. fillTypeIndex .. "_" .. tostring(now)

    _marketEngine:addModifier({
        id            = modId,
        fillTypeIndex = fillTypeIndex,
        factor        = SUPPLY_SPIKE_FACTOR,
    })

    local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
    local name     = fillType and fillType.name or tostring(fillTypeIndex)
    MDMLog.info(string.format(
        "BCIntegration: supply spike applied to %s (-%d pct for 1h)",
        name, math.floor((1 - SUPPLY_SPIKE_FACTOR) * 100)))

    table.insert(_pendingRemovals, {
        fillTypeIndex = fillTypeIndex,
        modId         = modId,
        expiresAt     = now + SUPPLY_SPIKE_DURATION,
    })
end

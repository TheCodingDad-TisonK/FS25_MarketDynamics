-- BCIntegration.lua
-- Optional integration layer with FS25_BetterContracts (Mmtrx).
--
-- When BC is installed AND the player enables "BC mode" (via mdmBCMode console command
-- or future settings UI), this module:
--   1. Hooks AbstractMission.finish to detect successful harvest completions
--   2. Applies a short-lived supply-spike price modifier to the harvested crop
--      (large supply hits market → prices dip for ~1 in-game hour)
--   3. Cleans up expired supply-spike modifiers on each update tick
--
-- MDM's own futures contract UI is suppressed when BC mode is active
-- (g_MarketDynamics.futuresMarket still functions for serialization purposes,
--  but the GUI layer should check BCIntegration.isEnabled() before showing it).
--
-- BC detection: BetterContracts global (set at source time by BC's mod loader)
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

local _enabled         = false  -- user opt-in (persisted via MarketSerializer)
local _hooked          = false  -- AbstractMission.finish hook installed?
local _marketEngine    = nil    -- reference set in init()
local _pendingRemovals = {}     -- { fillTypeIndex, modId, expiresAt }

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- Returns true if BetterContracts is installed.
-- Uses g_modManager — reliable across mod env sandboxing.
function BCIntegration.isAvailable()
    return g_modManager:getModByName("FS25_BetterContracts") ~= nil
end

-- Returns true if BC is installed AND the player has enabled BC mode.
function BCIntegration.isEnabled()
    return BCIntegration.isAvailable() and _enabled
end

-- Toggle BC mode on or off. Persisted by MarketSerializer.
function BCIntegration.setEnabled(val)
    _enabled = val == true
    MDMLog.info("BCIntegration: BC mode " .. (_enabled and "ENABLED" or "DISABLED"))
end

-- Called from MarketDynamics:onMissionLoaded — safe to hook game APIs here.
function BCIntegration.init(marketEngine)
    _marketEngine = marketEngine

    if not BCIntegration.isAvailable() then
        MDMLog.info("BCIntegration: BetterContracts not detected — integration inactive")
        return
    end

    local bcMod = g_modManager:getModByName("FS25_BetterContracts")
    local version = (bcMod and bcMod.version) or "?"
    MDMLog.info("BCIntegration: BetterContracts detected (v" .. version .. ")")

    -- Install hook regardless of _enabled so toggling at runtime works without reload.
    BCIntegration._installHook()

    if _enabled then
        MDMLog.info("BCIntegration: BC mode active — supply reactions enabled, futures UI suppressed")
    else
        MDMLog.info("BCIntegration: BC mode inactive — use 'mdmBCMode on' to enable")
    end
end

-- Called from MarketDynamics:update(dt) every frame.
-- Removes supply-spike modifiers that have expired.
function BCIntegration.update()
    if not _enabled or not _marketEngine then return end

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

-- Save BC mode state. Called from MarketSerializer (xmlFile is an FS25 XML handle).
function BCIntegration.save(xmlFile, baseKey)
    setXMLBool(xmlFile, baseKey .. "#bcMode", _enabled)
end

-- Load BC mode state. Called from MarketSerializer (xmlFile is an FS25 XML handle).
function BCIntegration.load(xmlFile, baseKey)
    local val = getXMLBool(xmlFile, baseKey .. "#bcMode")
    _enabled  = val == true
    MDMLog.info("BCIntegration: loaded bcMode=" .. tostring(_enabled))
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
-- Only reacts to successful harvest missions when BC mode is enabled.
function BCIntegration._onMissionFinish(mission, finishState)
    if not _enabled or not _marketEngine then return end

    -- Only react to successful completions
    if finishState ~= MissionFinishState.SUCCESS then return end

    -- Get fruit type from mission — HarvestMission stores it as mission.fruitType
    local fruitTypeIndex = nil
    if mission.fruitType and mission.fruitType.index then
        fruitTypeIndex = mission.fruitType.index
    end

    if not fruitTypeIndex then return end  -- not a crop harvest mission

    -- Convert fruit type → fill type
    if not g_fruitTypeManager then return end
    local fillTypeIndex = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex)
    if not fillTypeIndex or fillTypeIndex <= 1 then return end

    -- Verify MDM tracks this fill type
    if not _marketEngine.prices[fillTypeIndex] then return end

    -- Build a unique modifier ID
    local now   = g_currentMission and g_currentMission.time or 0
    local modId = "bc_supply_" .. fillTypeIndex .. "_" .. tostring(now)

    -- Apply supply spike: prices drop briefly as harvested crop hits market
    _marketEngine:addModifier({
        id            = modId,
        fillTypeIndex = fillTypeIndex,
        factor        = SUPPLY_SPIKE_FACTOR,
    })

    local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
    local name     = fillType and fillType.name or tostring(fillTypeIndex)
    MDMLog.info(string.format(
        "BCIntegration: supply spike applied to %s (%.0f%% factor, expires in 1h)",
        name, SUPPLY_SPIKE_FACTOR * 100))

    -- Schedule removal after SUPPLY_SPIKE_DURATION
    table.insert(_pendingRemovals, {
        fillTypeIndex = fillTypeIndex,
        modId         = modId,
        expiresAt     = now + SUPPLY_SPIKE_DURATION,
    })
end

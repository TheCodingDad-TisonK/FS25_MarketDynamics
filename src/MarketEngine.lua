-- MarketEngine.lua
-- Manages per-fillType dynamic prices.
-- Tracks base prices, applies modifier stacks, handles intraday + daily volatility.
-- Maintains price history (last 7 in-game days) per fillType.
--
-- Price model per fillType:
--   current = base * volatilityFactor * product(eventModifiers)
--
--   base             — vanilla sell price, snapshotted at init
--   volatilityFactor — running intraday + daily drift, clamped to [0.50, 2.00]
--   modifiers        — event modifier stack: { id, fillTypeIndex, factor }
--                      added by WorldEvent.onFire, removed by WorldEvent.onExpire
--   current          — effective price returned to the game via PriceHook
--   history          — last HISTORY_MAX_ENTRIES daily price samples: { price, time }
--
-- Public API (called externally):
--   init()                                 — snapshot base prices from economy
--   update(dt)                             — advance intraday/daily timers
--   addModifier(modifier)                  — push an event modifier onto the stack
--   removeModifierById(fillTypeIndex, id)  — pop a modifier by id
--   getPrice(fillTypeIndex)                — current effective price (or nil)
--   getPriceHistory(fillTypeIndex)         — array of { price, time } samples
--   getPriceChangePercent(fillTypeIndex)   — % change from base (positive = above)
--
-- Author: tison (dev-1)

MarketEngine = {}
MarketEngine.__index = MarketEngine

-- Update intervals (ms of in-game time)
local INTRADAY_INTERVAL_MS = 60 * 1000       -- every in-game minute
local DAILY_INTERVAL_MS    = 24 * 60 * 1000  -- every in-game day

-- Volatility parameters
local INTRADAY_MAGNITUDE   = 0.02   -- ±2% per intraday tick
local DAILY_MAGNITUDE      = 0.05   -- ±5% per daily shift
local MEAN_REVERSION_RATE  = 0.15   -- fraction of (1.0 - volatilityFactor) applied per day
local VOLATILITY_MIN       = 0.50   -- hard floor: never less than 50% of base
local VOLATILITY_MAX       = 2.00   -- hard ceiling: never more than 200% of base

-- Price history
local HISTORY_MAX_ENTRIES  = 7      -- last 7 in-game days

function MarketEngine.new()
    local self = setmetatable({}, MarketEngine)

    -- { [fillTypeIndex] = { base, volatilityFactor, modifiers, current, history } }
    self.prices        = {}
    self.intradayTimer = 0
    self.dailyTimer    = 0

    -- Scales both intraday and daily drift magnitudes.
    -- 0.5 = Low, 1.0 = Normal (default), 1.5 = High, 2.0 = Extreme.
    -- Written directly by SettingsUI; serialized by MarketSerializer.
    self.volatilityScale = 1.0

    MDMLog.info("MarketEngine initialized")
    return self
end

-- Called once after mission load — snapshots base prices from the vanilla economy.
-- Safe to call while g_MarketDynamics.isActive is still false: PriceHook's guard
-- lets vanilla results pass through until isActive = true, so origGetPrice returns
-- unmodified prices here.
function MarketEngine:init()
    if not g_fillTypeManager then
        MDMLog.warn("MarketEngine:init() — g_fillTypeManager not available")
        return
    end
    if not g_currentMission or not g_currentMission.economyManager then
        MDMLog.warn("MarketEngine:init() — economyManager not available")
        return
    end

    local fillTypes = g_fillTypeManager:getFillTypes()
    local count     = 0

    for _, fillType in ipairs(fillTypes) do
        -- Skip UNKNOWN (index 1) and any invalid entries
        if fillType and fillType.index and fillType.index > 1 then
            local basePrice = MDMGetVanillaPrice(g_currentMission.economyManager, fillType.index)
            if basePrice and basePrice > 0 then
                self.prices[fillType.index] = {
                    base             = basePrice,
                    volatilityFactor = 1.0,
                    modifiers        = {},
                    current          = basePrice,
                    history          = {},   -- { price, time } newest-last; max HISTORY_MAX_ENTRIES
                }
                count = count + 1
            end
        end
    end

    MDMLog.info("MarketEngine:init() — snapshotted " .. count .. " fill type prices")
end

-- Advance timers and fire intraday/daily volatility ticks.
-- dt is in-game milliseconds (from FSBaseMission.update).
function MarketEngine:update(dt)
    self.intradayTimer = self.intradayTimer + dt
    self.dailyTimer    = self.dailyTimer    + dt

    if self.intradayTimer >= INTRADAY_INTERVAL_MS then
        self.intradayTimer = 0
        self:_applyIntradayVolatility()
    end

    if self.dailyTimer >= DAILY_INTERVAL_MS then
        self.dailyTimer = 0
        self:_applyDailyShift()
    end
end

-- Push an event modifier onto a fillType's modifier stack.
-- modifier = { id, fillTypeIndex, factor }
-- Expiry is handled by WorldEventSystem calling onExpire → removeModifierById.
function MarketEngine:addModifier(modifier)
    local entry = self.prices[modifier.fillTypeIndex]
    if not entry then return end

    table.insert(entry.modifiers, modifier)
    self:_recalculate(modifier.fillTypeIndex)
end

-- Remove a modifier by id from a fillType's modifier stack.
-- Called from world event onExpire callbacks.
-- Safe to call for an id that doesn't exist (no-op).
function MarketEngine:removeModifierById(fillTypeIndex, id)
    local entry = self.prices[fillTypeIndex]
    if not entry then return end

    for i = #entry.modifiers, 1, -1 do
        if entry.modifiers[i].id == id then
            table.remove(entry.modifiers, i)
        end
    end
    self:_recalculate(fillTypeIndex)
end

-- Returns the current effective price for a fillType, or nil if not tracked.
-- Called by PriceHook at point of sale.
function MarketEngine:getPrice(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if entry then return entry.current end
    return nil
end

-- Returns price history array for GUI display.
-- Format: { { price, time }, ... } newest-last, up to HISTORY_MAX_ENTRIES entries.
function MarketEngine:getPriceHistory(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if entry then return entry.history end
    return {}
end

-- Returns the percentage change of the current price relative to the base price.
-- Positive = above base, negative = below base. Used by HUD trend indicators.
function MarketEngine:getPriceChangePercent(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if not entry or entry.base <= 0 then return 0 end
    return (entry.current - entry.base) / entry.base * 100
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

-- Small random walk on volatilityFactor — ±2% per in-game minute (scaled by volatilityScale).
-- Recalculates current price for every tracked fillType.
function MarketEngine:_applyIntradayVolatility()
    local magnitude = INTRADAY_MAGNITUDE * (self.volatilityScale or 1.0)
    for fillTypeIndex, entry in pairs(self.prices) do
        local delta    = (math.random() * 2 - 1) * magnitude
        local newFactor = entry.volatilityFactor * (1 + delta)
        entry.volatilityFactor = math.max(VOLATILITY_MIN, math.min(VOLATILITY_MAX, newFactor))
        self:_recalculate(fillTypeIndex)
    end
end

-- Daily shift: mean-reversion toward 1.0 + random trend ±5% (scaled by volatilityScale).
-- Records a price history snapshot after recalculation.
function MarketEngine:_applyDailyShift()
    local now            = g_currentMission and g_currentMission.time or 0
    local dailyMagnitude = DAILY_MAGNITUDE * (self.volatilityScale or 1.0)

    for fillTypeIndex, entry in pairs(self.prices) do
        local vf = entry.volatilityFactor
        -- Mean-reversion: pull vf back toward neutral (1.0) by MEAN_REVERSION_RATE fraction
        local reversion = (1.0 - vf) * MEAN_REVERSION_RATE
        -- Random daily trend
        local trend     = (math.random() * 2 - 1) * dailyMagnitude
        local newFactor = vf + reversion + trend
        entry.volatilityFactor = math.max(VOLATILITY_MIN, math.min(VOLATILITY_MAX, newFactor))
        self:_recalculate(fillTypeIndex)

        -- Record daily price snapshot for GUI history chart
        table.insert(entry.history, { price = entry.current, time = now })
        if #entry.history > HISTORY_MAX_ENTRIES then
            table.remove(entry.history, 1)
        end
    end
end

-- Recompute current = base * volatilityFactor * product(all event modifier factors).
function MarketEngine:_recalculate(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if not entry then return end

    local factor = entry.volatilityFactor
    for _, mod in ipairs(entry.modifiers) do
        factor = factor * mod.factor
    end
    entry.current = entry.base * factor
end

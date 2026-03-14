-- MarketEngine.lua
-- Manages per-fillType dynamic prices.
-- Tracks base prices, applies modifier stacks, handles intraday + daily volatility.
-- Maintains price history (last 7 in-game days) per fillType.
--
-- Price model per fillType:
--   current = base * volatilityFactor * product(eventModifiers)
--
--   base            — vanilla sell price, snapshotted at init
--   volatilityFactor— running intraday + daily drift [0.50, 2.00]
--   modifiers       — event modifier stack, each { id, factor } — expired via onExpire callback
--   current         — effective price returned to the game via PriceHook
--   history         — last HISTORY_MAX_ENTRIES daily price samples { price, time }
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

    MDMLog.info("MarketEngine initialized")
    return self
end

-- Called once after mission load — snapshot base prices from the game economy.
-- PriceHook.MDMGetVanillaPrice returns the vanilla price because g_MarketDynamics.isActive
-- is still false at this point, so our hook passes through without modification.
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
                    base            = basePrice,
                    volatilityFactor= 1.0,
                    modifiers       = {},
                    current         = basePrice,
                    history         = {},   -- { price, time } newest last
                }
                count = count + 1
            end
        end
    end

    MDMLog.info("MarketEngine:init() — snapshotted " .. count .. " fill type prices")
end

-- dt in ms (in-game time delta from FSBaseMission.update)
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

-- Apply a named modifier to a fillType price (called from world event onFire)
-- modifier = { id, fillTypeIndex, factor }
-- Expiry is handled by WorldEventSystem calling onExpire → removeModifierById.
function MarketEngine:addModifier(modifier)
    local entry = self.prices[modifier.fillTypeIndex]
    if not entry then return end

    table.insert(entry.modifiers, modifier)
    self:_recalculate(modifier.fillTypeIndex)
end

-- Remove a modifier by id (called from world event onExpire)
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

-- Returns the current effective price for a fillType (or nil if unknown).
-- Called by PriceHook at point of sale.
function MarketEngine:getPrice(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if entry then return entry.current end
    return nil
end

-- Returns price history for GUI (array of { price, time }, newest last, max 7 entries).
function MarketEngine:getPriceHistory(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if entry then return entry.history end
    return {}
end

-- Returns % change from base for the current effective price.
-- Positive = above base, negative = below base.
-- Used by HUD trend indicators.
function MarketEngine:getPriceChangePercent(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if not entry or entry.base <= 0 then return 0 end
    return (entry.current - entry.base) / entry.base * 100
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

-- Small random walk on volatilityFactor — ±2% per in-game minute.
-- Recalculates current price for every tracked fillType.
function MarketEngine:_applyIntradayVolatility()
    for fillTypeIndex, entry in pairs(self.prices) do
        local delta    = (math.random() * 2 - 1) * INTRADAY_MAGNITUDE
        local newFactor = entry.volatilityFactor * (1 + delta)
        entry.volatilityFactor = math.max(VOLATILITY_MIN, math.min(VOLATILITY_MAX, newFactor))
        self:_recalculate(fillTypeIndex)
    end
end

-- Daily shift: mean-reversion toward 1.0 + random trend ±5%.
-- Records a price history sample after recalculation.
function MarketEngine:_applyDailyShift()
    local now = g_currentMission and g_currentMission.time or 0

    for fillTypeIndex, entry in pairs(self.prices) do
        local vf        = entry.volatilityFactor
        -- Mean-reversion: pull vf back toward neutral (1.0) by MEAN_REVERSION_RATE fraction
        local reversion = (1.0 - vf) * MEAN_REVERSION_RATE
        -- Random daily trend
        local trend     = (math.random() * 2 - 1) * DAILY_MAGNITUDE
        local newFactor = vf + reversion + trend
        entry.volatilityFactor = math.max(VOLATILITY_MIN, math.min(VOLATILITY_MAX, newFactor))
        self:_recalculate(fillTypeIndex)

        -- Record daily price snapshot for history
        table.insert(entry.history, { price = entry.current, time = now })
        if #entry.history > HISTORY_MAX_ENTRIES then
            table.remove(entry.history, 1)
        end
    end
end

-- Recompute current = base * volatilityFactor * product(eventModifiers)
function MarketEngine:_recalculate(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if not entry then return end

    local factor = entry.volatilityFactor
    for _, mod in ipairs(entry.modifiers) do
        factor = factor * mod.factor
    end
    entry.current = entry.base * factor
end

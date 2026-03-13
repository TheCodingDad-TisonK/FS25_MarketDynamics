-- MarketEngine.lua
-- Manages per-fillType dynamic prices.
-- Tracks base prices, applies modifier stacks, handles intraday + daily volatility.
--
-- Author: tison (dev-1)

MarketEngine = {}
MarketEngine.__index = MarketEngine

-- Price update intervals (in ms of game time)
local INTRADAY_INTERVAL_MS = 60 * 1000   -- every 60 in-game seconds
local DAILY_INTERVAL_MS    = 24 * 60 * 1000  -- every in-game day

function MarketEngine.new()
    local self = setmetatable({}, MarketEngine)

    -- { [fillTypeIndex] = { base, current, modifiers = {} } }
    self.prices        = {}
    self.intradayTimer = 0
    self.dailyTimer    = 0

    MDMLog.info("MarketEngine initialized")
    return self
end

-- Called once after mission load — snapshot base prices from the game economy
function MarketEngine:init()
    -- TODO: iterate g_fillTypeManager fill types and cache base sell prices
    -- Reference: g_currentMission.economyManager, SellingStation
    MDMLog.info("MarketEngine:init() — price snapshot pending implementation")
end

-- dt in ms (game time delta)
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

-- Apply a named modifier to a fillType price (from a world event)
-- modifier = { id, fillTypeIndex, factor, durationMs }
function MarketEngine:addModifier(modifier)
    local entry = self.prices[modifier.fillTypeIndex]
    if not entry then return end

    modifier.remaining = modifier.durationMs
    table.insert(entry.modifiers, modifier)
    self:_recalculate(modifier.fillTypeIndex)
end

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

-- Returns the current effective price for a fillType (or nil if unknown)
function MarketEngine:getPrice(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if entry then return entry.current end
    return nil
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

function MarketEngine:_applyIntradayVolatility()
    -- Small random fluctuation: ±2% per interval
    -- TODO: implement once price snapshot is in place
end

function MarketEngine:_applyDailyShift()
    -- Larger daily trend shift: ±5% with mean-reversion toward base
    -- TODO: implement once price snapshot is in place
end

function MarketEngine:_recalculate(fillTypeIndex)
    local entry = self.prices[fillTypeIndex]
    if not entry then return end

    local factor = 1.0
    for _, mod in ipairs(entry.modifiers) do
        factor = factor * mod.factor
    end
    entry.current = entry.base * factor
end

-- VolatileEconomy.lua  v1.0 (FS25) — Deterministic, poll-based month detection
--
-- All prices and events computed from game state (month/year).
-- No networking needed — every instance computes the same values.
-- Month change detected via polling in update(), not via hooks.
-- Author: NoticeGG

source(Utils.getFilename("src/MarketData.lua",  g_currentModDirectory))
source(Utils.getFilename("src/EconomyHUD.lua",  g_currentModDirectory))

VolatileEconomy = {}
VolatileEconomy_mt = Class(VolatileEconomy)

VolatileEconomy.SAVE_KEY = "volatileEconomy"
VolatileEconomy.MOD_NAME = g_currentModName

-- ============================================================
-- DETERMINISTIC PRNG
-- ============================================================
function VolatileEconomy.nextRand(seed)
    return (seed * 1103515245 + 12345) % 2147483648
end

function VolatileEconomy.seededFloat(seed, minVal, maxVal)
    seed = VolatileEconomy.nextRand(seed)
    local t = (seed % 100000) / 100000.0
    return minVal + t * (maxVal - minVal), seed
end

function VolatileEconomy.hashString(s)
    local h = 5381
    for i = 1, #s do
        h = ((h * 33) + string.byte(s, i)) % 2147483648
    end
    return h
end

-- ============================================================
-- CONSTRUCTOR
-- ============================================================
function VolatileEconomy:new(mission)
    local o = setmetatable({}, VolatileEconomy_mt)
    o.isServer = g_server ~= nil or (mission.getIsServer and mission:getIsServer()) or false
    o.isClient = not o.isServer or g_dedicatedServer == nil
    o.mission  = mission
    o.marketState  = {}
    o.activeEvents = {}
    o.lastKnownMonth = -1
    o._initialized = false
    o._pollTimer = 0
    o.hud = nil
    if o.isClient then
        o.hud = EconomyHUD:new(o)
    end

    o:installHooks()

    Logging.info(string.format(
        "[VolatileEconomy] v1.0 (FS25) Init  isServer=%s  isClient=%s  DETERMINISTIC",
        tostring(o.isServer), tostring(o.isClient)
    ))
    return o
end

function VolatileEconomy:delete()
    if self.hud then self.hud:delete(); self.hud = nil end
end

-- ============================================================
-- HOOKS (only price hook — no message listeners needed)
-- ============================================================
function VolatileEconomy:installHooks()
    local mod = self
    local targetClass = SellingStation

    if targetClass.getEffectiveFillTypePrice then
        targetClass.getEffectiveFillTypePrice = Utils.overwrittenFunction(
            targetClass.getEffectiveFillTypePrice,
            function(station, superFunc, fillTypeIndex, ...)
                local base = superFunc(station, fillTypeIndex, ...)
                if not base or base <= 0 then return base end
                -- Apply base multiplier (e.g. cake x2) BEFORE mod modifiers
                local ftName = ""
                pcall(function()
                    local ft = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
                    if ft then ftName = (ft.name or ""):lower() end
                end)
                local baseMult = MarketData.FILL_TYPE_BASE_MULTIPLIERS[ftName] or 1.0
                base = base * baseMult
                -- Apply mod price index + event multiplier
                local ok, multiplier = pcall(function() return mod:getEffectiveIndex(station, fillTypeIndex) end)
                if ok and multiplier then return base * multiplier end
                return base
            end
        )
        Logging.info("[VolatileEconomy] Hooked SellingStation.getEffectiveFillTypePrice")
    end
end

-- ============================================================
-- GAME STATE
-- ============================================================
function VolatileEconomy:getCurrentPeriod()
    local period = nil
    -- Method 1: currentPeriod property (most reliable in FS25)
    pcall(function()
        local env = g_currentMission.environment
        if env.currentPeriod and env.currentPeriod > 0 then
            period = env.currentPeriod
        end
    end)
    if period then return period end
    -- Method 2: currentVisualPeriod
    pcall(function()
        local env = g_currentMission.environment
        if env.currentVisualPeriod and env.currentVisualPeriod > 0 then
            period = env.currentVisualPeriod
        end
    end)
    if period then return period end
    -- Method 3: calculate from currentDay
    pcall(function()
        local env = g_currentMission.environment
        local day = env.currentDay
        local dpp = env.plannedDaysPerPeriod or env.daysPerPeriod or 1
        if day and day > 0 and dpp and dpp > 0 then
            period = ((math.ceil(day / dpp) - 1) % 12) + 1
        end
    end)
    if period then return period end
    -- Method 4: getPeriodAndAlphaIntoPeriod (can be stale)
    pcall(function()
        local p, a = g_currentMission.environment:getPeriodAndAlphaIntoPeriod()
        period = p
    end)
    return period
end

function VolatileEconomy:getCurrentYear()
    local year = 1
    pcall(function()
        local env = g_currentMission.environment
        if env.currentYear then year = env.currentYear end
        -- Fallback: calculate from day
        if (not year or year < 1) and env.currentDay then
            local dpp = env.plannedDaysPerPeriod or env.daysPerPeriod or 1
            year = math.floor((env.currentDay - 1) / (12 * dpp)) + 1
        end
    end)
    return year or 1
end

function VolatileEconomy:getMonthSeed()
    local period = self:getCurrentPeriod() or 1
    local year = self:getCurrentYear()
    return period * 10000 + year * 137 + 42
end

function VolatileEconomy:getCurrentSeason()
    local period = self:getCurrentPeriod() or 1
    local seasonMap = {4, 4, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4}
    return seasonMap[period] or 1
end

-- ============================================================
-- POLL-BASED UPDATE (called every frame from global update)
-- ============================================================
function VolatileEconomy:tick(dt)
    -- Poll every ~2 seconds, not every frame
    self._pollTimer = (self._pollTimer or 0) + dt
    if self._pollTimer < 2000 then return end
    self._pollTimer = 0

    local currentPeriod = self:getCurrentPeriod()
    if not currentPeriod then return end

    -- First tick: initialize
    if not self._initialized then
        self._initialized = true
        self.lastKnownMonth = currentPeriod
        self:rebuildMonth()
        pcall(function()
            local sp = self:getAllSellPoints()
            local c = 0; for _ in pairs(sp) do c = c + 1 end
            Logging.info(string.format("[VolatileEconomy] INIT: stations=%d period=%d year=%d",
                c, currentPeriod, self:getCurrentYear()))
        end)
        return
    end

    -- Detect month change
    if currentPeriod ~= self.lastKnownMonth then
        Logging.info(string.format("[VolatileEconomy] Month %d -> %d. Rebuilding.", self.lastKnownMonth, currentPeriod))
        self.lastKnownMonth = currentPeriod
        self:rebuildMonth()
    end
end

-- ============================================================
-- REBUILD MONTH (deterministic — identical on every instance)
-- ============================================================
function VolatileEconomy:rebuildMonth()
    self.marketState = {}
    self:pickMonthlyEvent()
end

function VolatileEconomy:pickMonthlyEvent()
    self.activeEvents = {}
    local currentSeason = self:getCurrentSeason()
    local baseSeed = self:getMonthSeed()

    local candidates = {}
    for _, ev in ipairs(MarketData.EVENTS) do
        local seasonOk = true
        if ev.seasons then
            seasonOk = false
            for _, s in ipairs(ev.seasons) do
                if s == currentSeason then seasonOk = true; break end
            end
        end
        if seasonOk then
            for _ = 1, ev.weight do table.insert(candidates, ev) end
        end
    end
    if #candidates == 0 then return end

    local seed = VolatileEconomy.nextRand(baseSeed + 77777)
    local idx = (seed % #candidates) + 1
    local ev = candidates[idx]
    table.insert(self.activeEvents, { event = ev, remainingDays = 99 })
    Logging.info(string.format("[VolatileEconomy] Event: %s x%.2f (season=%d)", ev.title, ev.multiplier, currentSeason))

    if self.isClient then
        self:showEventNotification(ev.title, ev.desc, ev.isNegative, 30)
    end
end

-- ============================================================
-- PRICE STATE (deterministic, on demand)
-- ============================================================
function VolatileEconomy:ensureState(sp, fillTypeIndex)
    local spId = self:getSellPointId(sp)
    local ftKey = tostring(fillTypeIndex)
    if not self.marketState[spId] then self.marketState[spId] = {} end
    if not self.marketState[spId][ftKey] then
        local seed = self:getMonthSeed() + VolatileEconomy.hashString(spId) + fillTypeIndex * 31
        local deviation
        deviation, seed = VolatileEconomy.seededFloat(seed, -MarketData.MAX_PRICE_DEVIATION, MarketData.MAX_PRICE_DEVIATION)
        self.marketState[spId][ftKey] = {
            index = 1.0 + deviation, target = 1.0, trend = 0.0,
            supplyPressure = 0.0, neglectScore = 0.0, lureBonus = 0.0, soldThisMonth = 0.0,
        }
    end
    return self.marketState[spId][ftKey]
end

function VolatileEconomy:getEffectiveIndex(sp, fillTypeIndex)
    local state = self:ensureState(sp, fillTypeIndex)
    local raw = math.max(MarketData.PRICE_FLOOR, math.min(1.0 + MarketData.MAX_PRICE_DEVIATION, state.index + state.lureBonus))
    local evMult = self:getActiveEventMultiplier(sp, fillTypeIndex)
    return raw * evMult
end

-- ============================================================
-- SELL POINTS
-- ============================================================
function VolatileEconomy:getAllSellPoints()
    if g_currentMission.economyManager and g_currentMission.economyManager.sellingStations then
        local unwrapped = {}
        for _, entry in pairs(g_currentMission.economyManager.sellingStations) do
            if type(entry) == "table" then
                if entry.station then table.insert(unwrapped, entry.station)
                else table.insert(unwrapped, entry) end
            end
        end
        if #unwrapped > 0 then return unwrapped end
    end
    local stations = {}
    pcall(function()
        if g_currentMission.sellingStations then
            for _, s in pairs(g_currentMission.sellingStations) do table.insert(stations, s) end
        end
    end)
    return stations
end

function VolatileEconomy:getSellPointId(sp)
    if sp._veId then return sp._veId end
    local name = ""
    pcall(function()
        if sp.owningPlaceable and sp.owningPlaceable.getName then
            name = sp.owningPlaceable:getName() or ""
        end
    end)
    local pos = ""
    pcall(function()
        local node = nil
        if sp.owningPlaceable and sp.owningPlaceable.rootNode then node = sp.owningPlaceable.rootNode end
        if not node and sp.rootNode then node = sp.rootNode end
        if node and node ~= 0 then
            local x, y, z = getWorldTranslation(node)
            pos = string.format("%.0f_%.0f", x or 0, z or 0)
        end
    end)
    local id = name .. "_" .. pos
    if id == "_" then id = "sp_" .. tostring(sp) end
    sp._veId = id
    return id
end

function VolatileEconomy:getFillTypeName(fillTypeIndex)
    local name = ""
    pcall(function()
        local ft = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        if ft then name = ft.name or "" end
    end)
    return name:lower()
end

-- ============================================================
-- EVENT MULTIPLIER
-- ============================================================
function VolatileEconomy:getActiveEventMultiplier(sp, fillTypeIndex)
    local ftName = self:getFillTypeName(fillTypeIndex)
    local combined = 1.0
    for _, active in ipairs(self.activeEvents) do
        local ev = active.event
        local affects = false
        if ev.fillTypes then
            for _, f in ipairs(ev.fillTypes) do
                if f == "all" or f == ftName then affects = true; break end
            end
        end
        if affects then combined = combined * ev.multiplier end
    end
    return combined
end

function VolatileEconomy:getActiveEventsList()
    -- Fallback Russian names for fill types not found in game
    local ruNames = {
        wheat = "Пшеница", barley = "Ячмень", corn = "Кукуруза", canola = "Рапс",
        soybean = "Соя", sunflower = "Подсолнечник", potato = "Картофель",
        sugarbeet = "Сах. свёкла", silage = "Силос", grass_windrow = "Трава/Сено",
        woodChips = "Щепа", manure = "Навоз", liquidManure = "Жидкий навоз",
        flour = "Мука", bread = "Хлеб", cake = "Торты", butter = "Масло сл.",
        cheese = "Сыр", sugar = "Сахар", chocolate = "Шоколад",
        clothes = "Одежда", fabric = "Ткани", furniture = "Мебель",
        boards = "Доски", prefabWalls = "Стен. панели", oil = "Раст. масло",
    }

    local result = {}
    for _, a in ipairs(self.activeEvents) do
        local fillTypesDisplay = ""
        local names = {}
        for _, ftName in ipairs(a.event.fillTypes) do
            if ftName == "all" then
                fillTypesDisplay = "Все товары"
                break
            end
            -- Try game localization first, then our fallback
            local localName = ruNames[ftName] or ftName
            pcall(function()
                local fti = g_fillTypeManager:getFillTypeIndexByName(ftName)
                if fti then
                    local ft = g_fillTypeManager:getFillTypeByIndex(fti)
                    if ft and ft.title and ft.title ~= "" then localName = ft.title end
                end
            end)
            table.insert(names, localName)
        end
        if fillTypesDisplay == "" then fillTypesDisplay = table.concat(names, ", ") end
        table.insert(result, {
            title = a.event.title, desc = a.event.desc,
            multiplier = a.event.multiplier, isNegative = a.event.isNegative,
            fillTypesDisplay = fillTypesDisplay,
        })
    end
    return result
end

function VolatileEconomy:getSeasonalDemand(ftName, seasonIdx)
    local sd = MarketData.SEASONAL_DEMAND[seasonIdx]
    if sd and sd[ftName] then return sd[ftName] end
    return 1.0
end

-- ============================================================
-- NOTIFICATION
-- ============================================================
function VolatileEconomy:showEventNotification(title, desc, isNeg, duration)
    pcall(function()
        if g_currentMission.hud and g_currentMission.hud.sideNotifications then
            local text = title .. " — " .. desc
            g_currentMission.hud.sideNotifications:addNotification(text, "", duration or 15)
        end
    end)
end

-- ============================================================
-- SAVEGAME
-- ============================================================
function VolatileEconomy:saveToXMLFile(xmlFile, key) end
function VolatileEconomy:loadFromXMLFile(xmlFile, key) end

-- ============================================================
-- LIFECYCLE
-- ============================================================

local _mod = nil

local function loadMapEvent(mission)
    Logging.info("[VolatileEconomy] loadMap called")
    pcall(function()
        if _mod == nil and g_currentMission ~= nil then
            _mod = VolatileEconomy:new(g_currentMission)
        end
    end)
end

local function deleteMapEvent()
    if _mod then
        Logging.info("[VolatileEconomy] deleteMap — cleaning up")
        _mod:delete()
        _mod = nil
    end
end

local function updateEvent(self, dt)
    if _mod then
        -- Poll for month changes (replaces broken onHourChanged hook)
        pcall(function() _mod:tick(dt) end)
        -- HUD update
        if _mod.hud then pcall(function() _mod.hud:update(dt) end) end
    end
end

local function drawEvent(self)
    if _mod and _mod.hud then
        pcall(function() _mod.hud:draw() end)
    end
end

pcall(function()
    FSBaseMission.loadMapFinished = Utils.appendedFunction(FSBaseMission.loadMapFinished, loadMapEvent)
end)
pcall(function()
    FSBaseMission.deleteMap = Utils.prependedFunction(FSBaseMission.deleteMap, deleteMapEvent)
end)

addModEventListener({
    update = updateEvent,
    draw = drawEvent,
})

function getVolatileEconomyMod() return _mod end

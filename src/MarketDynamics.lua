-- MarketDynamics.lua
-- Central coordinator. Owns all subsystems, drives the update loop.
-- Global reference: g_MarketDynamics
--
-- Author: tison (dev-1)

MarketDynamics = {}
MarketDynamics.__index = MarketDynamics

function MarketDynamics.new(modDir, modName)
    local self = setmetatable({}, MarketDynamics)

    self.modDir   = modDir
    self.modName  = modName
    self.isActive = false

    -- Subsystems
    self.marketEngine  = MarketEngine.new()
    self.worldEvents   = WorldEventSystem.new()
    self.futuresMarket = FuturesMarket.new()
    self.serializer    = MarketSerializer.new()

    MDMLog.info("MarketDynamics created — v" .. g_modManager:getModByName(modName).version)
    return self
end

-- Called after mission is fully loaded — safe to access game APIs here
function MarketDynamics:onMissionLoaded(mission)
    self.marketEngine:init()
    self:_registerDefaultEvents()
    self.isActive = true
    MDMLog.info("MarketDynamics: mission loaded, system active")
end

-- Called when the player's savegame session actually starts (load saved data here)
function MarketDynamics:onStartMission(mission)
    self.serializer:load(self)
    MDMLog.info("MarketDynamics: savegame data loaded")
end

function MarketDynamics:update(dt)
    if not self.isActive then return end

    self.marketEngine:update(dt)
    self.worldEvents:update(dt)
    self.futuresMarket:checkExpiry()
end

function MarketDynamics:draw()
    if not self.isActive then return end
    -- HUD rendering delegated to GUI module (LeGrizzly's dev-2)
    -- If g_MDMHud exists, call g_MDMHud:draw()
    if g_MDMHud then
        g_MDMHud:draw()
    end
end

function MarketDynamics:save(xmlFile)
    if not self.isActive then return end
    self.serializer:save(self)
end

function MarketDynamics:delete()
    self.isActive = false
    MDMLog.info("MarketDynamics: deleted")
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

function MarketDynamics:_registerDefaultEvents()
    -- Events are self-registering — this just ensures they're called
    -- Each event file calls WorldEventSystem:registerEvent on g_MarketDynamics.worldEvents
    -- Registration happens in events/*.lua after this coordinator is created

    -- Trigger deferred registrations (set by event files at source() time)
    if MarketDynamics.pendingEventRegistrations then
        for _, reg in ipairs(MarketDynamics.pendingEventRegistrations) do
            self.worldEvents:registerEvent(reg)
        end
        MarketDynamics.pendingEventRegistrations = nil
    end
end

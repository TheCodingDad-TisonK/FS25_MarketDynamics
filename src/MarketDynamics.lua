-- MarketDynamics.lua
-- Central coordinator. Creates and owns all subsystems, drives the update loop.
-- Global reference: g_MarketDynamics
--
-- Subsystem ownership:
--   marketEngine   MarketEngine       price state, volatility, modifier stack
--   worldEvents    WorldEventSystem   event registry, scheduling, expiry
--   futuresMarket  FuturesMarket      contract creation and settlement
--   serializer     MarketSerializer   save/load to modSettings XML
--
-- Lifecycle (hooks installed at the bottom of this file at source time):
--   Mission00.load              — create coordinator, set g_MarketDynamics
--   Mission00.loadMission00Finished — init engine, register events, activate
--   Mission00.onStartMission    — load saved state from XML
--   FSBaseMission.update        — tick all subsystems
--   FSBaseMission.draw          — delegate to g_MDMHud if market screen is open
--   FSCareerMissionInfo.saveToXMLFile — persist state
--   FSBaseMission.delete        — cleanup
--
-- Author: tison (dev-1)

MarketDynamics = {}
MarketDynamics.__index = MarketDynamics

function MarketDynamics.new(modDir, modName)
    local self = setmetatable({}, MarketDynamics)

    self.modDir   = modDir
    self.modName  = modName
    self.isActive = false

    -- Player-configurable settings (persisted by MarketSerializer, edited via SettingsUI)
    -- Add new settings here and wire them in MarketSerializer + SettingsUI.
    self.settings = {
        pricesEnabled   = true,   -- When false, PriceHook passes through to vanilla prices
        debugMode       = false,  -- MDMLog.debugEnabled mirror (also set directly on MDMLog)
        eventsEnabled   = true,   -- When false, WorldEventSystem skips probability rolls
        eventFrequency  = 1.0,   -- Probability scale: 0.4=Rare, 1.0=Normal, 2.0=Frequent
        futuresPenalty  = 0.15,  -- Default penalty fraction on unfulfilled contracts
    }

    -- Subsystems
    self.marketEngine  = MarketEngine.new()
    self.worldEvents   = WorldEventSystem.new()
    self.futuresMarket = FuturesMarket.new()
    self.serializer    = MarketSerializer.new()

    local modInfo = g_modManager:getModByName(modName)
    MDMLog.info("MarketDynamics created — v" .. (modInfo and modInfo.version or "?"))
    return self
end

-- Called after mission is fully loaded. Safe to access all game APIs from here.
-- Initialisation order matters: engine must be inited before isActive=true so
-- that PriceHook's vanilla-price snapshot happens without MDM interference.
function MarketDynamics:onMissionLoaded(mission)
    self.marketEngine:init()         -- snapshot vanilla base prices
    self:_registerDefaultEvents()    -- drain MDM_pendingRegistrations
    self.isActive = true             -- PriceHook now routes through MDM
    BCIntegration.init(self.marketEngine, self.futuresMarket)
    UPIntegration.init()
    MDMSettingsUI.initGui(self.modDir)
    MDMAdminCommands_register()

    -- Dialog loader: init + register modal dialogs (client only — no GUI on dedicated servers)
    if not g_currentMission.isServer or g_currentMission.isClient then
        MDMDialogLoader.init(self.modDir)
        MDMDialogLoader.register("MDMContractDialog",      MDMContractDialog,      "xml/gui/MDMContractDialog.xml")
        MDMDialogLoader.register("MDMContractAdminDialog", MDMContractAdminDialog, "xml/gui/MDMContractAdminDialog.xml")
    end

    MDMLog.info("MarketDynamics: mission loaded, system active")
end

-- Called when the player's savegame session actually starts (load saved data here)
function MarketDynamics:onStartMission(mission)
    self.serializer:load(self)
    UPIntegration.reregisterActiveContracts(self.futuresMarket.contracts)
    MDMLog.info("MarketDynamics: savegame data loaded")
end

-- Per-frame tick. dt = in-game milliseconds from FSBaseMission.update.
function MarketDynamics:update(dt)
    if not self.isActive then return end

    self.marketEngine:update(dt)     -- intraday and daily price ticks
    self.worldEvents:update(dt)      -- event expiry and probability rolls
    self.futuresMarket:checkExpiry() -- settle contracts past delivery date
    BCIntegration.update()           -- expire BC supply-spike modifiers
end

-- Per-frame draw. Delegates to g_MDMHud if the market screen registers one.
function MarketDynamics:draw()
    if not self.isActive then return end
    if g_MDMHud then
        g_MDMHud:draw()
    end
end

-- Triggered by FSCareerMissionInfo.saveToXMLFile. The xmlFile param from that
-- hook is not used here; MarketSerializer builds its own path from savegameDirectory.
function MarketDynamics:save(xmlFile)
    if not self.isActive then return end
    self.serializer:save(self)
end

function MarketDynamics:delete()
    self.isActive = false
    MDMAdminCommands_remove()
    MDMDialogLoader.cleanup()
    MDMLog.info("MarketDynamics: deleted")
end

-- ---------------------------------------------------------------------------
-- Private
-- ---------------------------------------------------------------------------

function MarketDynamics:_registerDefaultEvents()
    -- Events are self-registering — this just ensures they're called
    -- Each event file calls WorldEventSystem:registerEvent on g_MarketDynamics.worldEvents
    -- Registration happens in events/*.lua after this coordinator is created

    -- Drain deferred registrations pushed by event files at source() time.
    -- Uses MDM_pendingRegistrations (standalone global) because MarketDynamics
    -- didn't exist yet when those files were sourced.
    if MDM_pendingRegistrations then
        for _, reg in ipairs(MDM_pendingRegistrations) do
            self.worldEvents:registerEvent(reg)
        end
        MDM_pendingRegistrations = nil
    end
end

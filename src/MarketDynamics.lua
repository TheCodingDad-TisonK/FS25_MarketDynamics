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
--   FSBaseMission.draw          — delegate to g_MDMHud if present
--   FSCareerMissionInfo.saveToXMLFile — persist state
--   FSBaseMission.delete        — cleanup
--
-- NOTE: FS25 only sources files listed in modDesc.xml extraSourceFiles.
-- main.lua is NOT in that list and is NOT sourced by the game. Hooks must
-- live here; do not add them to main.lua.
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
        pricesEnabled = true,   -- When false, PriceHook passes through to vanilla prices
        debugMode     = false,  -- MDMLog.debugEnabled mirror (also set directly on MDMLog)
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
    BCIntegration.init(self.marketEngine)
    UPIntegration.init()
    MDMSettingsUI.initGui(self.modDir)
    self._debugHud = MDMDebugHUD.new()  -- TEMP: remove when LeGrizzly's GUI lands
    MDMAdminCommands_register()
    MDMLog.info("MarketDynamics: mission loaded, system active")
end

-- Called when the player's savegame session actually starts (load saved data here)
function MarketDynamics:onStartMission(mission)
    self.serializer:load(self)
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

-- Per-frame draw. Delegates to g_MDMHud if one is registered.
-- LeGrizzly's GUI sets g_MDMHud on load; the debug HUD uses the same slot.
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
    -- Only nil the internal debug HUD reference. g_MDMHud is LeGrizzly's GUI
    -- global and belongs to that module -- clearing it here would silently
    -- destroy the production HUD on every mission exit/reload.
    if g_MDMHud == self._debugHud then
        -- The debug HUD is currently active; clear the shared ref before dropping it.
        g_MDMHud = nil
    end
    self._debugHud = nil
    MDMAdminCommands_remove()
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

-- ---------------------------------------------------------------------------
-- Lifecycle hook installation
-- Captured at source() time — FS25 does NOT auto-source main.lua.
-- Only extraSourceFiles entries are loaded; hooks must be installed here.
-- ---------------------------------------------------------------------------

local _mdmModDir  = g_currentModDirectory
local _mdmModName = g_currentModName
local _mdm        = nil

local function _mdmOnLoad(mission)
    _mdm = MarketDynamics.new(_mdmModDir, _mdmModName)
    getfenv(0)["g_MarketDynamics"] = _mdm
end

local function _mdmOnLoadFinished(mission)
    if _mdm then _mdm:onMissionLoaded(mission) end
end

local function _mdmOnStartMission(mission)
    if _mdm then _mdm:onStartMission(mission) end
end

local function _mdmOnUpdate(mission, dt)
    if _mdm then _mdm:update(dt) end
end

local function _mdmOnDraw(mission)
    if _mdm then _mdm:draw() end
end

local function _mdmOnSave(mission, xmlFile)
    if _mdm then _mdm:save(xmlFile) end
end

local function _mdmOnDelete(mission)
    if _mdm then
        _mdm:delete()
        _mdm = nil
        getfenv(0)["g_MarketDynamics"] = nil
    end
end

Mission00.load                    = Utils.prependedFunction(Mission00.load,                   _mdmOnLoad)
Mission00.loadMission00Finished   = Utils.appendedFunction(Mission00.loadMission00Finished,   _mdmOnLoadFinished)
Mission00.onStartMission          = Utils.appendedFunction(Mission00.onStartMission,          _mdmOnStartMission)
FSBaseMission.update              = Utils.appendedFunction(FSBaseMission.update,              _mdmOnUpdate)
FSBaseMission.draw                = Utils.appendedFunction(FSBaseMission.draw,                _mdmOnDraw)
FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, _mdmOnSave)
FSBaseMission.delete              = Utils.appendedFunction(FSBaseMission.delete,              _mdmOnDelete)

MDMLog.info("MarketDynamics: lifecycle hooks installed")

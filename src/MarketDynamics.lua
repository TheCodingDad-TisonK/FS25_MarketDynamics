-- MarketDynamics.lua
-- Central coordinator. Owns all subsystems, drives the update loop.
-- Global reference: g_MarketDynamics
--
-- NOTE: Lifecycle hooks are installed at the BOTTOM of this file (at source time),
-- because FS25 only sources files listed in extraSourceFiles — main.lua is ignored.
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

    MDMLog.info("MarketDynamics created — v" .. g_modManager:getModByName(modName).version)
    return self
end

-- Called after mission is fully loaded — safe to access game APIs here
function MarketDynamics:onMissionLoaded(mission)
    self.marketEngine:init()
    self:_registerDefaultEvents()
    self.isActive = true
    BCIntegration.init(self.marketEngine)
    _mdmUpliftL10n()
    MDMSettingsUI.initGui(self.modDir)
    MDMAdminCommands_register()
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
    BCIntegration.update()
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
-- L10n uplift
-- FS25 sandboxes each mod's g_i18n. Vanilla GUI code (e.g. updateSubCategoryPages)
-- looks up header title keys in the REAL global g_i18n, so our keys are invisible
-- to it by default. Escape the sandbox via getmetatable(_G).__index and register
-- any translation key prefixed with "global_" into the real g_i18n (without the prefix).
-- ---------------------------------------------------------------------------

local function _mdmUpliftL10n()
    local gEnv = getmetatable(_G).__index
    if not gEnv or not gEnv.g_i18n then return end
    local count = 0
    for name, value in pairs(g_i18n.texts) do
        if string.startsWith(name, "global_") then
            gEnv.g_i18n:setText(name:sub(8), value)
            count = count + 1
        end
    end
    MDMLog.info("MarketDynamics: uplifted " .. count .. " l10n key(s) to global g_i18n")
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

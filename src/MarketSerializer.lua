-- MarketSerializer.lua
-- Handles save/load of MDM market state to a per-savegame XML file.
--
-- Save path: <savegameDirectory>/FS25_MarketDynamics.xml
-- (v1.1.4.1+: no longer creates a modSettings subfolder inside the savegame
--  directory; dedicated servers cannot upload savegames with subfolders)
--
-- What is persisted (v2):
--   futures contracts  — active/settled contracts
--   event cooldowns    — lastFiredAt per event
--   active events      — currently running events (restored via loadActiveEvent)
--   market prices      — volatilityFactor per fillType
--   price history      — daily history samples per fillType
--   general settings   — pricesEnabled, debugMode, volatilityScale
--   UP deal IDs        — contractId → upDealId map for UsedPlus
--
-- Author: tison (dev-1)

MarketSerializer = {}
MarketSerializer.__index = MarketSerializer

local SAVE_PATH_TEMPLATE     = "%sFS25_MarketDynamics.xml"
local LEGACY_PATH_TEMPLATE   = "%smodSettings/FS25_MarketDynamics.xml"

function MarketSerializer.new()
    local self = setmetatable({}, MarketSerializer)
    return self
end

-- Persist current market state.
function MarketSerializer:save(coordinator)
    if not g_currentMission or not g_currentMission.missionInfo then
        MDMLog.warn("MarketSerializer: g_currentMission or missionInfo not available — cannot save")
        return
    end
    local savegameDir = g_currentMission.missionInfo.savegameDirectory
    if savegameDir == nil or savegameDir == "" then
        MDMLog.warn("MarketSerializer: no savegame directory — cannot save")
        return
    end

    local path    = SAVE_PATH_TEMPLATE:format(savegameDir .. "/")
    local xmlFile = createXMLFile("MDMSave", path, "marketDynamics")

    if not xmlFile then
        MDMLog.error("MarketSerializer: failed to create save file at " .. path)
        return
    end

    -- Schema version stamp
    setXMLString(xmlFile, "marketDynamics#version", "2")

    -- ── Futures contracts ────────────────────────────────────────────────
    local contracts = coordinator.futuresMarket and coordinator.futuresMarket.contracts or {}
    local i = 0
    for _, contract in pairs(contracts) do
        local base = "marketDynamics.futures.contract(" .. i .. ")"
        setXMLInt   (xmlFile, base .. "#id",                contract.id)
        setXMLInt   (xmlFile, base .. "#farmId",            contract.farmId)
        setXMLInt   (xmlFile, base .. "#fillTypeIndex",     contract.fillTypeIndex)
        setXMLString(xmlFile, base .. "#fillTypeName",      contract.fillTypeName)
        setXMLFloat (xmlFile, base .. "#quantity",          contract.quantity)
        setXMLFloat (xmlFile, base .. "#lockedPrice",       contract.lockedPrice)
        setXMLFloat (xmlFile, base .. "#deliveryTime",      contract.deliveryTime)
        setXMLFloat (xmlFile, base .. "#deliveryStartTime", contract.deliveryStartTime or 0)
        setXMLFloat (xmlFile, base .. "#delivered",         contract.delivered)
        setXMLString(xmlFile, base .. "#status",            contract.status)
        setXMLBool  (xmlFile, base .. "#isRealDays",        contract.isRealDays or false)
        setXMLFloat (xmlFile, base .. "#createdTimeScale",  contract.createdTimeScale or 1)
        if contract.upDealId then
            setXMLInt(xmlFile, base .. "#upDealId", contract.upDealId)
        end
        i = i + 1
    end

    -- ── Market Engine (Prices & History) ────────────────────────────────
    if coordinator.marketEngine then
        local k = 0
        for index, entry in pairs(coordinator.marketEngine.prices) do
            local base = "marketDynamics.prices.price(" .. k .. ")"
            setXMLInt  (xmlFile, base .. "#index",  index)
            setXMLFloat(xmlFile, base .. "#factor", entry.volatilityFactor)
            
            for m, hist in ipairs(entry.history) do
                local hBase = base .. ".history(" .. (m-1) .. ")"
                setXMLFloat(xmlFile, hBase .. "#price", hist.price)
                setXMLFloat(xmlFile, hBase .. "#time",  hist.time)
            end
            k = k + 1
        end
    end

    -- ── World Events (Cooldowns & Active) ───────────────────────────────
    if coordinator.worldEvents then
        -- Cooldowns
        local j = 0
        for id, event in pairs(coordinator.worldEvents.registry) do
            local base = "marketDynamics.events.event(" .. j .. ")"
            setXMLString(xmlFile, base .. "#id",          id)
            setXMLFloat (xmlFile, base .. "#lastFiredAt", event.lastFiredAt)
            j = j + 1
        end

        -- Active events
        local a = 0
        for id, active in pairs(coordinator.worldEvents.active) do
            local base = "marketDynamics.activeEvents.event(" .. a .. ")"
            setXMLString(xmlFile, base .. "#id",        id)
            setXMLFloat (xmlFile, base .. "#endsAt",    active.endsAt)
            setXMLFloat (xmlFile, base .. "#intensity", active.intensity)
            -- Persist per-event extra state (e.g. which crops were affected)
            local desc = coordinator.worldEvents.registry[id]
            if desc and desc.getExtraData then
                local extra = desc.getExtraData()
                if extra and extra ~= "" then
                    setXMLString(xmlFile, base .. "#extraData", extra)
                end
            end
            a = a + 1
        end
    end

    -- ── General settings ─────────────────────────────────────────────────
    local s = coordinator.settings
    if s then
        setXMLBool (xmlFile, "marketDynamics.settings#pricesEnabled",  s.pricesEnabled  ~= false)
        setXMLBool (xmlFile, "marketDynamics.settings#debugMode",      s.debugMode      == true)
        setXMLBool (xmlFile, "marketDynamics.settings#eventsEnabled",  s.eventsEnabled  ~= false)
        setXMLFloat(xmlFile, "marketDynamics.settings#eventFrequency", s.eventFrequency or 1.0)
        setXMLFloat(xmlFile, "marketDynamics.settings#futuresPenalty", s.futuresPenalty or 0.15)
        setXMLBool (xmlFile, "marketDynamics.settings#showEventNotifications", s.showEventNotifications ~= false)
        setXMLBool (xmlFile, "marketDynamics.settings#showContractHUD",       s.showContractHUD       ~= false)
        setXMLBool (xmlFile, "marketDynamics.settings#useRealDays",           s.useRealDays           == true)

        -- Disabled events: { [eventId] = true }
        local de = s.disabledEvents or {}
        local di = 0
        for id, _ in pairs(de) do
            local base = "marketDynamics.disabledEvents.event(" .. di .. ")"
            setXMLString(xmlFile, base .. "#id", id)
            di = di + 1
        end

        -- Custom fill types per event: { [eventId] = { name, ... } }
        local cft = s.eventCustomFillTypes or {}
        local ci = 0
        for eventId, list in pairs(cft) do
            if #list > 0 then
                local base = "marketDynamics.eventCustomFillTypes.event(" .. ci .. ")"
                setXMLString(xmlFile, base .. "#id", eventId)
                for fi, name in ipairs(list) do
                    setXMLString(xmlFile, base .. ".fillType(" .. (fi - 1) .. ")#name", name)
                end
                ci = ci + 1
            end
        end
    end

    if coordinator.marketEngine then
        setXMLFloat(xmlFile, "marketDynamics.settings#volatilityScale",
            coordinator.marketEngine.volatilityScale or 1.0)
    end

    -- ── Integration state ────────────────────────────────────────────────
    UPIntegration.save(xmlFile, "marketDynamics.upIntegration")

    saveXMLFile(xmlFile)
    delete(xmlFile)
    MDMLog.info("MarketSerializer: saved to " .. path)
end

-- Load and restore market state.
function MarketSerializer:load(coordinator)
    if not g_currentMission or not g_currentMission.missionInfo then
        MDMLog.info("MarketSerializer: g_currentMission or missionInfo not available — starting fresh")
        return
    end
    local savegameDir = g_currentMission.missionInfo.savegameDirectory
    if savegameDir == nil or savegameDir == "" then
        MDMLog.info("MarketSerializer: no savegame directory yet — starting fresh")
        return
    end

    local path    = SAVE_PATH_TEMPLATE:format(savegameDir .. "/")
    local xmlFile = loadXMLFile("MDMLoad", path)

    -- Migration: try old path (savegame/modSettings/) for saves from v1.1.4.0 and earlier
    if not xmlFile or xmlFile == 0 then
        local legacyPath = LEGACY_PATH_TEMPLATE:format(savegameDir .. "/")
        xmlFile = loadXMLFile("MDMLoad", legacyPath)
        if xmlFile and xmlFile ~= 0 then
            MDMLog.info("MarketSerializer: migrating from legacy path " .. legacyPath)
        end
    end

    if not xmlFile or xmlFile == 0 then
        MDMLog.info("MarketSerializer: no save file found — starting fresh")
        return
    end

    local version = tonumber(getXMLString(xmlFile, "marketDynamics#version") or "1")

    -- ── Restore futures contracts ─────────────────────────────────────────
    local i = 0
    while true do
        local base = "marketDynamics.futures.contract(" .. i .. ")"
        local id   = getXMLInt(xmlFile, base .. "#id")
        if not id then break end

        local contract = {
            id                = id,
            farmId            = getXMLInt   (xmlFile, base .. "#farmId"),
            fillTypeIndex     = getXMLInt   (xmlFile, base .. "#fillTypeIndex"),
            fillTypeName      = getXMLString(xmlFile, base .. "#fillTypeName"),
            quantity          = getXMLFloat (xmlFile, base .. "#quantity"),
            lockedPrice       = getXMLFloat (xmlFile, base .. "#lockedPrice"),
            deliveryTime      = getXMLFloat (xmlFile, base .. "#deliveryTime"),
            deliveryStartTime = getXMLFloat (xmlFile, base .. "#deliveryStartTime") or 0,
            bcManaged         = getXMLBool  (xmlFile, base .. "#bcManaged") or false,
            delivered         = getXMLFloat (xmlFile, base .. "#delivered"),
            status            = getXMLString(xmlFile, base .. "#status"),
            upDealId          = getXMLInt   (xmlFile, base .. "#upDealId"),
            isRealDays        = getXMLBool  (xmlFile, base .. "#isRealDays") or false,
            createdTimeScale  = getXMLFloat (xmlFile, base .. "#createdTimeScale") or 1,
        }

        if coordinator.futuresMarket then
            coordinator.futuresMarket.contracts[id] = contract
            if id >= coordinator.futuresMarket.nextId then
                coordinator.futuresMarket.nextId = id + 1
            end
        end
        i = i + 1
    end

    -- ── Restore Market Engine (Prices & History) ──────────────────────────
    if coordinator.marketEngine and version >= 2 then
        local k = 0
        while true do
            local base  = "marketDynamics.prices.price(" .. k .. ")"
            local index = getXMLInt(xmlFile, base .. "#index")
            if not index then break end

            local entry = coordinator.marketEngine.prices[index]
            if entry then
                entry.volatilityFactor = getXMLFloat(xmlFile, base .. "#factor") or 1.0
                
                -- Restore history
                entry.history = {}
                local m = 0
                while true do
                    local hBase = base .. ".history(" .. m .. ")"
                    local p     = getXMLFloat(xmlFile, hBase .. "#price")
                    if not p then break end
                    table.insert(entry.history, { price = p, time = getXMLFloat(xmlFile, hBase .. "#time") })
                    m = m + 1
                end
                
                -- Recalculate 'current' (base price was snapshotted in init())
                coordinator.marketEngine:_recalculate(index)
            end
            k = k + 1
        end
    end

    -- ── Restore event cooldowns ───────────────────────────────────────────
    local j = 0
    while true do
        local base  = "marketDynamics.events.event(" .. j .. ")"
        local evId  = getXMLString(xmlFile, base .. "#id")
        if not evId then break end

        local lastFired = getXMLFloat(xmlFile, base .. "#lastFiredAt")
        if coordinator.worldEvents and coordinator.worldEvents.registry[evId] then
            coordinator.worldEvents.registry[evId].lastFiredAt = lastFired or -math.huge
        end
        j = j + 1
    end

    -- ── Restore active events (v2+) ──────────────────────────────────────
    if coordinator.worldEvents and version >= 2 then
        local a = 0
        while true do
            local base = "marketDynamics.activeEvents.event(" .. a .. ")"
            local evId = getXMLString(xmlFile, base .. "#id")
            if not evId then break end

            local endsAt    = getXMLFloat (xmlFile, base .. "#endsAt")
            local intensity = getXMLFloat (xmlFile, base .. "#intensity")
            local extraData = getXMLString(xmlFile, base .. "#extraData") or ""
            coordinator.worldEvents:loadActiveEvent(evId, endsAt, intensity, extraData)
            a = a + 1
        end
    end

    -- ── Restore general settings ──────────────────────────────────────────
    if coordinator.settings then
        local s = coordinator.settings

        local pricesEnabled = getXMLBool(xmlFile, "marketDynamics.settings#pricesEnabled")
        if pricesEnabled ~= nil then s.pricesEnabled = pricesEnabled end

        local debugMode = getXMLBool(xmlFile, "marketDynamics.settings#debugMode")
        if debugMode ~= nil then
            s.debugMode = debugMode
            MDMLog.debugEnabled = debugMode
        end

        local eventsEnabled = getXMLBool(xmlFile, "marketDynamics.settings#eventsEnabled")
        if eventsEnabled ~= nil then s.eventsEnabled = eventsEnabled end

        local eventFrequency = getXMLFloat(xmlFile, "marketDynamics.settings#eventFrequency")
        if eventFrequency and eventFrequency > 0 then s.eventFrequency = eventFrequency end

        local futuresPenalty = getXMLFloat(xmlFile, "marketDynamics.settings#futuresPenalty")
        if futuresPenalty and futuresPenalty > 0 then s.futuresPenalty = futuresPenalty end

        local showEventNotifications = getXMLBool(xmlFile, "marketDynamics.settings#showEventNotifications")
        if showEventNotifications ~= nil then s.showEventNotifications = showEventNotifications end

        local showContractHUD = getXMLBool(xmlFile, "marketDynamics.settings#showContractHUD")
        if showContractHUD ~= nil then s.showContractHUD = showContractHUD end

        local useRealDays = getXMLBool(xmlFile, "marketDynamics.settings#useRealDays")
        if useRealDays ~= nil then s.useRealDays = useRealDays end

        -- Disabled events
        s.disabledEvents = {}
        local di = 0
        while true do
            local base = "marketDynamics.disabledEvents.event(" .. di .. ")"
            local evId = getXMLString(xmlFile, base .. "#id")
            if not evId then break end
            s.disabledEvents[evId] = true
            di = di + 1
        end

        -- Custom fill types per event
        s.eventCustomFillTypes = {}
        local ci = 0
        while true do
            local base    = "marketDynamics.eventCustomFillTypes.event(" .. ci .. ")"
            local eventId = getXMLString(xmlFile, base .. "#id")
            if not eventId then break end
            s.eventCustomFillTypes[eventId] = {}
            local fi = 0
            while true do
                local name = getXMLString(xmlFile, base .. ".fillType(" .. fi .. ")#name")
                if not name then break end
                table.insert(s.eventCustomFillTypes[eventId], name)
                fi = fi + 1
            end
            ci = ci + 1
        end
    end

    if coordinator.marketEngine then
        local vScale = getXMLFloat(xmlFile, "marketDynamics.settings#volatilityScale")
        if vScale and vScale > 0 then
            coordinator.marketEngine.volatilityScale = vScale
        end
    end

    -- ── Integration state ─────────────────────────────────────────────────
    UPIntegration.load(xmlFile, "marketDynamics.upIntegration")

    delete(xmlFile)
    MDMLog.info("MarketSerializer: restored version " .. version)
end

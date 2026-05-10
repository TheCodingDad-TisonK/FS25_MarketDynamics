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
    local xmlFile = XMLFile.create("MDMSave", path, "marketDynamics")

    if not xmlFile then
        MDMLog.error("MarketSerializer: failed to create save file at " .. path)
        return
    end

    -- Schema version stamp
    xmlFile:setString("marketDynamics#version", "2")
    
    -- Store absolute game time at save (v2.1+) to prevent immediate expiration on reload
    xmlFile:setFloat("marketDynamics#lastGameTime", MDMUtil.getGameTime())

    -- ── Futures contracts ────────────────────────────────────────────────
    local contracts = coordinator.futuresMarket and coordinator.futuresMarket.contracts or {}
    local i = 0
    for _, contract in pairs(contracts) do
        local base = "marketDynamics.futures.contract(" .. i .. ")"
        xmlFile:setInt   (base .. "#id",                contract.id)
        xmlFile:setInt   (base .. "#farmId",            contract.farmId)
        xmlFile:setInt   (base .. "#fillTypeIndex",     contract.fillTypeIndex)
        xmlFile:setString(base .. "#fillTypeName",      contract.fillTypeName)
        xmlFile:setFloat (base .. "#quantity",          contract.quantity)
        xmlFile:setFloat (base .. "#lockedPrice",       contract.lockedPrice)
        xmlFile:setFloat (base .. "#deliveryTime",      contract.deliveryTime or 0)
        xmlFile:setFloat (base .. "#deliveryStartTime", contract.deliveryStartTime or 0)
        xmlFile:setFloat (base .. "#delivered",         contract.delivered or 0)
        xmlFile:setString(base .. "#status",            contract.status or "active")
        xmlFile:setBool  (base .. "#isRealDays",        contract.isRealDays or false)
        xmlFile:setFloat (base .. "#createdTimeScale",  contract.createdTimeScale or 1)
        if contract.upDealId then
            xmlFile:setInt(base .. "#upDealId", contract.upDealId)
        end
        i = i + 1
    end

    -- ── Market Engine (Prices & History) ────────────────────────────────
    if coordinator.marketEngine then
        local k = 0
        for index, entry in pairs(coordinator.marketEngine.prices) do
            local base = "marketDynamics.prices.price(" .. k .. ")"
            xmlFile:setInt  (base .. "#index",  index)
            xmlFile:setFloat(base .. "#factor", entry.volatilityFactor)
            
            for m, hist in ipairs(entry.history) do
                local hBase = base .. ".history(" .. (m-1) .. ")"
                xmlFile:setFloat(hBase .. "#price", hist.price)
                xmlFile:setFloat(hBase .. "#time",  hist.time)
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
            xmlFile:setString(base .. "#id",          id)
            xmlFile:setFloat (base .. "#lastFiredAt", event.lastFiredAt)
            j = j + 1
        end

        -- Active events
        local a = 0
        for id, active in pairs(coordinator.worldEvents.active) do
            local base = "marketDynamics.activeEvents.event(" .. a .. ")"
            xmlFile:setString(base .. "#id",        id)
            xmlFile:setFloat (base .. "#endsAt",    active.endsAt)
            xmlFile:setFloat (base .. "#intensity", active.intensity)
            -- Persist per-event extra state (e.g. which crops were affected)
            local desc = coordinator.worldEvents.registry[id]
            if desc and desc.getExtraData then
                local extra = desc.getExtraData()
                if extra and extra ~= "" then
                    xmlFile:setString(base .. "#extraData", extra)
                end
            end
            a = a + 1
        end
    end

    -- ── General settings ─────────────────────────────────────────────────
    local s = coordinator.settings
    if s then
        xmlFile:setBool ("marketDynamics.settings#pricesEnabled",  s.pricesEnabled  ~= false)
        xmlFile:setBool ("marketDynamics.settings#debugMode",      s.debugMode      == true)
        xmlFile:setBool ("marketDynamics.settings#eventsEnabled",  s.eventsEnabled  ~= false)
        xmlFile:setFloat("marketDynamics.settings#eventFrequency", s.eventFrequency or 1.0)
        xmlFile:setFloat("marketDynamics.settings#futuresPenalty", s.futuresPenalty or 0.15)
        xmlFile:setBool ("marketDynamics.settings#showEventNotifications", s.showEventNotifications ~= false)
        xmlFile:setBool ("marketDynamics.settings#showContractHUD",       s.showContractHUD       ~= false)
        xmlFile:setBool ("marketDynamics.settings#useRealDays",           s.useRealDays           == true)

        -- Disabled events: { [eventId] = true }
        local de = s.disabledEvents or {}
        local di = 0
        for id, _ in pairs(de) do
            local base = "marketDynamics.disabledEvents.event(" .. di .. ")"
            xmlFile:setString(base .. "#id", id)
            di = di + 1
        end

        -- Custom fill types per event: { [eventId] = { name, ... } }
        local cft = s.eventCustomFillTypes or {}
        local ci = 0
        for eventId, list in pairs(cft) do
            if #list > 0 then
                local base = "marketDynamics.eventCustomFillTypes.event(" .. ci .. ")"
                xmlFile:setString(base .. "#id", eventId)
                for fi, name in ipairs(list) do
                    xmlFile:setString(base .. ".fillType(" .. (fi - 1) .. ")#name", name)
                end
                ci = ci + 1
            end
        end
    end

    if coordinator.marketEngine then
        xmlFile:setFloat("marketDynamics.settings#volatilityScale",
            coordinator.marketEngine.volatilityScale or 1.0)
    end

    -- ── Integration state ────────────────────────────────────────────────
    UPIntegration.save(xmlFile, "marketDynamics.upIntegration")

    xmlFile:save()
    xmlFile:delete()
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
    local xmlFile = nil
    
    if fileExists(path) then
        xmlFile = XMLFile.load("MDMLoad", path)
    end

    -- Migration: try old path (savegame/modSettings/) for saves from v1.1.4.0 and earlier
    if not xmlFile then
        local legacyPath = LEGACY_PATH_TEMPLATE:format(savegameDir .. "/")
        if fileExists(legacyPath) then
            xmlFile = XMLFile.load("MDMLoad", legacyPath)
            if xmlFile then
                MDMLog.info("MarketSerializer: migrating from legacy path " .. legacyPath)
            end
        end
    end

    if not xmlFile then
        MDMLog.info("MarketSerializer: no save file found — starting fresh")
        return
    end

    local version = tonumber(xmlFile:getString("marketDynamics#version") or "1")

    -- Restore last saved game time
    if coordinator then
        coordinator.lastSavedGameTime = xmlFile:getFloat("marketDynamics#lastGameTime") or 0
    end

    -- ── Restore futures contracts ─────────────────────────────────────────
    local i = 0
    while true do
        local base = "marketDynamics.futures.contract(" .. i .. ")"
        if not xmlFile:hasProperty(base) then break end

        local id = xmlFile:getInt(base .. "#id")
        local deliveryTime = xmlFile:getFloat(base .. "#deliveryTime")
        
        if id and deliveryTime and deliveryTime > 0 then
            local contract = {
                id                = id,
                farmId            = xmlFile:getInt   (base .. "#farmId"),
                fillTypeIndex     = xmlFile:getInt   (base .. "#fillTypeIndex"),
                fillTypeName      = xmlFile:getString(base .. "#fillTypeName"),
                quantity          = xmlFile:getFloat (base .. "#quantity"),
                lockedPrice       = xmlFile:getFloat (base .. "#lockedPrice"),
                deliveryTime      = deliveryTime,
                deliveryStartTime = xmlFile:getFloat (base .. "#deliveryStartTime") or 0,
                bcManaged         = xmlFile:getBool  (base .. "#bcManaged") or false,
                delivered         = xmlFile:getFloat (base .. "#delivered") or 0,
                status            = xmlFile:getString(base .. "#status") or "active",
                upDealId          = xmlFile:getInt   (base .. "#upDealId"),
                isRealDays        = xmlFile:getBool  (base .. "#isRealDays") or false,
                createdTimeScale  = xmlFile:getFloat (base .. "#createdTimeScale") or 1,
            }

            if coordinator.futuresMarket then
                coordinator.futuresMarket.contracts[id] = contract
                if id >= coordinator.futuresMarket.nextId then
                    coordinator.futuresMarket.nextId = id + 1
                end
            end
        else
            MDMLog.warn("MarketSerializer: contract entry " .. i .. " has invalid id/deliveryTime — skipping")
        end
        i = i + 1
    end

    -- ── Restore Market Engine (Prices & History) ──────────────────────────
    if coordinator.marketEngine and version >= 2 then
        local k = 0
        while true do
            local base  = "marketDynamics.prices.price(" .. k .. ")"
            if not xmlFile:hasProperty(base) then break end

            local index = xmlFile:getInt(base .. "#index")
            if index then
                local entry = coordinator.marketEngine.prices[index]
                if entry then
                    entry.volatilityFactor = xmlFile:getFloat(base .. "#factor") or 1.0
                    
                    -- Restore history
                    entry.history = {}
                    local m = 0
                    while true do
                        local hBase = base .. ".history(" .. m .. ")"
                        if not xmlFile:hasProperty(hBase) then break end

                        local p = xmlFile:getFloat(hBase .. "#price")
                        local t = xmlFile:getFloat(hBase .. "#time")
                        if p and t then
                            table.insert(entry.history, { price = p, time = t })
                        end
                        m = m + 1
                    end
                    
                    -- Recalculate 'current' (base price was snapshotted in init())
                    coordinator.marketEngine:_recalculate(index)
                end
            end
            k = k + 1
        end
    end

    -- ── Restore event cooldowns ───────────────────────────────────────────
    local j = 0
    while true do
        local base  = "marketDynamics.events.event(" .. j .. ")"
        if not xmlFile:hasProperty(base) then break end

        local evId  = xmlFile:getString(base .. "#id")
        local lastFired = xmlFile:getFloat(base .. "#lastFiredAt")
        
        if evId and coordinator.worldEvents and coordinator.worldEvents.registry[evId] then
            coordinator.worldEvents.registry[evId].lastFiredAt = lastFired or -math.huge
        end
        j = j + 1
    end

    -- ── Restore active events (v2+) ──────────────────────────────────────
    if coordinator.worldEvents and version >= 2 then
        local a = 0
        while true do
            local base = "marketDynamics.activeEvents.event(" .. a .. ")"
            if not xmlFile:hasProperty(base) then break end

            local evId = xmlFile:getString(base .. "#id")
            if evId then
                local endsAt    = xmlFile:getFloat (base .. "#endsAt")
                local intensity = xmlFile:getFloat (base .. "#intensity")
                local extraData = xmlFile:getString(base .. "#extraData") or ""
                coordinator.worldEvents:loadActiveEvent(evId, endsAt, intensity, extraData)
            end
            a = a + 1
        end
    end

    -- ── Restore general settings ──────────────────────────────────────────
    if coordinator.settings then
        local s = coordinator.settings

        local pricesEnabled = xmlFile:getBool("marketDynamics.settings#pricesEnabled")
        if pricesEnabled ~= nil then s.pricesEnabled = pricesEnabled end

        local debugMode = xmlFile:getBool("marketDynamics.settings#debugMode")
        if debugMode ~= nil then
            s.debugMode = debugMode
            MDMLog.debugEnabled = debugMode
        end

        local eventsEnabled = xmlFile:getBool("marketDynamics.settings#eventsEnabled")
        if eventsEnabled ~= nil then s.eventsEnabled = eventsEnabled end

        local eventFrequency = xmlFile:getFloat("marketDynamics.settings#eventFrequency")
        if eventFrequency and eventFrequency > 0 then s.eventFrequency = eventFrequency end

        local futuresPenalty = xmlFile:getFloat("marketDynamics.settings#futuresPenalty")
        if futuresPenalty and futuresPenalty > 0 then s.futuresPenalty = futuresPenalty end

        local showEventNotifications = xmlFile:getBool("marketDynamics.settings#showEventNotifications")
        if showEventNotifications ~= nil then s.showEventNotifications = showEventNotifications end

        local showContractHUD = xmlFile:getBool("marketDynamics.settings#showContractHUD")
        if showContractHUD ~= nil then s.showContractHUD = showContractHUD end

        local useRealDays = xmlFile:getBool("marketDynamics.settings#useRealDays")
        if useRealDays ~= nil then s.useRealDays = useRealDays end

        -- Disabled events
        s.disabledEvents = {}
        local di = 0
        while true do
            local base = "marketDynamics.disabledEvents.event(" .. di .. ")"
            if not xmlFile:hasProperty(base) then break end
            local evId = xmlFile:getString(base .. "#id")
            if evId then
                s.disabledEvents[evId] = true
            end
            di = di + 1
        end

        -- Custom fill types per event
        s.eventCustomFillTypes = {}
        local ci = 0
        while true do
            local base    = "marketDynamics.eventCustomFillTypes.event(" .. ci .. ")"
            if not xmlFile:hasProperty(base) then break end
            local eventId = xmlFile:getString(base .. "#id")
            if eventId then
                s.eventCustomFillTypes[eventId] = {}
                local fi = 0
                while true do
                    local name = xmlFile:getString(base .. ".fillType(" .. fi .. ")#name")
                    if not name then break end
                    table.insert(s.eventCustomFillTypes[eventId], name)
                    fi = fi + 1
                end
            end
            ci = ci + 1
        end
    end

    if coordinator.marketEngine then
        local vScale = xmlFile:getFloat("marketDynamics.settings#volatilityScale")
        if vScale and vScale > 0 then
            coordinator.marketEngine.volatilityScale = vScale
        end
    end

    -- ── Integration state ─────────────────────────────────────────────────
    UPIntegration.load(xmlFile, "marketDynamics.upIntegration")

    xmlFile:delete()
    MDMLog.info("MarketSerializer: restored version " .. version)
end

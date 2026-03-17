-- MarketSerializer.lua
-- Handles save/load of MDM market state to a per-savegame XML file.
--
-- Save path: <savegameDirectory>/modSettings/FS25_MarketDynamics.xml
--
-- What is persisted (v2):
--   futures contracts  — active/settled contracts
--   event cooldowns    — lastFiredAt per event
--   active events      — currently running events (restored via loadActiveEvent)
--   market prices      — volatilityFactor per fillType
--   price history      — daily history samples per fillType
--   general settings   — pricesEnabled, debugMode, volatilityScale
--   integration flags  — BC mode and UP mode
--
-- Author: tison (dev-1)

MarketSerializer = {}
MarketSerializer.__index = MarketSerializer

local SAVE_PATH_TEMPLATE = "%smodSettings/FS25_MarketDynamics.xml"

function MarketSerializer.new()
    local self = setmetatable({}, MarketSerializer)
    return self
end

-- Persist current market state.
function MarketSerializer:save(coordinator)
    local savegameDir = g_currentMission.missionInfo.savegameDirectory
    if savegameDir == nil or savegameDir == "" then
<<<<<<< HEAD
        MDMLog.warn("MarketSerializer: no savegame directory — cannot save")
        return
    end

    local path    = SAVE_PATH_TEMPLATE:format(savegameDir .. "/")
=======
        MDMLog.warning("MarketSerializer: no savegame directory — cannot save")
        return
    end
    local path = SAVE_PATH_TEMPLATE:format(savegameDir .. "/")
>>>>>>> dd58d3478e0389a83c5d177b110ebe5a7e5c440d
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
        setXMLInt   (xmlFile, base .. "#id",            contract.id)
        setXMLInt   (xmlFile, base .. "#farmId",        contract.farmId)
        setXMLInt   (xmlFile, base .. "#fillTypeIndex", contract.fillTypeIndex)
        setXMLString(xmlFile, base .. "#fillTypeName",  contract.fillTypeName)
        setXMLFloat (xmlFile, base .. "#quantity",      contract.quantity)
        setXMLFloat (xmlFile, base .. "#lockedPrice",   contract.lockedPrice)
        setXMLFloat (xmlFile, base .. "#deliveryTime",  contract.deliveryTime)
        setXMLFloat (xmlFile, base .. "#delivered",     contract.delivered)
        setXMLString(xmlFile, base .. "#status",        contract.status)
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
            a = a + 1
        end
    end

    -- ── General settings ─────────────────────────────────────────────────
    local s = coordinator.settings
    if s then
        setXMLBool(xmlFile, "marketDynamics.settings#pricesEnabled", s.pricesEnabled ~= false)
        setXMLBool(xmlFile, "marketDynamics.settings#debugMode",     s.debugMode     == true)
    end

    if coordinator.marketEngine then
        setXMLFloat(xmlFile, "marketDynamics.settings#volatilityScale",
            coordinator.marketEngine.volatilityScale or 1.0)
    end

    -- ── Integration flags ────────────────────────────────────────────────
    BCIntegration.save(xmlFile, "marketDynamics.bcIntegration")
    UPIntegration.save(xmlFile, "marketDynamics.upIntegration")

    saveXMLFile(xmlFile)
    delete(xmlFile)
    MDMLog.info("MarketSerializer: saved to " .. path)
end

-- Load and restore market state.
function MarketSerializer:load(coordinator)
    local savegameDir = g_currentMission.missionInfo.savegameDirectory
    if savegameDir == nil or savegameDir == "" then
        MDMLog.info("MarketSerializer: no savegame directory yet — starting fresh")
        return
    end
<<<<<<< HEAD

    local path    = SAVE_PATH_TEMPLATE:format(savegameDir .. "/")
=======
    local path = SAVE_PATH_TEMPLATE:format(savegameDir .. "/")
>>>>>>> dd58d3478e0389a83c5d177b110ebe5a7e5c440d
    local xmlFile = loadXMLFile("MDMLoad", path)

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
            id            = id,
            farmId        = getXMLInt   (xmlFile, base .. "#farmId"),
            fillTypeIndex = getXMLInt   (xmlFile, base .. "#fillTypeIndex"),
            fillTypeName  = getXMLString(xmlFile, base .. "#fillTypeName"),
            quantity      = getXMLFloat (xmlFile, base .. "#quantity"),
            lockedPrice   = getXMLFloat (xmlFile, base .. "#lockedPrice"),
            deliveryTime  = getXMLFloat (xmlFile, base .. "#deliveryTime"),
            delivered     = getXMLFloat (xmlFile, base .. "#delivered"),
            status        = getXMLString(xmlFile, base .. "#status"),
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

            local endsAt    = getXMLFloat(xmlFile, base .. "#endsAt")
            local intensity = getXMLFloat(xmlFile, base .. "#intensity")
            coordinator.worldEvents:loadActiveEvent(evId, endsAt, intensity)
            a = a + 1
        end
    end

    -- ── Restore general settings ──────────────────────────────────────────
    if coordinator.settings then
        local pricesEnabled = getXMLBool(xmlFile, "marketDynamics.settings#pricesEnabled")
        if pricesEnabled ~= nil then
            coordinator.settings.pricesEnabled = pricesEnabled
        end

        local debugMode = getXMLBool(xmlFile, "marketDynamics.settings#debugMode")
        if debugMode ~= nil then
            coordinator.settings.debugMode = debugMode
            MDMLog.debugEnabled = debugMode
        end
    end

    if coordinator.marketEngine then
        local vScale = getXMLFloat(xmlFile, "marketDynamics.settings#volatilityScale")
        if vScale and vScale > 0 then
            coordinator.marketEngine.volatilityScale = vScale
        end
    end

    -- ── Integration flags ─────────────────────────────────────────────────
    BCIntegration.load(xmlFile, "marketDynamics.bcIntegration")
    UPIntegration.load(xmlFile, "marketDynamics.upIntegration")

    delete(xmlFile)
    MDMLog.info("MarketSerializer: restored version " .. version)
end

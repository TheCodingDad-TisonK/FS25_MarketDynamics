-- MarketSerializer.lua
-- Handles save/load of MDM market state to a per-savegame XML file.
--
-- Save path: <savegameDirectory>/modSettings/FS25_MarketDynamics.xml
--
-- What is persisted:
--   futures contracts  — all fields needed to reconstruct active/settled contracts
--   event cooldowns    — lastFiredAt per event, so cooldowns survive reload
--   general settings   — pricesEnabled, debugMode
--   volatility scale   — stored on MarketEngine but serialized here
--   integration flags  — BC mode and UP mode (delegated to each integration module)
--
-- Versioning: a #version attribute is written. Currently "1".
-- Future schema changes should increment this and add a migration path in load().
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
-- coordinator = the MarketDynamics instance (g_MarketDynamics).
function MarketSerializer:save(coordinator)
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

    -- Schema version stamp — increment if the format ever changes
    setXMLString(xmlFile, "marketDynamics#version", "1")

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

    -- ── World event cooldowns (lastFiredAt per event) ────────────────────
    if coordinator.worldEvents then
        local j = 0
        for id, event in pairs(coordinator.worldEvents.registry) do
            local base = "marketDynamics.events.event(" .. j .. ")"
            setXMLString(xmlFile, base .. "#id",          id)
            setXMLFloat (xmlFile, base .. "#lastFiredAt", event.lastFiredAt)
            j = j + 1
        end
    end

    -- ── General settings ─────────────────────────────────────────────────
    local s = coordinator.settings
    if s then
        setXMLBool(xmlFile, "marketDynamics.settings#pricesEnabled", s.pricesEnabled ~= false)
        setXMLBool(xmlFile, "marketDynamics.settings#debugMode",     s.debugMode     == true)
    end

    -- ── Volatility scale (lives on MarketEngine but belongs in settings) ─
    if coordinator.marketEngine then
        setXMLFloat(xmlFile, "marketDynamics.settings#volatilityScale",
            coordinator.marketEngine.volatilityScale or 1.0)
    end

    -- ── Integration flags (delegated to each module) ─────────────────────
    BCIntegration.save(xmlFile, "marketDynamics.bcIntegration")
    UPIntegration.save(xmlFile, "marketDynamics.upIntegration")

    saveXMLFile(xmlFile)
    delete(xmlFile)
    MDMLog.info("MarketSerializer: saved to " .. path)
end

-- Load and restore market state from the savegame XML file.
-- No-op (fresh start) if the file does not exist.
-- coordinator = the MarketDynamics instance (g_MarketDynamics).
function MarketSerializer:load(coordinator)
    local savegameDir = g_currentMission.missionInfo.savegameDirectory
    if savegameDir == nil or savegameDir == "" then
        MDMLog.info("MarketSerializer: no savegame directory yet — starting fresh")
        return
    end

    local path    = SAVE_PATH_TEMPLATE:format(savegameDir .. "/")
    local xmlFile = loadXMLFile("MDMLoad", path)

    if not xmlFile or xmlFile == 0 then
        MDMLog.info("MarketSerializer: no save file found — starting fresh")
        return
    end

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
            -- Keep nextId ahead of the highest restored id so new contracts don't collide
            if id >= coordinator.futuresMarket.nextId then
                coordinator.futuresMarket.nextId = id + 1
            end
        end
        i = i + 1
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

    -- ── Restore general settings ──────────────────────────────────────────
    if coordinator.settings then
        local pricesEnabled = getXMLBool(xmlFile, "marketDynamics.settings#pricesEnabled")
        if pricesEnabled ~= nil then
            coordinator.settings.pricesEnabled = pricesEnabled
        end

        local debugMode = getXMLBool(xmlFile, "marketDynamics.settings#debugMode")
        if debugMode ~= nil then
            coordinator.settings.debugMode = debugMode
            MDMLog.debugEnabled = debugMode  -- keep Logger in sync immediately
        end
    end

    -- ── Restore volatility scale ──────────────────────────────────────────
    if coordinator.marketEngine then
        local vScale = getXMLFloat(xmlFile, "marketDynamics.settings#volatilityScale")
        if vScale and vScale > 0 then
            coordinator.marketEngine.volatilityScale = vScale
        end
    end

    -- ── Integration flags (delegated to each module) ──────────────────────
    BCIntegration.load(xmlFile, "marketDynamics.bcIntegration")
    UPIntegration.load(xmlFile, "marketDynamics.upIntegration")

    delete(xmlFile)
    MDMLog.info("MarketSerializer: loaded " .. i .. " contracts, " .. j .. " event states")
end

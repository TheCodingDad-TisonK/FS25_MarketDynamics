-- MarketSerializer.lua
-- Handles save/load of market state to savegame XML.
-- Path: <savegameDirectory>/modSettings/FS25_MarketDynamics.xml
--
-- Author: tison (dev-1)

MarketSerializer = {}
MarketSerializer.__index = MarketSerializer

local SAVE_PATH_TEMPLATE = "%smodSettings/FS25_MarketDynamics.xml"

function MarketSerializer.new()
    local self = setmetatable({}, MarketSerializer)
    return self
end

-- Save current market state
-- coordinator = MarketDynamics instance
function MarketSerializer:save(coordinator)
    local path = SAVE_PATH_TEMPLATE:format(g_currentMission.missionInfo.savegameDirectory .. "/")
    local xmlFile = createXMLFile("MDMSave", path, "marketDynamics")

    if not xmlFile then
        MDMLog.error("MarketSerializer: failed to create save file at " .. path)
        return
    end

    -- Version stamp
    setXMLString(xmlFile, "marketDynamics#version", "1")

    -- Save futures contracts
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

    -- Save world event state (lastFiredAt per event)
    if coordinator.worldEvents then
        local j = 0
        for id, event in pairs(coordinator.worldEvents.registry) do
            local base = "marketDynamics.events.event(" .. j .. ")"
            setXMLString(xmlFile, base .. "#id",          id)
            setXMLFloat (xmlFile, base .. "#lastFiredAt", event.lastFiredAt)
            j = j + 1
        end
    end

    saveXMLFile(xmlFile)
    delete(xmlFile)
    MDMLog.info("MarketSerializer: saved to " .. path)
end

-- Load and restore market state
function MarketSerializer:load(coordinator)
    local path = SAVE_PATH_TEMPLATE:format(g_currentMission.missionInfo.savegameDirectory .. "/")
    local xmlFile = loadXMLFile("MDMLoad", path)

    if not xmlFile then
        MDMLog.info("MarketSerializer: no save file found — starting fresh")
        return
    end

    -- Restore futures contracts
    local i = 0
    while true do
        local base = "marketDynamics.futures.contract(" .. i .. ")"
        local id = getXMLInt(xmlFile, base .. "#id")
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

    -- Restore event cooldowns
    local j = 0
    while true do
        local base = "marketDynamics.events.event(" .. j .. ")"
        local evId = getXMLString(xmlFile, base .. "#id")
        if not evId then break end

        local lastFired = getXMLFloat(xmlFile, base .. "#lastFiredAt")
        if coordinator.worldEvents and coordinator.worldEvents.registry[evId] then
            coordinator.worldEvents.registry[evId].lastFiredAt = lastFired or -math.huge
        end
        j = j + 1
    end

    delete(xmlFile)
    MDMLog.info("MarketSerializer: loaded " .. i .. " contracts, " .. j .. " event states")
end

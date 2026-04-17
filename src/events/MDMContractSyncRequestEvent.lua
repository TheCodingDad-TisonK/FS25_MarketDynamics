-- MDMContractSyncRequestEvent.lua
-- Client-to-Server network event. A client sends this upon joining to request a full contract sync.

MDMContractSyncRequestEvent = {}
local MDMContractSyncRequestEvent_mt = Class(MDMContractSyncRequestEvent, Event)
InitEventClass(MDMContractSyncRequestEvent, "MDMContractSyncRequestEvent")

function MDMContractSyncRequestEvent.emptyNew()
    return Event.new(MDMContractSyncRequestEvent_mt)
end

function MDMContractSyncRequestEvent.new()
    return MDMContractSyncRequestEvent.emptyNew()
end

function MDMContractSyncRequestEvent.sendToServer()
    if g_server == nil then
        g_client:getServerConnection():sendEvent(MDMContractSyncRequestEvent.new())
    end
end

function MDMContractSyncRequestEvent:writeStream(streamId, connection)
end

function MDMContractSyncRequestEvent:readStream(streamId, connection)
    self:run(connection)
end

function MDMContractSyncRequestEvent:run(connection)
    if connection:getIsServer() then return end

    if g_MarketDynamics and g_MarketDynamics.futuresMarket then
        MDMContractSyncEvent.sendToClient(connection, MDMContractSyncEvent.SYNC_FULL, g_MarketDynamics.futuresMarket.contracts)
    end
end

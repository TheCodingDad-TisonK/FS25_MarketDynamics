-- MDMContractRequestEvent.lua
-- Client-to-Server network event for contract actions (Create, Complete, Cancel, Delete).

MDMContractRequestEvent = {}
local MDMContractRequestEvent_mt = Class(MDMContractRequestEvent, Event)
InitEventClass(MDMContractRequestEvent, "MDMContractRequestEvent")

MDMContractRequestEvent.ACTION_CREATE = 1
MDMContractRequestEvent.ACTION_ADMIN_COMPLETE = 2
MDMContractRequestEvent.ACTION_ADMIN_CANCEL = 3
MDMContractRequestEvent.ACTION_ADMIN_DELETE = 4

function MDMContractRequestEvent.emptyNew()
    return Event.new(MDMContractRequestEvent_mt)
end

function MDMContractRequestEvent.new(action, params)
    local self = MDMContractRequestEvent.emptyNew()
    self.action = action
    self.params = params or {}
    return self
end

function MDMContractRequestEvent.sendToServer(action, params)
    if g_server ~= nil then
        MDMContractRequestEvent.execute(action, params)
    else
        g_client:getServerConnection():sendEvent(MDMContractRequestEvent.new(action, params))
    end
end

function MDMContractRequestEvent:writeStream(streamId, connection)
    streamWriteInt8(streamId, self.action)
    if self.action == MDMContractRequestEvent.ACTION_CREATE then
        streamWriteInt32(streamId, self.params.farmId)
        streamWriteInt32(streamId, self.params.fillTypeIndex)
        streamWriteString(streamId, self.params.fillTypeName)
        streamWriteFloat32(streamId, self.params.quantity)
        streamWriteFloat32(streamId, self.params.lockedPrice)
        streamWriteFloat32(streamId, self.params.deliveryTimeMs)
    else
        streamWriteInt32(streamId, self.params.contractId)
    end
end

function MDMContractRequestEvent:readStream(streamId, connection)
    self.action = streamReadInt8(streamId)
    self.params = {}
    if self.action == MDMContractRequestEvent.ACTION_CREATE then
        self.params.farmId = streamReadInt32(streamId)
        self.params.fillTypeIndex = streamReadInt32(streamId)
        self.params.fillTypeName = streamReadString(streamId)
        self.params.quantity = streamReadFloat32(streamId)
        self.params.lockedPrice = streamReadFloat32(streamId)
        self.params.deliveryTimeMs = streamReadFloat32(streamId)
    else
        self.params.contractId = streamReadInt32(streamId)
    end
    self:run(connection)
end

function MDMContractRequestEvent.execute(action, params)
    if not g_MarketDynamics or not g_MarketDynamics.futuresMarket then return end
    local fm = g_MarketDynamics.futuresMarket

    if action == MDMContractRequestEvent.ACTION_CREATE then
        fm:createContract(params)
    elseif action == MDMContractRequestEvent.ACTION_ADMIN_COMPLETE then
        fm:adminComplete(params.contractId)
    elseif action == MDMContractRequestEvent.ACTION_ADMIN_CANCEL then
        fm:adminCancel(params.contractId)
    elseif action == MDMContractRequestEvent.ACTION_ADMIN_DELETE then
        fm:adminDelete(params.contractId)
    end
end

function MDMContractRequestEvent:run(connection)
    if connection:getIsServer() then return end
    MDMContractRequestEvent.execute(self.action, self.params)
end

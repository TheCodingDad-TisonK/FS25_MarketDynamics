--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

AcceptContractEvent = {}
local AcceptContractEvent_mt = Class(AcceptContractEvent, Event)

InitEventClass(AcceptContractEvent, "AcceptContractEvent")

function AcceptContractEvent.emptyNew()
    local self = Event.new(AcceptContractEvent_mt)
    return self
end

function AcceptContractEvent.new(contractId, farmId)
    local self = AcceptContractEvent.emptyNew()
    self.contractId = contractId
    self.farmId = farmId
    return self
end

function AcceptContractEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.contractId)
    streamWriteInt32(streamId, self.farmId)
end

function AcceptContractEvent:readStream(streamId, connection)
    self.contractId = streamReadInt32(streamId)
    self.farmId = streamReadInt32(streamId)
    self:run(connection)
end

function AcceptContractEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent(AcceptContractEvent.new(self.contractId, self.farmId))
    end

    local contractManager = g_currentMission.CustomContracts.ContractManager
    contractManager:handleAcceptRequest(self.farmId, self.contractId)
end

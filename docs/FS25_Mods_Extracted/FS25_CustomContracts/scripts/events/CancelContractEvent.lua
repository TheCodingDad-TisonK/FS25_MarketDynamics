--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

CancelContractEvent = {}
local CancelContractEvent_mt = Class(CancelContractEvent, Event)

InitEventClass(CancelContractEvent, "CancelContractEvent")

function CancelContractEvent.emptyNew()
  local self = Event.new(CancelContractEvent_mt)
  return self
end

function CancelContractEvent.new(contractId, farmId)
  local self = CancelContractEvent.emptyNew()
  self.farmId = farmId
  self.contractId = contractId
  return self
end

function CancelContractEvent:writeStream(streamId, connection)
  streamWriteInt32(streamId, self.farmId)
  streamWriteInt32(streamId, self.contractId)
end

function CancelContractEvent:readStream(streamId, connection)
  self.farmId = streamReadInt32(streamId)
  self.contractId = streamReadInt32(streamId)
  self:run(connection)
end

function CancelContractEvent:run(connection)
  if not connection:getIsServer() then
    g_server:broadcastEvent(CancelContractEvent.new(self.contractId, self.farmId))
  end

  local contractManager = g_currentMission.CustomContracts.ContractManager
  contractManager:handleCancelRequest(self.farmId, self.contractId)
end

--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

DeleteContractEvent = {}
local DeleteContractEvent_mt = Class(DeleteContractEvent, Event)

InitEventClass(DeleteContractEvent, "DeleteContractEvent")

function DeleteContractEvent.emptyNew()
  local self = Event.new(DeleteContractEvent_mt)
  return self
end

function DeleteContractEvent.new(contractId, farmId)
  local self = DeleteContractEvent.emptyNew()
  self.contractId = contractId
  self.farmId = farmId
  return self
end

function DeleteContractEvent:writeStream(streamId, connection)
  streamWriteInt32(streamId, self.contractId)
  streamWriteInt32(streamId, self.farmId)
end

function DeleteContractEvent:readStream(streamId, connection)
  self.contractId = streamReadInt32(streamId)
  self.farmId = streamReadInt32(streamId)
  self:run(connection)
end

function DeleteContractEvent:run(connection)
  if not connection:getIsServer() then
    g_server:broadcastEvent(DeleteContractEvent.new(self.contractId, self.farmId))
  end

  local contractManager = g_currentMission.CustomContracts.ContractManager
  contractManager:handleDeleteRequest(self.farmId, self.contractId)
end

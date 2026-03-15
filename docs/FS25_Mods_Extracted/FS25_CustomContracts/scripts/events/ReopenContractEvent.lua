--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

ReopenContractEvent = {}
local ReopenContractEvent_mt = Class(ReopenContractEvent, Event)

InitEventClass(ReopenContractEvent, "ReopenContractEvent")

function ReopenContractEvent.emptyNew()
  local self = Event.new(ReopenContractEvent_mt)
  return self
end

function ReopenContractEvent.new(contractId, farmId)
  local self = ReopenContractEvent.emptyNew()
  self.contractId = contractId
  self.farmId = farmId
  return self
end

function ReopenContractEvent:writeStream(streamId, connection)
  streamWriteInt32(streamId, self.contractId)
  streamWriteInt32(streamId, self.farmId)
end

function ReopenContractEvent:readStream(streamId, connection)
  self.contractId = streamReadInt32(streamId)
  self.farmId = streamReadInt32(streamId)
  self:run(connection)
end

function ReopenContractEvent:run(connection)
  if not connection:getIsServer() then
    g_server:broadcastEvent(ReopenContractEvent.new(self.contractId, self.farmId))
  end

  local contractManager = g_currentMission.CustomContracts.ContractManager
  contractManager:handleReopenRequest(self.farmId, self.contractId)
end

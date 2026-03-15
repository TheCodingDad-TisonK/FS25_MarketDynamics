--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

CreateContractEvent = {}
local CreateContractEvent_mt = Class(CreateContractEvent, Event)

InitEventClass(CreateContractEvent, "CreateContractEvent")

function CreateContractEvent.emptyNew()
  local self = Event.new(CreateContractEvent_mt)
  return self
end

function CreateContractEvent.new(payload, farmId)
  local self = CreateContractEvent.emptyNew()
  self.payload = payload
  self.farmId = farmId
  return self
end

function CreateContractEvent:writeStream(streamId, connection)
  streamWriteInt32(streamId, self.farmId)
  streamWriteInt32(streamId, self.payload.fieldId)
  streamWriteString(streamId, self.payload.workType)
  streamWriteInt32(streamId, self.payload.reward)
  streamWriteString(streamId, self.payload.description)
  streamWriteInt32(streamId, self.payload.startPeriod)
  streamWriteInt32(streamId, self.payload.startDay)
  streamWriteInt32(streamId, self.payload.duePeriod)
  streamWriteInt32(streamId, self.payload.dueDay)
end

function CreateContractEvent:readStream(streamId, connection)
  self.farmId = streamReadInt32(streamId)
  self.payload = {
    fieldId     = streamReadInt32(streamId),
    workType    = streamReadString(streamId),
    reward      = streamReadInt32(streamId),
    description = streamReadString(streamId),
    startPeriod = streamReadInt32(streamId),
    startDay    = streamReadInt32(streamId),
    duePeriod   = streamReadInt32(streamId),
    dueDay      = streamReadInt32(streamId)
  }

  self:run(connection)
end

function CreateContractEvent:run(connection)
  if not connection:getIsServer() then
    g_server:broadcastEvent(CreateContractEvent.new(self.payload, self.farmId))
  end

  local farmId = self.farmId
  if farmId == nil or farmId == FarmManager.SPECTATOR_FARM_ID then
    return
  end

  local contractManager = g_currentMission.CustomContracts.ContractManager
  contractManager:handleCreateRequest(farmId, self.payload)
end

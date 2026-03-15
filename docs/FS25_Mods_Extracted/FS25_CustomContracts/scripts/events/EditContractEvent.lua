--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

EditContractEvent = {}
local EditContractEvent_mt = Class(EditContractEvent, Event)

InitEventClass(EditContractEvent, "EditContractEvent")

function EditContractEvent.emptyNew()
  local self = Event.new(EditContractEvent_mt)
  return self
end

function EditContractEvent.new(contractId, contractData, farmId)
  local self       = EditContractEvent.emptyNew()

  self.contractId  = contractId
  self.farmId      = farmId

  -- edited values
  self.fieldId     = contractData.fieldId
  self.workType    = contractData.workType
  self.reward      = contractData.reward
  self.description = contractData.description
  self.startPeriod = contractData.startPeriod
  self.startDay    = contractData.startDay
  self.duePeriod   = contractData.duePeriod
  self.dueDay      = contractData.dueDay

  return self
end

function EditContractEvent:writeStream(streamId, connection)
  streamWriteInt32(streamId, self.contractId)
  streamWriteInt32(streamId, self.farmId)

  streamWriteInt32(streamId, self.fieldId)
  streamWriteString(streamId, self.workType)
  streamWriteInt32(streamId, self.reward)
  streamWriteString(streamId, self.description or "")

  streamWriteInt32(streamId, self.startPeriod)
  streamWriteInt32(streamId, self.startDay)
  streamWriteInt32(streamId, self.duePeriod)
  streamWriteInt32(streamId, self.dueDay)
end

function EditContractEvent:readStream(streamId, connection)
  self.contractId  = streamReadInt32(streamId)
  self.farmId      = streamReadInt32(streamId)

  self.fieldId     = streamReadInt32(streamId)
  self.workType    = streamReadString(streamId)
  self.reward      = streamReadInt32(streamId)
  self.description = streamReadString(streamId)

  self.startPeriod = streamReadInt32(streamId)
  self.startDay    = streamReadInt32(streamId)
  self.duePeriod   = streamReadInt32(streamId)
  self.dueDay      = streamReadInt32(streamId)

  self:run(connection)
end

function EditContractEvent:run(connection)
  if not connection:getIsServer() then
    g_server:broadcastEvent(
      EditContractEvent.new(
        self.contractId,
        {
          fieldId     = self.fieldId,
          workType    = self.workType,
          reward      = self.reward,
          description = self.description,
          startPeriod = self.startPeriod,
          startDay    = self.startDay,
          duePeriod   = self.duePeriod,
          dueDay      = self.dueDay
        },
        self.farmId
      )
    )
  end

  local contractManager = g_currentMission.CustomContracts.ContractManager
  contractManager:handleEditRequest(self.farmId, self.contractId, {
    fieldId     = self.fieldId,
    workType    = self.workType,
    reward      = self.reward,
    description = self.description,
    startPeriod = self.startPeriod,
    startDay    = self.startDay,
    duePeriod   = self.duePeriod,
    dueDay      = self.dueDay
  })
end

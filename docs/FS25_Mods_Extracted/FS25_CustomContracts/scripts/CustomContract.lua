--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

CustomContract = {}
CustomContract.dir = g_currentModDirectory
CustomContract.modName = g_currentModName
CustomContract.__index = CustomContract
CustomContract_mt = Class(CustomContract)


CustomContract.STATUS = {
  OPEN      = "OPEN",
  ACCEPTED  = "ACCEPTED",
  COMPLETED = "COMPLETED",
  CANCELLED = "CANCELLED",
  EXPIRED   = "EXPIRED"
}

-- Intizialise function when creating a new CustomContract.
function CustomContract.new(id, creatorFarmId, fieldId, workType, reward, description, startPeriod, startDay, duePeriod,
                            dueDay)
  local self            = setmetatable({}, CustomContract_mt)

  self.id               = id
  self.creatorFarmId    = creatorFarmId
  self.contractorFarmId = nil
  self.fieldId          = fieldId
  self.workType         = workType
  self.reward           = reward
  self.status           = CustomContract.STATUS.OPEN
  self.description      = description or ""
  self.startPeriod      = startPeriod or -1
  self.startDay         = startDay or -1
  self.duePeriod        = duePeriod or -1
  self.dueDay           = dueDay or -1

  return self
end

function CustomContract:writeStream(streamId)
  streamWriteInt32(streamId, self.id)
  streamWriteInt32(streamId, self.creatorFarmId)
  streamWriteInt32(streamId, self.contractorFarmId or -1)
  streamWriteInt32(streamId, self.fieldId)
  streamWriteString(streamId, self.workType)
  streamWriteInt32(streamId, self.reward)
  streamWriteString(streamId, self.status)
  streamWriteString(streamId, self.description)
  streamWriteInt32(streamId, self.startPeriod)
  streamWriteInt32(streamId, self.startDay)
  streamWriteInt32(streamId, self.duePeriod)
  streamWriteInt32(streamId, self.dueDay)
end

function CustomContract.newFromStream(streamId)
  local id = streamReadInt32(streamId)
  local creatorFarmId = streamReadInt32(streamId)
  local contractorFarmId = streamReadInt32(streamId)
  local fieldId = streamReadInt32(streamId)
  local workType = streamReadString(streamId)
  local reward = streamReadInt32(streamId)
  local status = streamReadString(streamId)
  local description = streamReadString(streamId)
  local startPeriod = streamReadInt32(streamId)
  local startDay = streamReadInt32(streamId)
  local duePeriod = streamReadInt32(streamId)
  local dueDay = streamReadInt32(streamId)

  local contract = CustomContract.new(
    id,
    creatorFarmId,
    fieldId,
    workType,
    reward,
    description,
    startPeriod,
    startDay,
    duePeriod,
    dueDay
  )

  contract.contractorFarmId = contractorFarmId ~= -1 and contractorFarmId or nil
  contract.status = status

  return contract
end

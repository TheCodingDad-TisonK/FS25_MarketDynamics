--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

SyncContractsEvent = {}
local SyncContractsEvent_mt = Class(SyncContractsEvent, Event)

InitEventClass(SyncContractsEvent, "SyncContractsEvent")

function SyncContractsEvent.emptyNew()
  local self = Event.new(SyncContractsEvent_mt)
  return self
end

function SyncContractsEvent.new(contracts, nextId)
  local self = SyncContractsEvent.emptyNew()
  self.contracts = contracts
  self.nextId = nextId

  return self
end

function SyncContractsEvent:writeStream(streamId, connection)
  -- nextId
  streamWriteInt32(streamId, self.nextId)

  -- contract count
  local count = table.size(self.contracts)
  streamWriteInt32(streamId, count)

  for _, contract in pairs(self.contracts) do
    streamWriteInt32(streamId, contract.id)
    streamWriteInt32(streamId, contract.creatorFarmId)
    streamWriteInt32(streamId, contract.contractorFarmId or -1)
    streamWriteInt32(streamId, contract.fieldId)
    streamWriteString(streamId, contract.workType)
    streamWriteInt32(streamId, contract.reward)
    streamWriteString(streamId, contract.status)
    streamWriteString(streamId, contract.description or "")
    streamWriteInt32(streamId, contract.startPeriod)
    streamWriteInt32(streamId, contract.startDay)
    streamWriteInt32(streamId, contract.duePeriod)
    streamWriteInt32(streamId, contract.dueDay)
  end
end

function SyncContractsEvent:readStream(streamId, connection)
  self.nextId = streamReadInt32(streamId)
  local count = streamReadInt32(streamId)

  self.contracts = {}

  for i = 1, count do
    local id                  = streamReadInt32(streamId)
    local creatorFarmId       = streamReadInt32(streamId)
    local contractorFarmId    = streamReadInt32(streamId)
    local fieldId             = streamReadInt32(streamId)
    local workType            = streamReadString(streamId)
    local reward              = streamReadInt32(streamId)
    local status              = streamReadString(streamId)
    local description         = streamReadString(streamId)
    local startPeriod         = streamReadInt32(streamId)
    local startDay            = streamReadInt32(streamId)
    local duePeriod           = streamReadInt32(streamId)
    local dueDay              = streamReadInt32(streamId)

    local contract            = CustomContract.new(
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

    contract.contractorFarmId =
        contractorFarmId ~= -1 and contractorFarmId or nil
    contract.status           = status

    self.contracts[id]        = contract
  end

  self:run(connection)
end

function SyncContractsEvent:run(connection)
  local contractManager = g_currentMission.CustomContracts.ContractManager
  if contractManager == nil then
    return
  end

  -- overwrite local (client) state
  contractManager.contracts = self.contracts
  contractManager.nextId = self.nextId

  -- notify UI
  g_messageCenter:publish(MessageType.CUSTOM_CONTRACTS_UPDATED)
end

--
-- FS25 CustomContracts
--
-- @Author: Racc00n
-- @Version: 0.0.1.1
--

InitialClientStateEvent = {}
local InitialClientStateEvent_mt = Class(InitialClientStateEvent, Event)

InitEventClass(InitialClientStateEvent, "InitialClientStateEvent")

function InitialClientStateEvent.emptyNew()
  return Event.new(InitialClientStateEvent_mt)
end

function InitialClientStateEvent.new()
  return InitialClientStateEvent.emptyNew()
end

function InitialClientStateEvent:writeStream(streamId, connection)
  local contractManager = g_currentMission.CustomContracts.ContractManager

  contractManager:writeInitialClientState(streamId, connection)
end

function InitialClientStateEvent:readStream(streamId, connection)
  local contractManager = g_currentMission.CustomContracts.ContractManager

  contractManager:readInitialClientState(streamId, connection)

  self:run(connection)
end

function InitialClientStateEvent:run(connection)
  g_messageCenter:publish(MessageType.CUSTOM_CONTRACTS_UPDATED)
end

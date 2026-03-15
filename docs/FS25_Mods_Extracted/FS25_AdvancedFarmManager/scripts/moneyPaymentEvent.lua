MoneyPaymentEvent = {}
local MoneyPaymentEvent_mt = Class(MoneyPaymentEvent, Event)

InitEventClass(MoneyPaymentEvent, "MoneyPaymentEvent")

function MoneyPaymentEvent.emptyNew()
	return Event.new(MoneyPaymentEvent_mt)
end
---@class MoneyPaymentEvent
function MoneyPaymentEvent.new(farmId, price, moneyType)
  afmDebug("MoneyPaymentEvent-new")
	local self = MoneyPaymentEvent.emptyNew()
  self.farmId = farmId
  self.price = price
  self.moneyTypeId = moneyType.id
  self.moneyTypeTitle = moneyType.title
  self.moneyTypeStatistic = moneyType.statistic
	return self
end

function MoneyPaymentEvent:readStream(streamId, connection)
  -- Get data from clients
  self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
  self.price = streamReadInt32(streamId)
  self.moneyTypeId = streamReadInt8(streamId)
  self.moneyTypeTitle = streamReadString(streamId)
  self.moneyTypeStatistic = streamReadString(streamId)
	self:run(connection)
end

function MoneyPaymentEvent:writeStream(streamId, connection)
  -- Send data out to clients
  streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
  streamWriteInt32(streamId, self.price)
  streamWriteInt8(streamId, self.moneyTypeId)
  streamWriteString(streamId, self.moneyTypeTitle)
  streamWriteString(streamId, self.moneyTypeStatistic)
end

function MoneyPaymentEvent:run(connection)
  afmDebug("MoneyPaymentEvent-run")
  local moneyType = MoneyType.OTHER
  if self.moneyTypeId ~= nil and self.moneyTypeTitle ~= nil and self.moneyTypeStatistic ~= nil then
    moneyType = {
      id = self.moneyTypeId,
      title = self.moneyTypeTitle,
      statistic = self.moneyTypeStatistic
    }
  end
  if self.price ~= nil and self.farmId ~= nil then
      g_currentMission:addMoneyChange(-self.price, self.farmId, moneyType, true, true)
      local farm = g_farmManager:getFarmById(self.farmId)
      farm:changeBalance(-self.price, moneyType)
  end
  if connection:getIsServer() then
      g_messageCenter:publish(MoneyPaymentEvent, self.farmId, -self.price)

      return
  end
end

function MoneyPaymentEvent.sendEvent(farmId, price, moneyType)
  afmDebug("MoneyPaymentEvent-sendEvent")
  if g_currentMission.missionDynamicInfo.isMultiplayer then
      if g_server ~= nil then
          g_server:broadcastEvent(MoneyPaymentEvent.new(farmId, price, moneyType))
      else
          g_client:getServerConnection():sendEvent(MoneyPaymentEvent.new(farmId, price, moneyType))
      end
  else
      g_currentMission:addMoneyChange(-price, farmId, moneyType, true, true)
      local farm = g_farmManager:getFarmById(farmId)
      farm:changeBalance(-price, moneyType)
  end
end
-- Name: RS_addRemoveMoneyEvent
-- Author: DonQuacko

RS_addRemoveMoneyEvent = {}

local RS_addRemoveMoneyEvent_mt = Class(RS_addRemoveMoneyEvent, Event)
InitEventClass(RS_addRemoveMoneyEvent, "RS_addRemoveMoneyEvent")

function RS_addRemoveMoneyEvent.emptyNew()
    local self = Event.new(RS_addRemoveMoneyEvent_mt)

    return self
end

function RS_addRemoveMoneyEvent.new(amount, farmId, moneyType)
    local self = RS_addRemoveMoneyEvent.emptyNew()

    self.amount = amount
    self.farmId = farmId
    self.moneyTypeId = moneyType.id

    return self
end

function RS_addRemoveMoneyEvent:readStream(streamId, connection)
    self.amount = streamReadInt32(streamId)
    self.farmId = streamReadInt32(streamId, 0)
    self.moneyTypeId = streamReadInt32(streamId, MoneyType.OTHER.id)

    self:run(connection)
end

function RS_addRemoveMoneyEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.amount)
    streamWriteInt32(streamId, self.farmId, 0)
    streamWriteInt32(streamId, self.moneyTypeId, MoneyType.OTHER.id)
end

function RS_addRemoveMoneyEvent:run(connection)
    if not connection:getIsServer() then
        local moneyType = MoneyType.getMoneyTypeById(self.moneyTypeId)
        if g_currentMission ~= nil then
            g_currentMission:addMoney(self.amount, self.farmId, moneyType or MoneyType.OTHER, true, true)
        end
    end
end

---@class FireEmployeeEvent : Event
FireEmployeeEvent = {}
local FireEmployeeEvent_mt = Class(FireEmployeeEvent, Event)

function FireEmployeeEvent.new(employeeId)
    Logging.info("[FireEmployeeEvent] new(employeeId: %s)", tostring(employeeId))
    local self = Event.new(FireEmployeeEvent_mt)
    self.employeeId = employeeId
    return self
end

function FireEmployeeEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.employeeId)
end

function FireEmployeeEvent:readStream(streamId, connection)
    self.employeeId = streamReadInt32(streamId)
end

function FireEmployeeEvent:run(connection)
    if g_server ~= nil then
        g_employeeManager:fireEmployee(self.employeeId, true)
    end
end

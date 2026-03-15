---@class HireEmployeeEvent : Event
HireEmployeeEvent = {}
local HireEmployeeEvent_mt = Class(HireEmployeeEvent, Event)

function HireEmployeeEvent.new(name, skills)
    Logging.info("[HireEmployeeEvent] new(name: %s)", tostring(name))
    local self = Event.new(HireEmployeeEvent_mt)
    self.name = name
    self.skills = skills
    return self
end

function HireEmployeeEvent:writeStream(streamId, connection)
    streamWriteString(streamId, self.name)
    streamWriteInt32(streamId, self.skills.driving)
    streamWriteInt32(streamId, self.skills.harvesting)
    streamWriteInt32(streamId, self.skills.technical)
end

function HireEmployeeEvent:readStream(streamId, connection)
    self.name = streamReadString(streamId)
    self.skills = {
        driving = streamReadInt32(streamId),
        harvesting = streamReadInt32(streamId),
        technical = streamReadInt32(streamId)
    }
end

function HireEmployeeEvent:run(connection)
    if g_server ~= nil then
        g_employeeManager:hireEmployee(self.name, self.skills, true)
    end
end

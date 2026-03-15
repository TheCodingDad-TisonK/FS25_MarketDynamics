---@class FieldPolygonChangedEvent
FieldPolygonChangedEvent = {}
local FieldPolygonChangedEvent_mt = Class(FieldPolygonChangedEvent, Event)

InitEventClass(FieldPolygonChangedEvent, 'FieldPolygonChangedEvent')

function FieldPolygonChangedEvent.emptyNew()
    return Event.new(FieldPolygonChangedEvent_mt)
end

function FieldPolygonChangedEvent.new(vehicle)
    local self = FieldPolygonChangedEvent.emptyNew()
    self.vehicle = vehicle
    return self
end

function FieldPolygonChangedEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    CpUtil.debugVehicle(CpDebug.DBG_MULTIPLAYER, self.vehicle,
        'field polygon event: read stream')
    CpCourseGenerator.onReadStream(self.vehicle, streamId, connection)
    self:run(connection)
end

function FieldPolygonChangedEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    CpUtil.debugVehicle(CpDebug.DBG_MULTIPLAYER, self.vehicle,
        'field polygon event: write stream')
    CpCourseGenerator.onWriteStream(self.vehicle, streamId, connection)
end

-- Process the received event
function FieldPolygonChangedEvent:run(connection)
   
    if not connection:getIsServer() then
        -- event was received from a client, so we, the server broadcast it to all other clients now
        CpUtil.debugVehicle(CpDebug.DBG_MULTIPLAYER, self.vehicle,
            'sending field polygon event to all clients.')
        g_server:broadcastEvent(FieldPolygonChangedEvent.new(self.vehicle),
            nil, connection, self.vehicle)
    end
end

function FieldPolygonChangedEvent.sendEvent(vehicle)
    CpUtil.debugVehicle(CpDebug.DBG_MULTIPLAYER, vehicle,
        'field polygon event event.')
    if g_server ~= nil then
        g_server:broadcastEvent(FieldPolygonChangedEvent.new(vehicle), nil, nil,
            vehicle)
    else
        g_client:getServerConnection():sendEvent(
            FieldPolygonChangedEvent.new(vehicle))
    end
end
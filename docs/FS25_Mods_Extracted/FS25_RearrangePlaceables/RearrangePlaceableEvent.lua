RearrangePlaceableEvent = {}
RearrangePlaceableEvent_mt = Class(RearrangePlaceableEvent, Event)

InitEventClass(RearrangePlaceableEvent, "RearrangePlaceableEvent")

function RearrangePlaceableEvent.emptyNew()
    local self = Event.new(RearrangePlaceableEvent_mt)
    return self
end

function RearrangePlaceableEvent.new(OwnerPlaceable, X, Y, Z, A, B, C, Price)
    local self = RearrangePlaceableEvent.emptyNew()
    self.OwnerPlaceable = OwnerPlaceable

    self.X = X
    self.Y = Y
    self.Z = Z

    self.A = A
    self.B = B
    self.C = C

    self.Price = Price

    return self
end

function RearrangePlaceableEvent:readStream(streamId, connection)
    self.OwnerPlaceable = NetworkUtil.readNodeObject(streamId)

    self.X = streamReadFloat32(streamId)
    self.Y = streamReadFloat32(streamId)
    self.Z = streamReadFloat32(streamId)

    self.A = streamReadFloat32(streamId)
    self.B = streamReadFloat32(streamId)
    self.C = streamReadFloat32(streamId)

    self.Price = streamReadFloat32(streamId)

    self:run(connection)
end

function RearrangePlaceableEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.OwnerPlaceable)

    streamWriteFloat32(streamId, self.X)
    streamWriteFloat32(streamId, self.Y)
    streamWriteFloat32(streamId, self.Z)

    streamWriteFloat32(streamId, self.A)
    streamWriteFloat32(streamId, self.B)
    streamWriteFloat32(streamId, self.C)

    streamWriteFloat32(streamId, self.Price)
end

function RearrangePlaceableEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent(self)
    end
    if self.OwnerPlaceable ~= nil then
        if g_currentMission:getIsServer() or g_currentMission.isMasterUser then
            if self.OwnerPlaceable:getOwnerFarmId() ~= 0 then
                g_currentMission:addMoney(
                    -self.Price,
                    self.OwnerPlaceable:getOwnerFarmId(),
                    MoneyType.PROPERTY_MAINTENANCE,
                    true
                )
            end
        end

        removeFromPhysics(self.OwnerPlaceable.rootNode)
        setTranslation(self.OwnerPlaceable.rootNode, self.X, self.Y, self.Z)
        setWorldRotation(self.OwnerPlaceable.rootNode, self.A, self.B, self.C)
        addToPhysics(self.OwnerPlaceable.rootNode)
    end
end

function RearrangePlaceableEvent:sendEvent()
    if self.OwnerPlaceable ~= nil then
        if g_currentMission:getIsServer() or g_currentMission.isMasterUser then
            if self.OwnerPlaceable:getOwnerFarmId() ~= 0 then
                g_currentMission:addMoney(
                    -self.Price,
                    self.OwnerPlaceable:getOwnerFarmId(),
                    MoneyType.PROPERTY_MAINTENANCE,
                    true
                )
            end
        end
    end

    if g_server ~= nil then
        g_server:broadcastEvent(self)
    else
        g_client:getServerConnection():sendEvent(self)
    end
end

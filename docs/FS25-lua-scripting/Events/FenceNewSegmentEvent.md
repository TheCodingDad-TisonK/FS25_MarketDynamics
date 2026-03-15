## FenceNewSegmentEvent

**Description**

> Event for adding fence segment

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [readStream](#readstream)
- [run](#run)
- [writeStream](#writestream)

### emptyNew

**Description**

> Create instance of Event class

**Definition**

> emptyNew()

**Return Values**

| any | self | instance of class event |
|-----|------|-------------------------|

**Code**

```lua
function FenceNewSegmentEvent.emptyNew()
    return Event.new( FenceNewSegmentEvent _mt, NetworkNode.CHANNEL_MAIN)
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function FenceNewSegmentEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.fencePlaceable = NetworkUtil.readNodeObject(streamId)
        local fence = self.fencePlaceable:getFence()
        local templateIndex = streamReadUInt8(streamId)
        local templateId = fence:getSegmentTemplateIdByIndex(templateIndex)
        self.segment = fence:createNewSegment(templateId)
        self.segment:readStream(streamId, connection)

        self:run(connection)
    else
            local statusCode = streamReadUInt8(streamId)
            local segmentId = streamReadUInt16(streamId)
            local ex = streamReadFloat32(streamId)
            local ey = streamReadFloat32(streamId)
            local ez = streamReadFloat32(streamId)

            g_messageCenter:publish( FenceNewSegmentEvent , statusCode, segmentId, ex, ey, ez)
        end
    end

```

### run

**Description**

> Run action on receiving side

**Definition**

> run(Connection connection)

**Arguments**

| Connection | connection |
|------------|------------|

**Code**

```lua
function FenceNewSegmentEvent:run(connection)
    if self.fencePlaceable ~ = nil and self.fencePlaceable:getIsSynchronized() then
        local statusCode = FenceNewSegmentEvent.STATUS_CODE.SUCCESS

        if not self.segment:updateMeshes( true ) then
            statusCode = FenceNewSegmentEvent.STATUS_CODE.ERROR
        else
                local player = g_currentMission:getPlayerByConnection(connection)
                if player ~ = nil then
                    local farmId = player.farmId
                    if farmId ~ = nil then
                        local price = self.segment:getPrice()
                        g_currentMission:addMoney( - price, farmId, MoneyType.SHOP_PROPERTY_BUY, true )
                    end
                end

                self.segment:finalize()
            end

            if statusCode = = FenceNewSegmentEvent.STATUS_CODE.SUCCESS then
                -- broadcast new segment to all clients
                g_server:broadcastEvent( FenceSegmentEvent.new( self.fencePlaceable, self.segment), false , nil , self.fencePlaceable) -- last change
            end

            local ex, ey, ez = self.segment:getEndPos()

            -- send back info to client requesting new segment
            if not connection:getIsLocal() then
                connection:sendEvent( FenceNewSegmentEvent.newServerToClient(statusCode, self.segment.id, ex, ey, ez))
            else
                    g_messageCenter:publish( FenceNewSegmentEvent , statusCode, self.segment.id, ex, ey, ez)
                end
            end
        end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function FenceNewSegmentEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.fencePlaceable)

        local segmentId = self.segment:getId()
        local fence = self.fencePlaceable:getFence()
        local fenceTemplateIndex = fence:getSegmentTemplateIndexById(segmentId)
        streamWriteUInt8(streamId, fenceTemplateIndex)
        self.segment:writeStream(streamId, connection)
    else
            streamWriteUInt8(streamId, self.statusCode)
            streamWriteUInt16(streamId, self.segmentId)
            streamWriteFloat32(streamId, self.ex)
            streamWriteFloat32(streamId, self.ey)
            streamWriteFloat32(streamId, self.ez)
        end
    end

```
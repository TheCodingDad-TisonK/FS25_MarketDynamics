## FenceRequestDeleteSegmentEvent

**Description**

> Event for removing a fence segment

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
function FenceRequestDeleteSegmentEvent.emptyNew()
    return Event.new( FenceRequestDeleteSegmentEvent _mt, NetworkNode.CHANNEL_MAIN)
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
function FenceRequestDeleteSegmentEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.fencePlaceable = NetworkUtil.readNodeObject(streamId)
        self.segmentId = streamReadUInt16(streamId)
    else
            self.success = streamReadBool(streamId)
        end

        self:run(connection)
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
function FenceRequestDeleteSegmentEvent:run(connection)
    -- on client just publish the validate event
    if connection:getIsServer() then
        g_messageCenter:publish( FenceRequestDeleteSegmentEvent , self.success)
        return
    end

    if self.fencePlaceable ~ = nil and self.fencePlaceable:getIsSynchronized() then
        local fence = self.fencePlaceable:getFence()
        local segment = fence:getSegmentById( self.segmentId)

        if segment = = nil then
            connection:sendEvent( FenceRequestDeleteSegmentEvent.newServerToClient( false ))
            return
        end

        fence:removeSegment(segment)
        segment:delete()
        connection:sendEvent( FenceRequestDeleteSegmentEvent.newServerToClient( true ))

        -- broadcast deletion to all clients except sender
        g_server:broadcastEvent( FenceDeleteSegmentEvent.new( self.fencePlaceable, self.segmentId), false , connection)
    end
end

```

### writeStream

**Description**

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function FenceRequestDeleteSegmentEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.fencePlaceable)
        streamWriteUInt16(streamId, self.segmentId)
    else
            streamWriteBool(streamId, self.success)
        end
    end

```
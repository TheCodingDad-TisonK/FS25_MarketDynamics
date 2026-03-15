## FenceDeleteSegmentEvent

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
function FenceDeleteSegmentEvent.emptyNew()
    return Event.new( FenceDeleteSegmentEvent _mt, NetworkNode.CHANNEL_MAIN)
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
function FenceDeleteSegmentEvent:readStream(streamId, connection)
    self.fencePlaceable = NetworkUtil.readNodeObject(streamId)
    self.segmentId = streamReadUInt16(streamId)

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
function FenceDeleteSegmentEvent:run(connection)
    if self.fencePlaceable ~ = nil and self.fencePlaceable:getIsSynchronized() then
        -- broadcast deletion to all clients
        if g_server ~ = nil then
            g_server:broadcastEvent( self , false , nil )
        end

        local fence = self.fencePlaceable:getFence()
        local segment = fence:getSegmentById( self.segmentId)

        if segment ~ = nil then
            fence:removeSegment(segment)
            segment:delete()

            g_messageCenter:publish( FenceDeleteSegmentEvent , self.fencePlaceable, segment)
        end

        -- TODO:delete placeable if it was the last segment
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
function FenceDeleteSegmentEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.fencePlaceable)
    streamWriteUInt16(streamId, self.segmentId)
end

```
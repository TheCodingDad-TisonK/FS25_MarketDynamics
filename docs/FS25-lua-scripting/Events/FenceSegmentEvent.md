## FenceSegmentEvent

**Description**

> Event for adding fence segment

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
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
function FenceSegmentEvent.emptyNew()
    return Event.new( FenceSegmentEvent _mt, NetworkNode.CHANNEL_MAIN)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(Placeable fencePlaceable, Segment segment)

**Arguments**

| Placeable | fencePlaceable | fencePlaceable object |
|-----------|----------------|-----------------------|
| Segment   | segment        | segment instance      |

**Return Values**

| Segment | self |
|---------|------|

**Code**

```lua
function FenceSegmentEvent.new(fencePlaceable, segment)
    local self = FenceSegmentEvent.emptyNew()

    self.fencePlaceable = fencePlaceable
    self.segment = segment

    return self
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
function FenceSegmentEvent:readStream(streamId, connection)
    self.fencePlaceable = NetworkUtil.readNodeObject(streamId)
    local templateIndex = streamReadUInt8(streamId)

    local fence = self.fencePlaceable:getFence()
    local templateId = fence:getSegmentTemplateIdByIndex(templateIndex)
    self.segment = fence:createNewSegment(templateId)

    self.segment:readStream(streamId, connection)

    self:run(connection)
end

```

### run

**Description**

> Run action on receiving side

**Definition**

> run(Connection connection)

**Arguments**

| Connection | connection | connection |
|------------|------------|------------|

**Code**

```lua
function FenceSegmentEvent:run(connection)
    if self.fencePlaceable ~ = nil and self.fencePlaceable:getIsSynchronized() then

        -- segments should be valid because data was already validated on server
        self.segment:updateMeshes( true , false )
        self.segment:finalize()
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
function FenceSegmentEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.fencePlaceable)

    local segmentId = self.segment:getId()
    local fence = self.fencePlaceable:getFence()
    local fenceTemplateIndex = fence:getSegmentTemplateIndexById(segmentId)

    streamWriteUInt8(streamId, fenceTemplateIndex)
    self.segment:writeStream(streamId, connection)
end

```
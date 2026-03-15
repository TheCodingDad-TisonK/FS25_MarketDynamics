## PlaceableRiceFieldFieldEvent

**Description**

> Event for a rice field

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
function PlaceableRiceFieldFieldEvent.emptyNew()
    return Event.new( PlaceableRiceFieldFieldEvent _mt, NetworkNode.CHANNEL_MAIN)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new()

**Arguments**

| any | placeableRiceField |
|-----|--------------------|
| any | field              |

**Code**

```lua
function PlaceableRiceFieldFieldEvent.new(placeableRiceField, field)
    local self = PlaceableRiceFieldFieldEvent.emptyNew()

    self.placeableRiceField = placeableRiceField
    self.field = field

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
function PlaceableRiceFieldFieldEvent:readStream(streamId, connection)
    self.placeableRiceField = NetworkUtil.readNodeObject(streamId)

    local height = streamReadFloat32(streamId)
    local field = self.placeableRiceField:createNewField(height)

    local numVertices = streamReadUInt16(streamId)
    field.polygon = Polygon2D.new(numVertices)

    for i = 1 , numVertices do
        field.polygon:addPos(streamReadFloat32(streamId), streamReadFloat32(streamId))
    end

    field.waterHeight = streamReadFloat32(streamId)

    self.field = field

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
function PlaceableRiceFieldFieldEvent:run(connection)
    if self.placeableRiceField ~ = nil and self.placeableRiceField:getIsSynchronized() then

        self.placeableRiceField:finalizeNewField( self.field, true , function (statusCode)
            -- answer client with status code
            connection:sendEvent( PlaceableRiceFieldFieldAnswerEvent.new( self.placeableRiceField, statusCode))
        end )
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
function PlaceableRiceFieldFieldEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeableRiceField)

    streamWriteFloat32(streamId, self.field.height)

    streamWriteUInt16(streamId, self.field.polygon:getNumVertices())

    for _, vertex in ipairs( self.field.polygon:getVertices()) do
        streamWriteFloat32(streamId, vertex)
    end

    streamWriteFloat32(streamId, self.field.waterHeight)
end

```
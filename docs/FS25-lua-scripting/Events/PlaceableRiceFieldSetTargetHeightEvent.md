## PlaceableRiceFieldSetTargetHeightEvent

**Description**

> Event for setting rice field water target height

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
function PlaceableRiceFieldSetTargetHeightEvent.emptyNew()
    return Event.new( PlaceableRiceFieldSetTargetHeightEvent _mt)
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
| any | fieldIndex         |
| any | targetHeight       |

**Code**

```lua
function PlaceableRiceFieldSetTargetHeightEvent.new(placeableRiceField, fieldIndex, targetHeight)
    local self = PlaceableRiceFieldSetTargetHeightEvent.emptyNew()

    self.placeableRiceField = placeableRiceField
    self.fieldIndex = fieldIndex
    self.targetHeight = targetHeight

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
function PlaceableRiceFieldSetTargetHeightEvent:readStream(streamId, connection)
    self.placeableRiceField = NetworkUtil.readNodeObject(streamId)

    self.fieldIndex = streamReadUInt8(streamId)
    self.targetHeight = streamReadFloat32(streamId)

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
function PlaceableRiceFieldSetTargetHeightEvent:run(connection)
    if self.placeableRiceField ~ = nil and self.placeableRiceField:getIsSynchronized() then
        self.placeableRiceField:setWaterHeightTarget( self.fieldIndex, self.targetHeight, true )

        -- Server broadcasts to all clients
        if not connection:getIsServer() then
            g_server:broadcastEvent( self )
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
function PlaceableRiceFieldSetTargetHeightEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeableRiceField)

    streamWriteUInt8(streamId, self.fieldIndex)
    streamWriteFloat32(streamId, self.targetHeight)
end

```
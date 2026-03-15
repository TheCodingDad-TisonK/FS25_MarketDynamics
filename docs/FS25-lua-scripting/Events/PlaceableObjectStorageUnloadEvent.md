## PlaceableObjectStorageUnloadEvent

**Description**

> Event from client to server to unload a specific object and amount

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
function PlaceableObjectStorageUnloadEvent.emptyNew()
    return Event.new( PlaceableObjectStorageUnloadEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer objectInfoIndex, boolean objectAmount)

**Arguments**

| table   | object          | object                           |
|---------|-----------------|----------------------------------|
| integer | objectInfoIndex | index of object to unload        |
| boolean | objectAmount    | amount of objects to be unloaded |

**Code**

```lua
function PlaceableObjectStorageUnloadEvent.new(placeable, objectInfoIndex, objectAmount)
    local self = PlaceableObjectStorageUnloadEvent.emptyNew()
    self.placeable = placeable
    self.objectInfoIndex = objectInfoIndex
    self.objectAmount = objectAmount
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
function PlaceableObjectStorageUnloadEvent:readStream(streamId, connection)
    self.placeable = NetworkUtil.readNodeObject(streamId)
    self.objectInfoIndex = streamReadUIntN(streamId, PlaceableObjectStorage.NUM_BITS_OBJECT_INFO)
    self.objectAmount = streamReadUIntN(streamId, PlaceableObjectStorage.NUM_BITS_AMOUNT)
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
function PlaceableObjectStorageUnloadEvent:run(connection)
    if self.placeable ~ = nil and self.placeable:getIsSynchronized() and self.placeable.removeAbstractObjectsFromStorage ~ = nil then
        self.placeable:removeAbstractObjectsFromStorage( self.objectInfoIndex, self.objectAmount, connection)
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
function PlaceableObjectStorageUnloadEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeable)
    streamWriteUIntN(streamId, self.objectInfoIndex, PlaceableObjectStorage.NUM_BITS_OBJECT_INFO)
    streamWriteUIntN(streamId, self.objectAmount, PlaceableObjectStorage.NUM_BITS_AMOUNT)
end

```
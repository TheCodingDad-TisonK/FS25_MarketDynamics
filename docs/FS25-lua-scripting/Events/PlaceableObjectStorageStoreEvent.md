## PlaceableObjectStorageStoreEvent

**Description**

> Event from client to server to store the manual objects in the trigger

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
function PlaceableObjectStorageStoreEvent.emptyNew()
    return Event.new( PlaceableObjectStorageStoreEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(Object placeable)

**Arguments**

| Object | placeable | placeable object |
|--------|-----------|------------------|

**Return Values**

| Object | self |
|--------|------|

**Code**

```lua
function PlaceableObjectStorageStoreEvent.new(placeable)
    local self = PlaceableObjectStorageStoreEvent.emptyNew()
    self.placeable = placeable
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
function PlaceableObjectStorageStoreEvent:readStream(streamId, connection)
    self.placeable = NetworkUtil.readNodeObject(streamId)
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
function PlaceableObjectStorageStoreEvent:run(connection)
    if self.placeable ~ = nil and self.placeable:getIsSynchronized() and self.placeable.storePendingManualObjects ~ = nil then
        self.placeable:storePendingManualObjects()
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
function PlaceableObjectStorageStoreEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeable)
end

```